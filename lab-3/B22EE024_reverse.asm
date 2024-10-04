.data
    input_str_rev: .space 100        # Space for user input
    result_rev: .space 100           # Space for the reversed string
    prompt: .asciiz "Enter a string: "  # Prompt for input
    newline_rev: .asciiz "\n"        # Newline character for formatting

.text
main:
    # Prompt user for input
    li $v0, 4
    la $a0, prompt
    syscall

    # Read input from user
    li $v0, 8
    la $a0, input_str_rev        # Store input in input_str_rev
    li $a1, 100                  # Limit input to 100 characters
    syscall

    jal reverse_string           # Call reverse function

    # Print the reversed string
    li $v0, 4
    la $a0, result_rev
    syscall

    # Print a newline for better formatting
    li $v0, 4
    la $a0, newline_rev
    syscall

    # Exit the program
    li $v0, 10
    syscall

reverse_string:
    la $t0, input_str_rev   # Start of input string
    move $t1, $t0

    # Find end of string
    loop_find_end_rev:
        lb $t2, 0($t1)
        beq $t2, $zero, done_find_end_rev  # Exit when null terminator is found
        addi $t1, $t1, 1
        j loop_find_end_rev
    done_find_end_rev:
        subi $t1, $t1, 1   # Move back to last character

    # Reverse the string
    la $t3, result_rev     # Store reversed string in result_rev
    loop_reverse:
        lb $t2, 0($t1)     # Load character from input
        sb $t2, 0($t3)     # Store character in result
        addi $t3, $t3, 1   # Move to next position in result
        subi $t1, $t1, 1   # Move to previous character in input
        bgt $t1, $t0, loop_reverse  # Continue until start pointer <= end

    # Copy the first character (if loop was skipped due to single-char string)
    lb $t2, 0($t1)
    sb $t2, 0($t3)
    addi $t3, $t3, 1
    
    # Add null terminator to result_rev
    sb $zero, 0($t3)
    jr $ra                 # Return
