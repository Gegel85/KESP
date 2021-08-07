/*
** EPITECH PROJECT, 2020
** RunnerGB
** File description:
** fixObjPals.c
*/

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int shiftPals(const char *palPath, char *tilesPath)
{
    unsigned short buffer[4];
    unsigned char tileBuffer[2];
    unsigned char tileBuffer2[2];
    FILE *stream = fopen(palPath, "rb");
    FILE *streamOut;

    if (!stream) {
        perror(palPath);
        return EXIT_FAILURE;
    }
    fread(buffer, sizeof(buffer), 1, stream);
    fclose(stream);
    stream = fopen(palPath, "wb");
    if (!stream) {
        perror(palPath);
        return EXIT_FAILURE;
    }
    fwrite(&buffer[3], sizeof(*buffer), 1, stream);
    fwrite(buffer, sizeof(*buffer), 3, stream);
    fclose(stream);

    stream = fopen(tilesPath, "rb");
    if (!stream) {
        perror(tilesPath);
        return EXIT_FAILURE;
    }
    tilesPath[strlen(tilesPath) - 1] = 'x';
    streamOut = fopen(tilesPath, "wb");
    if (!streamOut) {
        perror(tilesPath);
        return EXIT_FAILURE;
    }
    while (fread(tileBuffer, 1, sizeof(tileBuffer), stream)) {
        for (int i = 0; i < 8; i++) {
	   tileBuffer2[0] <<= 1;
	   tileBuffer2[1] <<= 1;
	   if ((tileBuffer[0] & 1U) || (tileBuffer[1] & 1U)) {
		   tileBuffer2[0] |= (tileBuffer[0] ^ 1) & 1;
		   tileBuffer2[1] |= (tileBuffer[0] ^ tileBuffer[1]) & 1;
	   }
	   tileBuffer[0] >>= 1;
	   tileBuffer[1] >>= 1;
        }
        fwrite(tileBuffer2, 1, sizeof(tileBuffer2), streamOut);
    }
    fclose(stream);
    fclose(streamOut);

    return EXIT_SUCCESS;
}

int main(int argc, char **argv)
{
    if (argc != 3)
        return EXIT_FAILURE;
    return shiftPals(argv[1], argv[2]);
}