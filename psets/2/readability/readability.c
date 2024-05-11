#include <cs50.h>
#include <ctype.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

int determine_grade(string text);
int count_letters(string text);
int count_words(string text);
int count_sentences(string text);

int main(void)
{
    string text = get_string("Enter the text: \n");
    int grade = determine_grade(text);

    if (grade >= 16)
    {
        printf("Grade 16+\n");
    }
    else if (grade < 1)
    {
        printf("Before Grade 1\n");
    }
    else
    {
        printf("Grade %i\n", grade);
    }
}

int determine_grade(string text)
{
    // Coleman-Liau index = 0.0588 * L - 0.296 * S - 15.8
    // L = average number of letters per 100 words
    // S =  average number of sentences per 100 words
    int sentences = count_sentences(text);
    int words = count_words(text);
    int letters = count_letters(text);

    float L = (float) letters / words * 100;
    float S = (float) sentences / words * 100;
    float grade = 0.0588 * L - 0.296 * S - 15.8;

    return round(grade);
}

int count_letters(string text)
{
    int letters = 0;

    for (int i = 0, length = strlen(text); i < length; i++)
    {
        if (isalpha(text[i]))
        {
            letters++;
        }
    }

    return letters;
}

int count_words(string text)
{
    int words = 1;

    for (int i = 0, length = strlen(text); i < length; i++)
    {
        if (isspace(text[i]))
        {
            words++;
        }
    }

    return words;
}

int count_sentences(string text)
{
    int sentences = 0;

    for (int i = 0, length = strlen(text); i < length; i++)
    {
        if (text[i] == '.' || text[i] == '?' || text[i] == '!')
        {
            sentences++;
        }
    }

    return sentences;
}
