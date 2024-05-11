#include <cs50.h>
#include <stdio.h>

bool luhn_algorithm(long card_number);
int count_digits(long num);
string card_type(long card_number);

int main(void)
{
    long card_number = get_long("Number: ");

    if (count_digits(card_number) < 13 || count_digits(card_number) > 16)
    {
        printf("%s\n", "INVALID");
        return 0;
    }

    if (luhn_algorithm(card_number))
    {
        printf("%s\n", card_type(card_number));
    }
    else
    {
        printf("%s\n", "INVALID");
    }
}

bool luhn_algorithm(long card_number)
{
    int sum = 0;
    bool double_digit = false;

    while (card_number > 0)
    {
        int digit = card_number % 10;

        if (double_digit)
        {
            digit *= 2;

            if (digit > 9)
            {
                digit -= 9;
            }
        }

        sum += digit;

        card_number /= 10;
        double_digit = !double_digit;
    }

    return sum % 10 == 0;
}

int count_digits(long num)
{
    int count = 0;
    while (num > 0)
    {
        count++;
        num /= 10;
    }
    return count;
}

string card_type(long card_number)
{
    int digits = count_digits(card_number);
    while (card_number >= 100)
    {
        card_number /= 10;
    }

    if (digits == 15 && (card_number == 34 || card_number == 37))
    {
        return "AMEX";
    }

    if (digits == 16 && (card_number == 51 || card_number == 52 || card_number == 53 || card_number == 54 || card_number == 55))
    {
        return "MASTERCARD";
    }

    if ((digits == 13 || digits == 16) && card_number / 10 == 4)
    {
        return "VISA";
    }

    return "INVALID";
}
