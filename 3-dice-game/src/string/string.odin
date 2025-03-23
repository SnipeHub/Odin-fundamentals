package main

import "core:fmt"
import "core:unicode/utf8"

main :: proc()
{
    str := "some string text"
    second_rune := utf8.rune_at_pos(str, 5) // this will grab the letter at position 5, 0 counts as first position
    fmt.println(second_rune)
}