#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

bool only_digits(string text);
char rotate(char character, int key);

int main(int argc, string argv[])
{

    if (argc != 2 || !only_digits(argv[1]))
    {
        printf("Usage: ./caesar key\n");
        return 1;
    }

    int key = atoi(argv[1]);

    if (key < 0)
    {
        printf("Key must be a positive integer\n");
        return 1;
    }

    string text = get_string("plaintext: ");

    int text_length = strlen(text);

    printf("ciphertext: ");
    for (int i = 0; i < text_length; i++)
    {
        char rotated = rotate(text[i], key);
        printf("%c", rotated);
    }
    printf("\n");
}

bool only_digits(string text)
{
    int text_length = strlen(text);
    bool all_digits = true;

    for (int i = 0; i < text_length; i++)
    {
        if (!isdigit(text[i]))
        {
            all_digits = false;
            break;
        }
    }

    return all_digits;
}

char rotate(char character, int key)
{
    if (!isalpha(character))
    {
        return character;
    }

    int result = character + (key % 26);

    if (islower(character) && result > 'z')
    {
        result -= 'z' + 1;
        result += 'a';
    }

    if (isupper(character) && result > 'Z')
    {
        result -= 'Z' + 1;
        result += 'A';
    }

    return (char) result;
}
