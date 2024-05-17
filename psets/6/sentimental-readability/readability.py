import re


def main():
    text = input("Text: ")
    letters = re.findall(r"[A-Za-z]", text)
    sentences = re.findall(r"[.?!]", text)
    words = re.split(r"\s", text)

    index = round(grade(letters, words, sentences))

    if index > 16:
        print("Grade: 16+")
    elif index < 1:
        print("Before Grade 1")
    else:
        print(f"Grade: {index}")


def grade(letters, words, sentences):
    total_words = len(words)
    L = len(letters) / total_words * 100
    S = len(sentences) / total_words * 100
    return 0.0588 * L - 0.296 * S - 15.8


main()
