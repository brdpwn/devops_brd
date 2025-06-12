import string

class Alphabet:
    def __init__(self, language_code, character_list):
        self.language = language_code
        self.characters = character_list

    def show_letters(self):
        print("Alphabet:", ''.join(self.characters))

    def total_letters(self):
        return len(self.characters)

    def __str__(self):
        return f"{self.language} alphabet with {self.total_letters()} letters."


class EngAlphabet(Alphabet):
    __letter_count = 26  # приватне статичне поле

    def __init__(self):
        super().__init__('EN', list(string.ascii_uppercase))

    def contains(self, symbol):
        if symbol.upper() in self.characters:
            print(f"'{symbol}' is part of the English alphabet.")
            return True
        else:
            print(f"'{symbol}' is NOT part of the English alphabet.")
            return False

    def total_letters(self):
        return EngAlphabet.__letter_count

    @staticmethod
    def example(style='short'):
        if style == 'long':
            return ("The quick brown fox jumps over the lazy dog "
                    "while sipping tea on a rainy London evening.")
        return "The quick brown fox jumps over the lazy dog."


# ---------- Тестування ----------
if __name__ == "__main__":
    eng = EngAlphabet()

    eng.show_letters()
    print("Total letters:", eng.total_letters())

    eng.contains('G')
    eng.contains('Ж')

    print("Sample text:", EngAlphabet.example('long'))
    print(eng)


