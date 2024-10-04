.data
    prompt_x: .asciiz "Enter the value of x: "
    prompt_n: .asciiz "Enter the number of terms (n): "
    result:   .asciiz "The approximation of e^x is: "
    newline:  .asciiz "\n"

.text
    .globl main

main:
    # Prompt for x
    li $v0, 4               # print string syscall
    la $a0, prompt_x
    syscall

    li $v0, 6               # read float syscall
    syscall
    mov.s $f12, $f0         # x is now in $f12

    # Prompt for n
    li $v0, 4               # print string syscall
    la $a0, prompt_n
    syscall

    li $v0, 5               # read integer syscall
    syscall
    move $t0, $v0           # n is now in $t0

    # Initialize sum to 1.0 (first term in series)
    li $t1, 1               # Initialize $t1 to 1 (for integer 1)
    mtc1 $t1, $f2           # Move integer 1 to floating point register
    cvt.s.w $f2, $f2        # Convert integer 1 to float in $f2 (sum)

    # Loop to calculate the series
    li $t1, 1               # k = 1
loop:
    beq $t1, $t0, done      # if k == n, exit loop

    # Call subroutine to calculate term x^k / k!
    mov.s $f12, $f12        # pass x
    move $a0, $t1           # pass k
    jal calculate_term      # call the subroutine

    add.s $f2, $f2, $f0     # add the term to sum

    addi $t1, $t1, 1        # increment k
    j loop                  # repeat the loop

done:
    # Print the result
    li $v0, 4               # print string syscall
    la $a0, result
    syscall

    mov.s $f12, $f2         # move the sum to $f12 for printing
    li $v0, 2               # print float syscall
    syscall

    li $v0, 10              # exit syscall
    syscall

# Subroutine to calculate x^k / k!
calculate_term:
    # Input: x in $f12, k in $a0
    # Output: result in $f0

    # Calculate x^k
    li $t2, 1               # initialize result to 1
    mtc1 $t2, $f0           # move integer 1 to floating point register $f0
    cvt.s.w $f0, $f0        # convert integer 1 to float

    move $t2, $a0           # copy k to $t2 (counter)

power_loop:
    beqz $t2, factorial     # if k == 0, go to factorial part
    mul.s $f0, $f0, $f12    # multiply result by x
    subi $t2, $t2, 1        # decrement k
    j power_loop

# Calculate k!
factorial:
    li $t3, 1               # factorial starts at 1
    move $t2, $a0           # copy k to $t2 (counter)

fact_loop:
    beqz $t2, division      # if k == 0, go to division part
    mul $t3, $t3, $t2       # multiply by the next integer
    subi $t2, $t2, 1        # decrement k
    j fact_loop

# Perform division: result = x^k / k!
division:
    mtc1 $t3, $f4           # move factorial to $f4
    cvt.s.w $f4, $f4        # convert factorial to float
    div.s $f0, $f0, $f4     # divide x^k by k!

    jr $ra                  # return from subroutine
