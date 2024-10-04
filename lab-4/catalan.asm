.data
    prompt: .asciiz "Enter the value of n: "
    result_msg: .asciiz "The nth Catalan number is: "

.text
.globl main

main:
    # Print the prompt
    li $v0, 4
    la $a0, prompt
    syscall
    
    # Read integer input for n
    li $v0, 5
    syscall
    move $t0, $v0  # store input n in $t0
    
    # Call the recursive function to calculate the nth Catalan number
    move $a0, $t0  # Pass n as argument in $a0
    jal catalan    # Call catalan(n)
    
    # Print the result message
    li $v0, 4
    la $a0, result_msg
    syscall
    
    # Print the result (Catalan number)
    move $a0, $v0  # Move result into $a0
    li $v0, 1      # Print integer syscall
    syscall
    
    # Exit
    li $v0, 10
    syscall

# Recursive function to compute catalan(n)
catalan:
    addi $sp, $sp, -8     # Make space on stack
    sw $ra, 4($sp)        # Store return address
    sw $a0, 0($sp)        # Store n

    # Base case: if n == 0, return 1
    li $t1, 0
    beq $a0, $t1, base_case
    
    # Recursive case: calculate sum(C(i) * C(n-i-1))
    li $t2, 0        # i = 0 (iteration variable)
    sub $t3, $a0, 1  # t3 = n - 1 (limit)
    
    li $t4, 0        # Initialize sum to 0

loop:
    bgt $t2, $t3, end_loop  # Exit loop if i > n-1
    
    move $a0, $t2       # Set a0 to i
    jal catalan         # Call catalan(i)
    move $t5, $v0       # Store C(i) in t5
    
    sub $a0, $t3, $t2   # Set a0 to n-i-1
    jal catalan         # Call catalan(n-i-1)
    mul $t6, $t5, $v0   # Multiply C(i) * C(n-i-1)
    
    add $t4, $t4, $t6   # Add to the sum
    
    addi $t2, $t2, 1    # Increment i
    j loop

end_loop:
    move $v0, $t4       # Set v0 to the sum result
    lw $a0, 0($sp)      # Restore n
    lw $ra, 4($sp)      # Restore return address
    addi $sp, $sp, 8    # Deallocate stack space
    jr $ra              # Return to caller

base_case:
    li $v0, 1           # Return 1 for C(0)
    lw $a0, 0($sp)      # Restore n
    lw $ra, 4($sp)      # Restore return address
    addi $sp, $sp, 8    # Deallocate stack space
    jr $ra              # Return to caller
