//
// Created by Gegel85 on 08/08/2021
//

#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

enum ObjectType {
	OBJ_NONE,
	OBJ_BUCKET,
	OBJ_MONSTER,
	OBJ_RIN,
};

struct ObjectRin {
	unsigned char skullX;
	unsigned char skullY;
};

struct ObjectMonster {
	char sprite;
	char ai;
};

struct ObjectBucket {
	short attach;
};

struct Object {
	char type;
	short x;
	short y;
	union {
		struct ObjectBucket bucket;
		struct ObjectMonster monster;
		struct ObjectRin rin;
	};
};

struct MapFile {
	char nbObj;
	unsigned char width;
	unsigned char height;
	unsigned short playerX;
	unsigned short playerY;
	struct Object objects[32];
	char compressedTiles[0];
};

bool addBucket(struct MapFile *file, int i)
{
	if (file->nbObj == 32) {
		fprintf(stderr, "Maximum number of objects reached\n");
		return false;
	}

	struct Object *obj = &file->objects[file->nbObj];

	printf("Adding bucket joint at %i %i\n", i * 4, file->height);
	obj->type = OBJ_BUCKET;
	obj->x = i * 4;
	obj->bucket.attach = file->height;
	file->nbObj++;
	return true;
}

bool fillBucket(struct MapFile *file, int i)
{
	struct Object *obj = NULL;

	printf("Adding bucket at %i %i\n", i * 4, file->height);
	for (int j = 0; j < file->nbObj; j++) {
		if (file->objects[j].type == OBJ_BUCKET && file->objects[j].x == i * 4)
			obj = &file->objects[j];
	}
	if (obj) {
		obj->y = file->height;
		return true;
	}
	fprintf(stderr, "Bucket at line #%i character %i is not attached\n", file->height + 1, i);
	return false;
}

bool processLine(char *line, struct MapFile *file)
{
	for (int i = 0; line[i] && line[i + 1]; i += 2) {
		line[i / 2] = line[i];
		if (line[i] != line[i + 1]) {
			fprintf(stderr, "Line #%i: Character %i '%c' (%i) does not match character %i '%c' (%i).\n", file->height + 1, i + 1, line[i], line[i], i + 2, line[i + 1], line[i + 1]);
			return false;
		}
		switch (line[i]) {
		case '|':
			if (!addBucket(file, i))
				return false;
			line[i / 2] = '1';
			continue;
		case 'P':
			file->playerX = (i * 4) * 8;
			file->playerY = file->height * 8;
			break;
		case 'B':
			fillBucket(file, i);
			break;
		default:
			continue;
		}
		line[i / 2] = ' ';
	}
	return true;
}

bool convertStream(FILE *in, const char *output)
{
	size_t n;
	struct MapFile file = {
		0, 0, 0, 0, 0
	};
	char *line = NULL;
	char *data = NULL;

	for (ssize_t s = getline(&line, &n, in); s >= 0; s = getline(&line, &n, in)) {
		while (line[s - 1] == '\n') {
			s--;
			line[s] = 0;
		}
		if (!s)
			continue;
		if (file.width == 0)
			file.width = s / 2;
		if (file.width != s / 2) {
			free(line);
			free(data);
			fprintf(stderr, "Line #%i doesn't have the same length as other lines\n", file.height + 1);
			return false;
		}
		if (!processLine(line, &file)) {
			free(data);
			free(line);
			return false;
		}
		data = realloc(data, (file.height + 1) * file.width);
		memcpy(&data[file.height * file.width], line, file.width);
		file.height++;
	}

	FILE *out = fopen(output, "wb");

	if (!out) {
		perror(output);
		return EXIT_FAILURE;
	}
	fwrite(
		&file,
		sizeof(char) +
		sizeof(unsigned char) +
		sizeof(unsigned char) +
		sizeof(unsigned short) +
		sizeof(unsigned short),
		1,
		out
	);
	for (int i = 0; i < file.nbObj; i++)
		fwrite(
			&file.objects[i],
			sizeof(char) +
			sizeof(short) +
			sizeof(short) +
			sizeof(short),
			1,
			out
		);

	unsigned char number = 0;
	char c = 0;

	for (int i = 0; data[i]; i++) {
		if (!strchr("0123456789abcdefghijklmnopqrstuvwxyz ", data[i])) {
			if (c) {
				fwrite(&number, 1, 1, out);
				if (c == ' ')
					c = 0;
				else if (c < '9')
					c -= '0' - 1;
				else
					c -= 'a' - 11;
				fwrite(&c, 1, 1, out);
			}
			number = 0;
			c = data[i];
			if (c == ' ')
				c = 0;
			else if (c < '9')
				c -= '0' - 1;
			else
				c -= 'a' - 11;
			fwrite(&c, 1, 1, out);
			c = 0;
			continue;
		}
		if (c != data[i] || number == 255) {
			if (c) {
				fwrite(&number, 1, 1, out);
				if (c == ' ')
					c = 0;
				else if (c < '9')
					c -= '0' - 1;
				else
					c -= 'a' - 11;
				fwrite(&c, 1, 1, out);
			}
			number = 0;
			c = data[i];
		}
		number++;
	}
	if (c) {
		fwrite(&number, 1, 1, out);
		if (c == ' ')
			c = 0;
		else if (c < '9')
			c -= '0' - 1;
		else
			c -= 'a' - 11;
		fwrite(&c, 1, 1, out);
	}
	number = 0;
	fwrite(&number, 1, 1, out);
	free(data);
	free(line);
	fclose(out);
	return true;
}

int convertFile(const char *input, const char *output)
{
	FILE *in;

	printf("Processing %s -> %s\n", input, output);
	in = fopen(input, "r");
	if (!in) {
		perror(input);
		return EXIT_FAILURE;
	}

	bool result = convertStream(in, output);

	fclose(in);
	if (result)
		return EXIT_SUCCESS;
	return EXIT_FAILURE;
}

int main(int argc, char **argv)
{
	if (argc <= 2) {
		printf("%s <file> <output>\n", argv[0]);
		return EXIT_FAILURE;
	}
	return convertFile(argv[1], argv[2]);
}