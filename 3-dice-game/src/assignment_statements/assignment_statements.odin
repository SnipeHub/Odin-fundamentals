package assignment_statements

import fmt "core:fmt"

main :: proc()
{
    // use := to declare a new vairable and let odin infer its type from the value
    // use = to assign a new value to an already declared variable
    // you can use multiple variables in one line by seperating them with commas
    // the := operator is shorthand for declaring a variable and assigning a value at the same time
    // So its two parts, : (declare) and = (assign)

    x: int = 123 // declares x as an integer and assigns 123
    fmt.println("Initial value of x:", x)

    y := 200 // Odin infers x is an int because 200 is an integer
    y = 637 // Changes 'y' to 637
    fmt.println("New value of y:", y)

    /* Multiple variables */
    a, b := 1, "hello" // Declares 'a' as 'int' (1) and 'b' as 'string' ("hello")
    fmt.println("Initial values: a =", a, ", b =", b)

    b, a = "bye", 5 // Reassigns them now so 'b' to "bye" and 'a' to 5
    fmt.println("After reassigmment: b =", b, ", a =", a)
}