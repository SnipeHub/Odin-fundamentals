package variables_and_loops

import "core:fmt"

main :: proc()
{
    x := 42 // implicit declaration
    name := "Tommy"

    fmt.println("x is: ", x)
    fmt.println("Hello,", name)

    /* our explicit example */
    fmt.println("---")
    fmt.println("Our implicit example:")

    age: i32 = 25
    is_student: bool = true
    year: int = 2000

    fmt.println("Age:", age)
    fmt.println("Is student?", is_student)
    fmt.println("here is the explicit variable: ", year)

    /* Our loops example 1 basic for loop */
    fmt.println("---")
    fmt.println("Our loop 1 example: Basic 'for' loop")

    count := 0 // what our count will start at
    for count < 5 // count up until hits 5, then stop
    {
        fmt.println("Count is:", count)
        count += 1
    }

    /* Our loops example 2 For loop with range */
    fmt.println("---")
    fmt.println("Our loop 1 example: 'for' loop range")

    for i in 1..=5
    {
        fmt.println("Number:", i)
    }

    /* combining both variables and loops together example 1 */
    fmt.println("---")
    for i := 1; i < 5; i += 1
    {
        fmt.println("Number:", i)
    }

}