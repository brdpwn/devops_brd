import random

def guess_game():
    number = random.randint(1, 100)
    for attempt in range(1, 6):
        guess = int(input(f"Attempt {attempt}: Guess the number (1-100): "))
        if guess == number:
            print("Congratulations! You guessed the right number.")
            return
        elif guess < number:
            print("Too low.")
        else:
            print("Too high.")
    print(f"Sorry, you've run out of attempts. The correct number was {number}.")

guess_game()
