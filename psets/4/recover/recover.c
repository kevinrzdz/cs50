#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define BLOCK_SIZE 512

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        printf("Usage: ./recover FILE\n");
        return 1;
    }

    uint8_t buffer[BLOCK_SIZE];
    int byte_size = sizeof(uint8_t);
    FILE *card = fopen(argv[1], "r");
    FILE *img = NULL;
    char filename[8];
    int file_number = 0;

    while (fread(buffer, byte_size, BLOCK_SIZE, card) == BLOCK_SIZE)
    {
        if (buffer[0] == 0xff && buffer[1] == 0xd8 && buffer[2] == 0xff)
        {
            if (img != NULL)
            {
                fclose(img);
            }

            sprintf(filename, "%03i.jpg", file_number++);
            img = fopen(filename, "w");
        }

        if (img != NULL)
        {
            fwrite(buffer, byte_size, BLOCK_SIZE, img);
        }
    }

    fclose(img);
    fclose(card);
}
