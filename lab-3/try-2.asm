.data
    prompt_str1: .asciiz "Enter the first string: "
    prompt_str2: .asciiz "Enter the second string: "
    result_concat: .asciiz "\nConcatenated string: "
    result_size: .asciiz "\nSize of the string: "
    result_rev: .asciiz "\nReversed string: "
    result_palindrome: .asciiz "\nPalindrome check: "
    result_p: .asciiz "P\n"
    result_np: .asciiz "NP\n"
    str1: .space 100
    str2: .space 100
    concat_result: .space 200
    reverse_result: .space 100

.text
main:
    # Input first string
    li $v0, 4
    la $a0, prompt_str1
    syscall

    li $v0, 8
    la $a0, str1
    li $a1, 100
    syscall

    # Remove newline character from str1
    jal remove_newline

    # Input second string
    li $v0, 4
    la $a0, prompt_str2
    syscall

    li $v0, 8
    la $a0, str2
    li $a1, 100
    syscall

    # Remove newline character from str2
    jal remove_newline

    # Concatenate the two strings
    la $t0, str1
    la $t1, str2
    la $t2, concat_result
    jal concat

    # Print concatenated string
    li $v0, 4
    la $a0, result_concat
    syscall

    li $v0, 4
    la $a0, concat_result
    syscall

    # Check if str2 is a palindrome
    li $v0, 4
    la $a0, result_palindrome
    syscall

    la $t0, str2
    jal is_palindrome

    beq $v0, $zero, print_np
    j print_p

    # Reverse str2
print_p:
    li $v0, 4
    la $a0, result_p
    syscall
    j reverse_part

print_np:
    li $v0, 4
    la $a0, result_np
    syscall

reverse_part:
    # Reverse the second string
    la $t0, str2
    jal reverse_string

    # Print reversed string
    li $v0, 4
    la $a0, result_rev
    syscall

    li $v0, 4
    la $a0, reverse_result
    syscall

    # Calculate and print size of str1
    la $t0, str1
    jal size_of_string

    li $v0, 4
    la $a0, result_size
    syscall

    move $a0, $v0
    li $v0, 1
    syscall

    # Calculate and print size of str2
    la $t0, str2
    jal size_of_string

    li $v0, 4
    la $a0, result_size
    syscall

    move $a0, $v0
    li $v0, 1
    syscall

    # Exit the program
    li $v0, 10
    syscall

# Concatenation Function
concat:
    lb $t3, 0($t0)
    beq $t3, $zero, concat_str2
    sb $t3, 0($t2)
    addi $t0, $t0, 1
    addi $t2, $t2, 1
    j concat
concat_str2:
    lb $t3, 0($t1)
    beq $t3, $zero, concat_end
    sb $t3, 0($t2)
    addi $t1, $t1, 1
    addi $t2, $t2, 1
    j concat_str2
concat_end:
    sb $zero, 0($t2)
    jr $ra

# Palindrome Function
is_palindrome:
    la $t1, str2
    move $t2, $t1

    # Find end of string
    loop_find_end:
        lb $t3, 0($t2)
        beq $t3, $zero, done_find_end
        addi $t2, $t2, 1
        j loop_find_end
    done_find_end:
        subi $t2, $t2, 1   # Point to last character

    # Check palindrome
    loop_compare:
        lb $t3, 0($t1)
        lb $t4, 0($t2)
        bne $t3, $t4, not_palindrome
        addi $t1, $t1, 1
        subi $t2, $t2, 1
        bge $t1, $t2, is_palindrome_end

        j loop_compare
    not_palindrome:
        li $v0, 0
        jr $ra

    is_palindrome_end:
        li $v0, 1
        jr $ra

# Reverse String Function
reverse_string:
    la $t1, str2
    move $t2, $t1

    # Find end of string
    loop_find_end_rev:
        lb $t3, 0($t2)
        beq $t3, $zero, done_find_end_rev
        addi $t2, $t2, 1
        j loop_find_end_rev
    done_find_end_rev:
        subi $t2, $t2, 1   # Point to last character

    # Reverse the string
    la $t4, reverse_result
    loop_reverse:
        lb $t3, 0($t2)
        sb $t3, 0($t4)
        addi $t4, $t4, 1
        subi $t2, $t2, 1
        bge $t1, $t2, reverse_end
        j loop_reverse

    reverse_end:
        sb $zero, 0($t4)   # Add null terminator
        jr $ra

# String Size Function
size_of_string:
    li $v0, 0
    loop_size:
        lb $t2, 0($t0)
        beq $t2, $zero, done_size
        addi $v0, $v0, 1
        addi $t0, $t0, 1
        j loop_size
    done_size:
    jr $ra

# Remove Newline Function
remove_newline:
    la $t1, str1
    loop_remove:
        lb $t2, 0($t1)
        beq $t2, 10, remove_newline_end  # Check for newline (ASCII 10)
        beq $t2, $zero, remove_newline_end
        addi $t1, $t1, 1
        j loop_remove
    remove_newline_end:
        sb $zero, 0($t1)  # Null terminate the string
        jr $ra
