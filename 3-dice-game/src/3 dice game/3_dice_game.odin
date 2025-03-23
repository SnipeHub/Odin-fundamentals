package main // this should be called main, as it is the entry point package, every Odin program belongs to a package

import "core:fmt"
import "core:math/rand" // for the dice rolls
import "core:os"
import "core:strconv" // to convert strings to integers
import "core:strings"
import "core:time" // clock

// ANSI color codes
RESET   :: "\033[0m"
RED     :: "\033[31m"
GREEN   :: "\033[32m"
YELLOW  :: "\033[33m"
BLUE    :: "\033[34m"
MAGENTA :: "\033[35m"
CYAN    :: "\033[36m"
WHITE   :: "\033[37m"

main :: proc() // this defines the main procedure (function), where execution starts
{
    rand.reset(u64(time.now()._nsec)) // seed random with current time
    credits := 5000 // Player starting credit variable, declares the variable and then initializes it to 1000
                    // := this is Odin's shorthand for declaring and assigning

    fmt.println(MAGENTA + "--- Welcome to 3 Dice! ---" + RESET)

    // Declare reusable variables once
    bytes_read: int
    err: os.Errno
    input_buffer: [256]u8 // Our memory buffer, for storing user input

    game_loop: for
    {
        fmt.printf(CYAN + "You have %d credits.\n" + RESET, credits) // printf is formatted print. %d is a placeholder for an integer and
                                                 // \n adds a new line
        if credits <= 0
        {
            fmt.println(RED + "You're out of credits! Game over" + RESET)
            break game_loop
        }

        /* Our betting options */
        bet: int // declares integer variable 'bet' to store the player's choice
        fmt.println(YELLOW + "Place your bet please:" + RESET)
        fmt.println("1. 500 credits")
        fmt.println("2. 1000 credits")
        fmt.println("3. 5000 credits")
        fmt.println("4. 10,000 credits")
        fmt.print(YELLOW + "Enter 1, 2, 3, or 4: " + RESET)

        bytes_read, err = os.read(os.stdin, input_buffer[:])
        if err != 0 || bytes_read <= 1 // <= 1 to account for just newline
        {
            fmt.println(RED + "Failed to read input! Defaulting to 1." + RESET)
            bet = 1
        }
        else
        {
                input_str := strings.trim_space(string(input_buffer[:bytes_read]))
                bet_ok: bool
                bet, bet_ok = strconv.parse_int(input_str)
                if !bet_ok || bet < 1 || bet > 4
                {
                    fmt.println("Invalid choice! Defaulting to 1.")
                    bet = 1
                }
        }

        bet_amount: int // declare variable "bet_amount" as integer
        switch bet
        {
        case 1: bet_amount = 500
        case 2: bet_amount = 1000
        case 3: bet_amount = 5000
        case 4: bet_amount = 10000
        case:   bet_amount = 500 // Default to 500 if somehow invalid
        }
        fmt.printf("Log: bet_amount set to %d\n", bet_amount)  // Confirm bet_amount

        if bet_amount > credits
        {
            fmt.println(RED + "Not enough credits! Bet set to remaining credits." + RESET)
            bet_amount = credits
        }

        // Select your dice number
        dice_number: int  // Declare outside, defaults to 0
        fmt.print(YELLOW + "Pick a number between 1 and 6: " + RESET)
        bytes_read, err = os.read(os.stdin, input_buffer[:])
        if err != 0 || bytes_read <= 1
        {
            fmt.println("Failed to read input! Defaulting to 1.")
            dice_number = 1
        }
        else
        {
            number_str := strings.trim_space(string(input_buffer[:bytes_read]))
            number_str = strings.trim_right(number_str, "\r")  // Handle Windows \r
            number_ok: bool
            dice_number, number_ok = strconv.parse_int(number_str)  // Assign to outer dice_number
            if !number_ok || dice_number < 1 || dice_number > 6
            {
                fmt.println("Invalid number! Defaulting to 1.")
                dice_number = 1
            }
        }
        fmt.printf("Log: You picked %d\n", dice_number)

        // Roll dice
        dice := [3]int{rand.int_max(6) + 1, rand.int_max(6) + 1, rand.int_max(6) + 1}
        fmt.printf(BLUE + "Dice rolls: %d, %d, %d\n" + RESET, dice[0], dice[1], dice[2])

        // calculate matches
        matches := 0
        for die in dice
        {
            fmt.printf("Log: Checking die %d against dice_number %d\n", die, dice_number)
            if die == dice_number
            {
                matches += 1
            }
        }
        fmt.printf("Log: Total matches = %d\n", matches)

        // Calculate winnings
        winnings := 0
        switch matches
        {
        case 1: winnings = bet_amount * 2
        case 2: winnings = bet_amount * 3
        case 3: winnings = bet_amount * 4
        case: winnings = 0
        }
        fmt.printf("Log: bet_amount = %d, winnings = %d\n", bet_amount, winnings)

        credits += winnings - bet_amount
        fmt.printf("Log: credits before = %d, after = %d\n", credits - (winnings - bet_amount), credits)
        if winnings > 0
        {
            net_gain := winnings - bet_amount // what you actually win beyond the bet
            fmt.printf(GREEN + "You matched %d dice! Won %d credits (net gain: %d).\n" + RESET, matches, winnings, net_gain)
        }
        else
        {
            fmt.println(RED + "No matches! You lost your bet." + RESET)
        }
        fmt.printf(CYAN + "New balance: %d credits\n" + RESET, credits)
        fmt.println("---")

        // Play again choice
        fmt.print(YELLOW + "Play again? (y:yes/n:no/r:restart): " + RESET)
        bytes_read, err = os.read(os.stdin, input_buffer[:])
        choice := "y" // Default to continue
        if err == 0 && bytes_read > 1
        {
            choice = strings.trim_space(string(input_buffer[:bytes_read]))
        }

        switch choice // 3 options for players to choose
        {
        case "n":
            fmt.println(MAGENTA + "=== Thanks for playing! ===" + RESET)
            fmt.print(YELLOW + "Press any key to continue..." + RESET)
            _, _ = os.read(os.stdin, input_buffer[:]) // wait for keypress, discard result
        break game_loop
        case "r":
            credits = 5000 // remember to set this to the starting credits, must match
            fmt.println(GREEN + "=== Game restarted! ===" + RESET)
        case "y":
            // continue loop
        case:
            fmt.println(RED + "Invalid choice! Continuing anyway." + RESET)
        }

    }

}
/* Lessons learned
 - Knowing when to bring variables in and out of scope, declaring re-usable ones for example
  - Memory allocation, on the stack is auto managed and no freeing needed. Heap memory must free it to avoid memory leaks,
  this is usually used for more larger applications, in this game, not needed.
   - Static arrays, memory is stack allocated
   - can declare empty variables that are then used later or declare and initilaze variable straight away*/