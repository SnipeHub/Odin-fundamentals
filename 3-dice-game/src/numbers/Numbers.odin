package main

import "core:fmt"
import "core:slice"

main :: proc()
{
    numbers := [5]int { 5, 20, 60, 99, 14 } // an array
    slice.sort(numbers[:]) // slice the fixed array, this will sort them into order, low to high
    fmt.println(numbers)
}

