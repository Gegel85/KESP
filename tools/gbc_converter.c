#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <stdbool.h>
#include <png.h>

#define error(fmt, ...) fprintf(stderr, fmt "\n", ##__VA_ARGS__), exit(EXIT_FAILURE)

typedef unsigned char Tile[8][2];

typedef struct image_s {
	unsigned int width;
	unsigned int height;
	png_byte color_type;
	png_byte bit_depth;
	png_structp png_ptr;
	png_infop info_ptr;
	int number_of_passes;
	png_bytep *row_pointers;
} Image;

typedef struct __attribute__((__packed__)) bg_attr_s {
	unsigned char pal_no: 3;
	bool vram_bank: 1;
	bool unused: 1;
	bool x_flip: 1;
	bool y_flip: 1;
	bool bg_priority: 1;
} BGAttributes;

struct TileResult {
	BGAttributes attrs;
	unsigned char tile;
};

typedef union __attribute__((__packed__)) pal_s {
	struct __attribute__((__packed__)) {
		unsigned char r: 5;
		unsigned char g: 5;
		unsigned char b: 5;
		bool is_used: 1;
	};
	unsigned short val: 15;
} Palette[4];

typedef struct processed_image_s {
	Palette palettes[8];
	unsigned pal_nbr;
	unsigned char *tile_buff;
	unsigned tiles_nbr;
	BGAttributes *map;
	unsigned char *tile_map;
} ProcessedImage;

typedef struct pixel_s {
	unsigned char r;
	unsigned char g;
	unsigned char b;
	unsigned char a;
} Pixel;

Image read_png_file(const char *path)
{
	Image img;
	unsigned char header[8];
	FILE *fp = fopen(path, "rb");

	if (!fp)
		error("File %s could not be opened for reading: %s", path, strerror(errno));

	fread(header, 1, 8, fp);
	if (png_sig_cmp(header, 0, 8))
		error("File %s is not recognized as a PNG file", path);

	/* initialize stuff */
	img.png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
	if (!img.png_ptr)
		error("png_create_read_struct failed");

	img.info_ptr = png_create_info_struct(img.png_ptr);
	if (!img.info_ptr)
		error("png_create_info_struct failed");

	if (setjmp(png_jmpbuf(img.png_ptr)))
		error("Error during init_io");

	png_init_io(img.png_ptr, fp);
	png_set_sig_bytes(img.png_ptr, 8);

	png_read_info(img.png_ptr, img.info_ptr);

	img.width = png_get_image_width(img.png_ptr, img.info_ptr);
	img.height = png_get_image_height(img.png_ptr, img.info_ptr);
	img.color_type = png_get_color_type(img.png_ptr, img.info_ptr);
	img.bit_depth = png_get_bit_depth(img.png_ptr, img.info_ptr);

	img.number_of_passes = png_set_interlace_handling(img.png_ptr);
	png_read_update_info(img.png_ptr, img.info_ptr);

	if (setjmp(png_jmpbuf(img.png_ptr)))
		error("Error during read_image");

	size_t size = png_get_rowbytes(img.png_ptr, img.info_ptr);

	img.row_pointers = (png_bytep*) malloc(sizeof(png_bytep) * img.height);
	for (unsigned y = 0; y < img.height; y++) {
		img.row_pointers[y] = malloc(size);
		if (!img.row_pointers[y])
			error("Cannot malloc %lu", size);
	}

	png_read_image(img.png_ptr, img.row_pointers);

	fclose(fp);
	return img;
}

union pal_s convert_color(Pixel color)
{
	union pal_s pal;

	pal.r = color.r >> 3U;
	pal.g = color.g >> 3U;
	pal.b = color.b >> 3U;
	return pal;
}

bool palette_has_color(Palette pal, unsigned short color)
{
	for (int i = 0; i < 4; i++)
		if (pal[i].is_used && pal[i].val == color)
			return true;
	return false;
}

unsigned calc_mix_palettes_score(Palette pal1, Palette pal2)
{
	unsigned score = 0;
	unsigned needed = 0;

	for (int i = 0; i < 4; i++) {
		needed += pal2[i].is_used && !palette_has_color(pal1, pal2[i].val);
		score += pal2[i].is_used && !palette_has_color(pal1, pal2[i].val);
	}

	if (needed && pal1[4 - needed].is_used)
		return UINT_MAX;
	return score;
}

