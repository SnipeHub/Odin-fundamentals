package main

import "core:fmt"
import "math_utils" // importing our custom package

main :: proc()
 {
    sum := math_utils.add(5, 3)
    difference := math_utils.subtract(5, 3)

    fmt.println("Sum:", sum)
    fmt.println("Difference:", difference)
 }
/* Each .odin file must have the same package name. A directory cannot contain more than 1 package.