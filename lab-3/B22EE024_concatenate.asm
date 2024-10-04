.data
    prompt_str1: .asciiz "Enter the first string: "
    prompt_str2: .asciiz "Enter the second string: "
    result: .space 100         # Allocate space for the concatenated result
    str1: .space 50            # Allocate space for user input (first string)
    str2: .space 50            # Allocate space for user input (second string)
    newline: .asciiz "\n"

.text
main:
    # Prompt for and read first string from user
    li $v0, 4
    la $a0, prompt_str1
    syscall

    li $v0, 8                # Syscall for string input
    la $a0, str1             # Address to store first string
    li $a1, 50               # Max number of characters
    syscall

    # Remove newline character from str1
    jal remove_newline

    # Prompt for and read second string from user
    li $v0, 4
    la $a0, prompt_str2
    syscall

    li $v0, 8                # Syscall for string input
    la $a0, str2             # Address to store second string
    li $a1, 50               # Max number of characters
    syscall

    # Remove newline character from str2
    jal remove_newline

    # Load addresses of str1 and str2
    la $t0, str1
    la $t1, str2
    la $t2, result           # Address where result will be stored

    # Concatenate str1
    jal concat

    # Concatenate str2
    la $t0, str2
    jal concat

    # Print the result
    li $v0, 4
    la $a0, result
    syscall

    # Exit the program
    li $v0, 10
    syscall

# Function to remove newline from a string
remove_newline:
    la $t1, str1             # Load address of string
remove_loop:
    lb $t2, 0($t1)           # Load byte from the string
    beq $t2, $zero, remove_end  # If null terminator, end
    beq $t2, 10, newline_found  # If newline (ASCII 10), replace it
    addi $t1, $t1, 1         # Move to next character
    j remove_loop
newline_found:
    sb $zero, 0($t1)         # Replace newline with null terminator
remove_end:
    jr $ra                   # Return from function

# Concatenation function
concat:
    lb $t3, 0($t0)           # Load byte from str1/str2
    beq $t3, $zero, concat_end  # End if null terminator is reached
    sb $t3, 0($t2)           # Store byte in result
    addi $t0, $t0, 1         # Move to next byte of str1/str2
    addi $t2, $t2, 1         # Move to next byte in result
    j concat                 # Repeat
concat_end:
    sb $zero, 0($t2)         # Null-terminate the result string
    jr $ra                   # Return from function