void mix_palettes(Palette *pal1, Palette pal2)
{
	unsigned current_color = 0;

	while ((*pal1)[current_color].is_used)
		current_color++;
	for (int i = 0; i < 4; i++) {
		if (pal2[i].is_used && !palette_has_color(*pal1, pal2[i].val)) {
			(*pal1)[current_color].is_used = true;
			(*pal1)[current_color].val = pal2[i].val;
			current_color++;
		}
	}
}

unsigned make_tile_palette(ProcessedImage *result, Pixel *tile[8], unsigned _x, unsigned _y)
{
	unsigned best_score = UINT_MAX;
	unsigned best_index = 0;
	unsigned pal = 0;
	Palette temp;
	unsigned char last_color = 0;

	memset(temp, 0, sizeof(temp));
	for (int x = 0; x < 8; x++) {
		for (int y = 0; y < 8; y++) {
			if (!tile[y][x].a)
				continue;

			unsigned short converted = convert_color(tile[y][x]).val;

			if (!palette_has_color(temp, converted)) {
				if (last_color == 4)
					error("Tile (x: %u, y: %u) has more than 4 colors", _x, _y);
				temp[last_color].is_used = true;
				temp[last_color].val = converted;
				last_color++;
			}
		}
	}

	for (unsigned i = 0; i < result->pal_nbr; i++) {
		unsigned score = calc_mix_palettes_score(result->palettes[i], temp);

		if (score < best_score) {
			best_score = score;
			best_index = i;
		}
	}

	if (best_score == UINT_MAX) {
		fprintf(stdout, "Adding new palette.\n");
		for (int j = 0; j < 4; j++)
			if (temp[j].is_used)
				fprintf(stdout, "%02x, %02x, %02x (%04x)\n", temp[j].r, temp[j].g, temp[j].b, temp[j].val);
		fprintf(stdout, "There are %i palettes in use:\n", result->pal_nbr);
		for (int i = 0; i < result->pal_nbr; i++) {
			fprintf(stdout, "Palette %i.\n", i);
			for (int j = 0; j < 4; j++)
				if (result->palettes[i][j].is_used)
					fprintf(stdout, "%02x, %02x, %02x (%04x)\n", result->palettes[i][j].r, result->palettes[i][j].g, result->palettes[i][j].b, result->palettes[i][j].val);
		}
		fprintf(stdout, "\n");
		if (result->pal_nbr == 8)
			error("No more palette available");
		memcpy(result->palettes[result->pal_nbr], temp, sizeof(temp));
		result->pal_nbr++;
	} else
		mix_palettes(&result->palettes[best_index], temp);
	return pal;
}

void populate_attribute(Tile tile, ProcessedImage *img, struct TileResult *attr)
{
	Tile tile_tmp;
	Tile tile_flip_x;
	Tile tile_flip_y;
	Tile tile_flip_x_y;

	memcpy(tile_tmp, tile, sizeof(tile_tmp));
	for (int y = 0; y < 8; y++) {
		for (int i = 0; i < 2; i++)
			tile_flip_y[7 - y][i] = tile_tmp[y][i];

		for (int x = 0; x < 8; x++) {
			for (int i = 0; i < 2; i++) {
				unsigned char col = tile_tmp[y][i] & 0b1U;

				tile_tmp[y][i] >>= 1U;

				tile_flip_x[y][i] <<= 1U;
				tile_flip_x[y][i] |= col;

				tile_flip_x_y[7 - y][i] <<= 1U;
				tile_flip_x_y[7 - y][i] |= col;
			}
		}
	}

	attr->tile = 0;
	while (attr->tile < img->tiles_nbr) {
		if (memcmp(tile_tmp, &img->tile_buff[attr->tile * 32], 32) == 0)
			return;
		if (memcmp(tile_flip_x, &img->tile_buff[attr->tile * 32], 32) == 0) {
			attr->attrs.x_flip = true;
			return;
		}
		if (memcmp(tile_flip_y, &img->tile_buff[attr->tile * 32], 32) == 0) {
			attr->attrs.y_flip = true;
			return;
		}
		if (memcmp(tile_flip_x_y, &img->tile_buff[attr->tile * 32], 32) == 0) {
			attr->attrs.x_flip = true;
			attr->attrs.y_flip = true;
			return;
		}
		attr->tile++;
	}
	if (img->tiles_nbr == 256)
		error("Too many tiles");
	img->tiles_nbr++;
	memcpy(&img->tile_buff[attr->tile * 32], tile_tmp, 32);
}

struct TileResult make_tile_data(ProcessedImage *result, Pixel *tile[8], unsigned pal_no)
{
	struct TileResult r = {{0, 0, false, false, false, false}, 0};
	Tile converted;

