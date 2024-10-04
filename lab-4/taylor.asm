.data
    prompt_x: .asciiz "Enter the value of x: "
    prompt_n: .asciiz "Enter the number of terms n: "
    result_msg: .asciiz "e^x approximation: "
    newline: .asciiz "\n"
    float_one: .float 1.0

.text
.globl main

main:
    # Prompt for x
    li $v0, 4
    la $a0, prompt_x
    syscall

    # Read x as float
    li $v0, 6
    syscall
    mov.s $f12, $f0  # Store x in $f12

    # Prompt for n
    li $v0, 4
    la $a0, prompt_n
    syscall

    # Read n as integer
    li $v0, 5
    syscall
    move $s0, $v0  # Store n in $s0

    # Initialize sum to 1.0 (first term of series)
    l.s $f2, float_one
    
    # Initialize k to 1 (start from second term)
    li $t0, 1

loop:
    beq $t0, $s0, end_loop  # If k == n, end loop

    # Call subroutine to calculate kth term
    move $a0, $t0  # k
    jal calculate_term

    # Add term to sum
    add.s $f2, $f2, $f0

    # Increment k
    addi $t0, $t0, 1
    j loop

end_loop:
    # Print result message
    li $v0, 4
    la $a0, result_msg
    syscall

    # Print approximation of e^x
    mov.s $f12, $f2
    li $v0, 2
    syscall

    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    # Exit program
    li $v0, 10
    syscall

# Subroutine to calculate kth term of Taylor series
calculate_term:
    # $a0 contains k, $f12 contains x
    mtc1 $a0, $f4
    cvt.s.w $f4, $f4  # Convert k to float

    # Calculate x^k
    mov.s $f6, $f12  # Copy x to $f6
    l.s $f8, float_one  # Initialize result to 1.0
power_loop:
    c.le.s $f4, $f8
    bc1t end_power
    mul.s $f8, $f8, $f6
    sub.s $f4, $f4, $f8  # Decrement k
    j power_loop
end_power:
    
    # Calculate k!
    l.s $f10, float_one  # Initialize factorial to 1.0
    mtc1 $a0, $f4
    cvt.s.w $f4, $f4  # Convert k back to float
factorial_loop:
    c.le.s $f4, $f8  # $f8 is still 1.0 from power calculation
    bc1t end_factorial
    mul.s $f10, $f10, $f4
    sub.s $f4, $f4, $f8  # Decrement k
    j factorial_loop
end_factorial:

    # Calculate x^k / k!
    div.s $f0, $f8, $f10  # Result in $f0

    jr $ra  # Return from subroutine