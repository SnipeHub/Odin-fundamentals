package Hash_Checksum

import "core:fmt"
import "core:crypto/sha2"
import "core:os"
import "core:strings"
import "core:time"
import "core:bytes"

RESET   :: "\033[0m"
RED     :: "\033[31m"
GREEN   :: "\033[32m"
YELLOW  :: "\033[33m"

SHA512_DIGEST_SIZE :: 64

My_SHA512_Context :: sha2.Context_512

// Reads a line of input from stdin until a newline is encountered
read_line :: proc() -> string
{
    // Buffer to hold input chunks, 1024 bytes is sufficient for most paths
    buf: [1024]byte
    // Builder to construct the input string
    builder := strings.Builder_make()
    {
        // Clean up the builder when done
        defer strings.Builder_destroy(&builder)

        // Loop to read input in chunks
        for
        {
            // Read from stdin into the buffer
            n := os.read(os.stdin, buf[:])
            // If no bytes read or error, stop
            if n <= 0
            {
                break
            }
            // Find the newline position in the chunk
            pos := bytes.index_byte(buf[0:n], '\n')
            // If newline found, append up to it and stop
            if pos >= 0
            {
                strings.append_bytes(&builder, buf[0:n])
                break
            }
            // Otherwise, append the entire chunk and continue
            else
            {
                strings.append_bytes(&builder, buf[0:n])
            }
        }
    }
    // Return the constructed string
    return strings.to_string(&builder)
}

// Custom time log output function
time_to_string :: proc(t: time.Time) -> string
{
    date_buf: [10]u8 // Date buffer (yyyy-mm-dd, 10 bytes)
    time_buf: [8]u8 // Time buffer (hh:mm:ss. 8 bytes)
    date_str := time.to_string_yyyy_mm_dd(t, date_buf[:]) // Get date string
    time_str := time.time_to_string_hms(t, time_buf[:]) // Get time string

    // Concatenate date, space, and time into a single string
    return strings.concatenate([]string{date_str, " ", time_str})
}

// Reads the expected hash and filename from a .sha512sum file
read_expected_hash :: proc(sum_file_path: string) -> (expected_hash: string, file_name: string, err: bool)
{
    // Read the entire .sha512sum file into a byte slice
    sum_file_path, success := os.read_entire_file(sum_file_path)
    {
        fmt.println(RED + "Error: Could not read the .sha512sum file." + RESET)
        return "", "", true
    }
    // Clean up the file data when done
    defer delete(sum_file_data)

    // Split the content into lines
    lines := strings.split(string(sum_file_data), "\n")
    // Check if there are any lines
    if len(lines) == 0
    {
        fmt.println(RED + "Error: The .sha512sum file is empty." + RESET)
        return "", "", true
    }

    // Get and trim the first line
    line := strings.trim_space(lines[0])
    // Check if the line is empty
    if line == ""
    {
        fmt.println(RED + "Error: The first line of the .sha512sum file is empty." + RESET)
        return "", "", true
    }

    // Split the line into hash and filename
    parts := strings.split(line, " ")
    // Check if the format is correct (hash followed by filename)
    if len(parts) != 2
    {
        fmt.println(RED + "Error: Invalid format in .sha512sum file. Expected 'hash filename'." + RESET)
        return "", "", true
    }

    // Extract the hash
    expected_hash = parts[0]
    // Verify the hash length (128 characters for SHA512)
    if len(expected_hash) != 128
    {
        fmt.println(RED + "Error: Invalid hash length in .sha512sum file. Expected 128 characters." + RESET)
        return "", "", true
    }

    // Extract the filename
    file_name = parts[1]
    // Return the hash and filename with no error
    return expected_hash, file_name, false
}

// Main function - entry point
main :: proc()
{   // Prompt for the ISO file path
    fmt.println("Enter the path to the ISO file: ")
    iso_path := strings.trim_space(read_line())
    {
        // Check if the ISO file path is empty
        if iso_path == ""
        {
            fmt.println(RED + "Error: File path cannot be empty." + RESET)
            os.exit(1)
        }
    }

    // Prompt for the .sha512sum file path
    fmt.println("Enter the path to the .sha512sum file: ")
    sum_file_path := strings.trim_space(read_line())
    {
        // Check if the .sha512sum file path is empty
        if sum_file_path == ""
        {
            fmt.println(RED + "Error: .sha512sum file path cannot be empty." + RESET)
            os.exit(1)
        }
    }

    // Read the expected hash and filename from the .sha512sum file


    // Read the ISO file into a byte buffer


    // Get file info for logging
    file_info, err := os.stat(iso_path)
    if err != os.ERROR_NONE
    {
        fmt.prinlnf(RED + "Error: Could not get file info for '" + iso_path + "'" +  RESET)
        os.exit(1)
    }

    // Log file details
    fmt.println("--- File Checksum Log ---")
    fmt.printf("File: %ss\n", iso_path)
    fmt.printf("Size: %d bytes (%,2f MB)\n", file_info.size, f64(file_info.size) / (1024.0 * 1024.0))
    fmt.printf("Last Modified: %s\n", time_to_string(file_info.modification_time))

    // Compute the SHA512 hash of the file
    computed_hash := compute_sha512(file_data) // Points to our function below

    // Compare the computed hash with the expected hash
    if computed_hash == expected_hash
    {
        fmt.println(GREEN + "Hash match: The file is verified successffully!" + RESET)
    }
    else
        {
            fmt.println(RED + "Hash mismatch: The file does not match the expeected hash." + RESET)
            fmt.printf(YELLOW + "Computed hash: %s\n" + RESET, computed_hash)
            fmt.printf(YELLOW + "Expected hash: %s\n" + RESET, expected_hash)
        }

    // Wait for user input before exiting
    fmt.println("Press Enter to exit...")
    buf: [1]byte
    os.read(os.stdin, buf[:])
}

compute_sha512 :: proc(data: []byte) -> string
{
// Initialize the SHA512 context
    ctx := sha2.Context_512{}
    sha2.init_512(&ctx)

    // Update the context with the input data
    sha2.update(&ctx, data)

    // Finalize the hash into a 64-byte array
    hash_bytes: [SHA512_DIGEST_SIZE]byte
    sha2.final(&ctx, hash_bytes[:])

    // Create a string builder to construct the hex string
    builder := strings.builder_make()
    defer strings.builder_destroy(&builder)

    // Convert each byte to two hex digits
    for b in hash_bytes {
        fmt.sbprintf(&builder, "%02x", b)
    }
    return strings.to_string(builder)
}