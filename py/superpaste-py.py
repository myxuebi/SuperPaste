from pynput.keyboard import Controller
import time
import sys

def simulate_input(text, start_delay=0.1, char_delay=0.02):
    keyboard = Controller()
    time.sleep(start_delay)
    for char in text:
        keyboard.type(char)
        time.sleep(char_delay)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1)
    input_text = " ".join(sys.argv[1:])
    simulate_input(input_text)