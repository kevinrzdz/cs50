#include <cs50.h>
#include <stdio.h>

void print_char(char character, int times);

int main(void)
{
    char space = ' ';
    char hash = '#';
    int height;
    do
    {
        height = get_int("Height: ");
    }
    while (height < 1 || height > 8);

    int number_spaces = height - 1;
    int number_hashes = 1;

    while (height > 0)
    {

        print_char(space, number_spaces);
        print_char(hash, number_hashes);
        print_char(space, 2);
        print_char(hash, number_hashes);

        printf("\n");

        number_spaces--;
        number_hashes++;
        height--;
    }
}

void print_char(char character, int times)
{
    for (int i = 0; i < times; i++)
    {
        printf("%c", character);
    }
}