	r.attrs.pal_no = pal_no;
	for (unsigned x = 0; x < 8; x++) {
		for (unsigned y = 0; y < 8; y++) {
			unsigned char color = 0;
			union pal_s col = convert_color(tile[y][x]);

			if (tile[y][x].a) {
				for (int i = 0; i < 4; i++) {
					if (result->palettes[pal_no][i].is_used && col.val == result->palettes[pal_no][i].val) {
						color = i;
						break;
					}
				}
			}

			for (unsigned i = 0; i < 2; i++) {
				converted[y][i] <<= 1U;
				converted[y][i] |= color & 0b1U;
				color >>= 1U;
			}
		}
	}
	populate_attribute(converted, result, &r);
	return r;
}

ProcessedImage process_image(Image img)
{
	ProcessedImage result;

	if (png_get_color_type(img.png_ptr, img.info_ptr) != PNG_COLOR_TYPE_RGBA)
		error("File must be RGB");

	if (img.width % 8 || img.height % 8)
		error("Image size must be a multiple of 8");

	memset(&result, 0, sizeof(result));
	result.tile_buff = calloc(img.width * img.height / 4, sizeof(*result.tile_buff));
	result.map = calloc(img.width * img.height / 64, sizeof(*result.map));
	result.tile_map = calloc(img.width * img.height / 64, sizeof(*result.tile_map));
	if (!result.tile_buff)
		error("Cannot allocate %iB", (int)(img.width * img.height / 4 * sizeof(*result.tile_buff)));
	if (!result.map)
		error("Cannot allocate %iB", (int)(img.width * img.height / 64 * sizeof(*result.map)));
	if (!result.tile_map)
		error("Cannot allocate %iB", (int)(img.width * img.height / 64 * sizeof(*result.tile_map)));
	for (unsigned y = 0; y < img.height; y++) {
		Pixel *row = (Pixel *)img.row_pointers[y];
		for (unsigned x = 0; x < img.width; x++)
			if (row[x].a != 0 && row[x].a != 255)
				error("Only 0 and 255 are valid alpha values, but found %i", row[x].a);
	}

	for (unsigned y = 0; y < img.height; y += 8) {
		Pixel *row[8];

		for (int i = 0; i < 8; i++)
			row[i] = (Pixel *)img.row_pointers[y + i];

		for (unsigned x = 0; x < img.width; x += 8) {
			unsigned palette = make_tile_palette(&result, row, x, y);
			struct TileResult r = make_tile_data(&result, row, palette);

			result.map[(y * img.width + x) / 8] = r.attrs;
			result.tile_map[(y * img.width + x) / 8] = r.tile;
			for (int i = 0; i < 8; i++)
				row[i] += 8;
		}
	}
	return result;
}

int main(int argc, char **argv)
{
	if (argc != 6) {
		printf("Usage: %s <input> <output_tiles> <output_pal> <output_attr> <output_map>", argv[0]);
		return EXIT_FAILURE;
	}

	struct image_s img = read_png_file(argv[1]);

	printf("Processing image %s\n", argv[1]);
	ProcessedImage result = process_image(img);

	printf("Opening %s for writing\n", argv[2]);
	FILE *tiles = fopen(argv[2], "wb");
	if (!tiles)
		error("%s: %s", argv[2], strerror(errno));

	printf("Opening %s for writing\n", argv[3]);
	FILE *pals = fopen(argv[3], "wb");
	if (!pals)
		error("%s: %s", argv[3], strerror(errno));

	printf("Opening %s for writing\n", argv[4]);
	FILE *attrs = fopen(argv[4], "wb");
	if (!attrs)
		error("%s: %s", argv[4], strerror(errno));

	printf("Opening %s for writing\n", argv[5]);
	FILE *map = fopen(argv[5], "wb");
	if (!map)
		error("%s: %s", argv[5], strerror(errno));

	printf("Writing tile characters...\n");
	fwrite(result.tile_buff, 16, result.tiles_nbr, tiles);
	fclose(tiles);

	printf("Writing palettes...\n");
	fwrite(result.palettes, sizeof(Palette), result.pal_nbr, pals);
	fclose(pals);

	printf("Writing tile map attributes...\n");
	fwrite(result.map, sizeof(*result.map), img.width * img.height / 64, attrs);
	fclose(attrs);

	printf("Writing tile map...\n");
	fwrite(result.tile_map, sizeof(*result.tile_map), img.width * img.height / 64, map);
	fclose(map);
	return EXIT_SUCCESS;
}