import re


def main():
    card_number = input("Number: ")
    print(credit_card_type(card_number) if luhn_algorithm(card_number) else "INVALID")


def luhn_algorithm(card_number):
    numbers = len(card_number)
    products = []
    sum = 0

    for i in range(numbers - 2, -1, -2):
        products.append(str((int(card_number[i]) * 2)))

    products = "".join(products)

    for number in products:
        sum += int(number)

    for i in range(numbers - 1, -1, -2):
        sum += int(card_number[i])

    return sum % 10 == 0


def credit_card_type(card_number):
    if re.match(r"^(34|37)\d{13}$", card_number):
        return "AMEX"
    elif re.match(r"^4(\d{12}|\d{15})", card_number):
        return "VISA"
    elif re.match(r"^(51|52|53|54|55)\d{14}$", card_number):
        return "MASTERCARD"
    else:
        return "INVALID"


main()
