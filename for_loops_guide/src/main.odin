package main

import "core:fmt"
import "core:math/rand"
import "core:os"
import "core:bufio"
import "core:strconv"

// helper function to read an integer from the user
read_int :: proc() -> i32
{
    // Create a buffered reader for stdin
    reader: bufio.Reader
    bufio.reader_init(&reader, os.stream_from_handle(os.stdin))
    defer bufio.reader_destroy(&reader) // clean up

    // Read a line from the user
    fmt.print("Enter your guess: ")
    line, err := bufio.reader_read_string(&reader, '\n')
    if err != nil
    {
        fmt.println("Error reading input!")
        return 0
    }

    // Trim the newline and convert to integer
    trimmed := line[:len(line)-1] // Remove '\n'
    guess_i64, ok := strconv.parse_i64(trimmed)
    if !ok
    {
        fmt.println("Please enter a valid number!")
        return 0
    }
    guess := i32(guess_i64)
    return guess
}

// number chase game
main :: proc()
{
    // Seed the random number generator and pick a secret number (1-5)
    secret := rand.int31_max(5) + 1

    // Welcome the player
    fmt.println("Welcome to Number Chase!")
    fmt.println("Guess a number between 1 and 5.")

    // Infinite loop to keep asking for guesses
    for
    {
        guess := read_int()
        if guess == secret
        {
            fmt.println("You found it! Great job!")
            break // Exit the loop when the guess is correct
        }
        else if guess > secret
        {
            fmt.println("Too high! Try again.")
        }
        else
        {
            fmt.println("Too low! Try again.")
        }
    }
}
