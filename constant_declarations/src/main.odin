package main

import "core:fmt"  

// Main function
main :: proc()
{
    // Declare an untyped string constant
    MESSAGE :: "This is a untyped string constant!"
    fmt.println(MESSAGE)

    // Declaring untyped integer constants
    X :: 5.0
    Y :: 10.0

    // Computing the constant from other constants
    SUM :: X + Y
    fmt.println("The sum of", X, "and", Y, "is", SUM)
    
    // Declaring a typed constant
    PI : f64 = 3.1415926535 // using a 64 bit floating-point type
    fmt.println("The value of PI is approximately", PI)

    // Declaring a typed constant
    FOUR_THIRDS : f64 = 4.0 / 3.0
    fmt.println("The value of 4/3 is approximately", FOUR_THIRDS)
    
    // Note: Constants cannot be changed after declaration
    // The following line would cause a compile-time error if uncommented
    //SUM = 20
}