.data
    prompt_n: .asciiz "Enter the value of n: "
    result:   .asciiz "The nth Catalan number is: "
    newline:  .asciiz "\n"
    .align 2
    catalan:  .space 4000

.text
    .globl main

main:
    # Prompt for n
    li $v0, 4
    la $a0, prompt_n
    syscall
    li $v0, 5
    syscall
    move $s0, $v0            # store n in $s0

    # Check if n is valid (n >= 0)
    bltz $s0, invalid_input

    # Initialize memory for Catalan numbers with -1 (uncomputed state)
    li $t0, 0
    li $t1, 1000
    li $t2, -1
init_loop:
    beq $t0, $t1, calc
    sll $t3, $t0, 2
    la $t4, catalan
    add $t4, $t4, $t3
    sw $t2, 0($t4)
    addi $t0, $t0, 1
    j init_loop

calc:
    # Call recursive subroutine to calculate C(n)
    move $a0, $s0
    jal catalan_recursive
    move $s1, $v0            # store result in $s1

    # Print the result
    li $v0, 4
    la $a0, result
    syscall
    move $a0, $s1
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newline
    syscall

    # Exit program
    li $v0, 10
    syscall

invalid_input:
    li $v0, 4
    la $a0, newline
    syscall
    li $v0, 10
    syscall

catalan_recursive:
    # Base case: if n == 0 or n == 1, return 1
    li $t0, 1
    ble $a0, $t0, base_case

    # Check if C(n) is already computed (memoization)
    sll $t1, $a0, 2
    la $t2, catalan
    add $t2, $t2, $t1
    lw $t3, 0($t2)
    li $t4, -1
    bne $t3, $t4, memo_return

    # Recursive case: compute C(n)
    li $v0, 0                # initialize result to 0
    move $t5, $a0            # preserve n
    li $t0, 0                # i = 0

loop_recursive:
    beq $t0, $t5, store_result
    # Calculate C(i) * C(n-i-1)
    move $a0, $t0
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $t0, 4($sp)
    sw $t5, 8($sp)
    sw $v0, 12($sp)          # Save current sum
    jal catalan_recursive
    lw $ra, 0($sp)
    lw $t0, 4($sp)
    lw $t5, 8($sp)
    lw $t6, 12($sp)          # Load current sum to $t6
    addi $sp, $sp, 16
    move $t1, $v0            # store C(i) in $t1
    
    sub $a0, $t5, $t0
    subi $a0, $a0, 1
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $t0, 4($sp)
    sw $t1, 8($sp)
    sw $t5, 12($sp)
    sw $t6, 16($sp)          
    jal catalan_recursive
    lw $ra, 0($sp)
    lw $t0, 4($sp)
    lw $t1, 8($sp)
    lw $t5, 12($sp)
    lw $t6, 16($sp)          
    addi $sp, $sp, 20
    
    mul $t3, $t1, $v0
    add $t6, $t6, $t3        
    move $v0, $t6            
    addi $t0, $t0, 1
    j loop_recursive

store_result:
    sll $t1, $t5, 2
    la $t2, catalan
    add $t2, $t2, $t1
    sw $v0, 0($t2)
    jr $ra

base_case:
    li $v0, 1
    jr $ra

memo_return:
    move $v0, $t3
    jr $ra
