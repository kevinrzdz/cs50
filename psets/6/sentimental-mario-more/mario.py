import cs50


def main():
    height = get_height()
    number_spaces = height - 1
    number_hashes = 1

    while height > 0:
        print(" " * number_spaces, end="")
        print("#" * number_hashes, end="")
        print(" " * 2, end="")
        print("#" * number_hashes)

        number_spaces -= 1
        number_hashes += 1
        height -= 1


def get_height():
    while True:
        height = cs50.get_int("height: ")
        if 1 <= height <= 8:
            return height


main()
