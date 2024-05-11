#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>

bool valid_argc(int argc);
bool valid_key(string key);
string encrypt(string text, string key);

int main(int argc, string argv[])
{
    if (!valid_argc(argc))
    {
        printf("Usage: ./substitution key\n");
        return 1;
    }

    if (!valid_key(argv[1]))
    {
        printf("Key must contain 26 characters.\n");
        return 1;
    }

    string key = argv[1];
    string text = get_string("plaintext: ");

    string encrypted = encrypt(text, key);

    printf("ciphertext: %s\n", encrypted);
}

bool valid_argc(int argc)
{
    return argc == 2;
}

bool valid_key(string key)
{
    int key_length = 26;

    if (strlen(key) != key_length)
    {
        return false;
    }

    for (int i = 0; i < key_length; i++)
    {
        if (!isalpha(key[i]))
        {
            return false;
        }

        for (int j = 0; j < i; j++)
        {
            if (key[j] == key[i])
            {
                return false;
            }
        }
    }

    return true;
}

string encrypt(string text, string key)
{
    int text_length = strlen(text);

    for (int i = 0; i < text_length; i++)
    {
        if (isalpha(text[i]))
        {
            if (isupper(text[i]))
            {
                int character = text[i] - 'A';
                text[i] = toupper(key[character]);
            }
            else
            {
                int character = text[i] - 'a';
                text[i] = tolower(key[character]);
            }
        }
    }

    return text;
}
