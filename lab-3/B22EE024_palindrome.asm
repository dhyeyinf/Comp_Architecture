.data
    prompt_str: .asciiz "Enter a string: "
    input_str: .space 50      # Space to store the user input (up to 50 characters)
    result_p: .asciiz "P\n"   # Output for palindrome
    result_np: .asciiz "NP\n" # Output for not a palindrome

.text
main:
    # Prompt the user to enter a string
    li $v0, 4
    la $a0, prompt_str
    syscall

    # Take the user input
    li $v0, 8              # Syscall for reading a string
    la $a0, input_str      # Store the input in input_str
    li $a1, 50             # Limit input size to 50 characters
    syscall

    # Remove the newline character from the input
    jal remove_newline

    # Check if the string is a palindrome
    la $t0, input_str      # Load input string
    jal is_palindrome      # Check if it's a palindrome

    # Based on the result, print "P" or "NP"
    beq $v0, $zero, print_np # If not palindrome, print "NP"
    j print_p              # Else, print "P"

# Function to check if the string is a palindrome
is_palindrome:
    la $t1, input_str      # Start of string
    move $t2, $t1          # Initialize pointer to find the end of the string

    # Find the end of the string
    loop_find_end:
        lb $t3, 0($t2)
        beq $t3, $zero, done_find_end  # Stop at null terminator
        addi $t2, $t2, 1               # Move to the next character
        j loop_find_end
    done_find_end:
        subi $t2, $t2, 1   # Point to the last character before the null terminator

    # Compare characters from both ends to check palindrome
    loop_compare:
        lb $t3, 0($t1)     # Load character from the start
        lb $t4, 0($t2)     # Load character from the end
        bne $t3, $t4, not_palindrome  # If mismatch, it's not a palindrome
        addi $t1, $t1, 1   # Move start pointer forward
        subi $t2, $t2, 1   # Move end pointer backward
        blt $t1, $t2, loop_compare  # Continue comparing until middle

    # If the loop completes, it's a palindrome
    li $v0, 1             # Return 1 for palindrome
    jr $ra

not_palindrome:
    li $v0, 0             # Return 0 for not a palindrome
    jr $ra

# Function to remove newline from the user input
remove_newline:
    la $t1, input_str      # Load the input string
remove_loop:
    lb $t2, 0($t1)         # Load byte
    beq $t2, $zero, remove_end # End if null terminator
    beq $t2, 10, replace_newline # If newline (ASCII 10), replace it
    addi $t1, $t1, 1       # Move to the next character
    j remove_loop

replace_newline:
    sb $zero, 0($t1)       # Replace newline with null terminator
    j remove_end

remove_end:
    jr $ra                 # Return from function

# Print "P" if palindrome
print_p:
    li $v0, 4
    la $a0, result_p
    syscall
    li $v0, 10            # Exit the program
    syscall

# Print "NP" if not a palindrome
print_np:
    li $v0, 4
    la $a0, result_np
    syscall
    li $v0, 10            # Exit the program
    syscall
