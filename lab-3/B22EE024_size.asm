.data
    input_str_size: .space 100          # Space for user input (up to 100 characters)
    prompt_input: .asciiz "Enter a string: "  # Prompt for input
    prompt_size: .asciiz "Size of the string: "
    newline_size: .asciiz "\n"

.text
main:
    # Prompt user for input
    li $v0, 4
    la $a0, prompt_input
    syscall

    # Read input from user
    li $v0, 8
    la $a0, input_str_size        # Store input in input_str_size
    li $a1, 100                   # Limit input to 100 characters
    syscall

    # Initialize the counter to 0
    la $t0, input_str_size        # Load input string
    li $t1, 0                     # String length counter

    # Loop to calculate the string length
    loop_size:
        lb $t2, 0($t0)
        beq $t2, $zero, done_size  # Stop at null terminator
        beq $t2, 0x0A, done_size   # Stop at newline (ASCII 0x0A)
        addi $t1, $t1, 1           # Increment length
        addi $t0, $t0, 1           # Move to next character
        j loop_size

    done_size:
    # Print the size prompt
    li $v0, 4
    la $a0, prompt_size
    syscall

    # Print the size of the string
    li $v0, 1
    move $a0, $t1
    syscall

    # Print a newline for formatting
    li $v0, 4
    la $a0, newline_size
    syscall

    # Exit the program
    li $v0, 10
    syscall
