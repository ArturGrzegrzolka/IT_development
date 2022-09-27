# import from other files
from graphics import logo
import random

print(logo)


def check_if_int(variable):
    """boolean function checks if variable is int."""
    try:
        int(variable)
        return True
    except ValueError:
        return False


def set_repetition_number(difficulty_level):
    """function returns the int number of repetition based on the difficulty level"""
    if difficulty_level == "easy":
        return 10
    else:
        return 5


def ask_difficulty_level():
    """function returns the difficulty level based on user input
    available values: easy, hard"""
    level = ""
    while level not in ("easy", "hard"):
        level = input("Choose the difficulty level: easy or hard: ").lower()
    return level


def no_more_guesses(number):
    """function prints when there is end of game due usage of all guesses"""
    print(f"You lost. You didn't guess the number {number}")


def starting_new_game():
    """function starts new game, based on user answer"""
    start_new_game = ""
    while start_new_game not in ("yes", "no"):
        start_new_game = input("Do you want to start the new game? yes or no: ").lower()
    if start_new_game == "no":
        print("This is the end of game. Thank you for playing.")
        return 0
    else:
        play_game()


def play_game():
    """funtion starts the guessing a number game :)"""
    max_number = ""
    while not check_if_int(max_number):
        max_number = input("Please provide max number in range for computer random number selection: ")

    print(f"I selected randomly number between 1 and {max_number}.")

    SELECTED_NUMBER = random.randint(1, int(max_number))
    REPETITION = set_repetition_number(ask_difficulty_level())
    available_repetition = REPETITION

    continue_guessing = True
    while continue_guessing:
        guessed_number = ""
        while not check_if_int(guessed_number):
            print(f"You have available {available_repetition} guesses.")
            guessed_number = input("Please guess the number: ")

        guessed_number = int(guessed_number)

        if guessed_number == SELECTED_NUMBER:
            print(f"Bravo, you guessed the number in {REPETITION - available_repetition - 1} attempts.")
            continue_guessing = False
            available_repetition = 0
            starting_new_game()
        elif guessed_number > SELECTED_NUMBER:
            print("Guessed number is too high.")
            continue_guessing = True
            available_repetition -= 1
            if available_repetition == 0:
                no_more_guesses(SELECTED_NUMBER)
                continue_guessing = False
                starting_new_game()
        else:
            print("Guessed number is too low.")
            continue_guessing = True
            available_repetition -= 1
            if available_repetition == 0:
                no_more_guesses(SELECTED_NUMBER)
                continue_guessing = False
                starting_new_game()

play_game()