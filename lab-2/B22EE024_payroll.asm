.data
    prompt_hours: .asciiz "Enter regular hours worked: "
    prompt_overtime: .asciiz "Enter overtime hours worked: "
    prompt_wage: .asciiz "Enter hourly wage: "
    prompt_continue: .asciiz "\nDo you want to enter details for another employee? (1 for Yes, 0 for No): "
    
    result_gross: .asciiz "\nGross Salary: "
    result_deductions: .asciiz "\nTotal Deductions: "
    result_net: .asciiz "\nNet Salary: "
    
.text
main:
    li $v0, 4
    la $a0, prompt_hours
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0
    
    li $v0, 4
    la $a0, prompt_overtime
    syscall
    
    li $v0, 5
    syscall
    move $t1, $v0
    
    li $v0, 4
    la $a0, prompt_wage
    syscall
    
    li $v0, 5
    syscall
    move $t2, $v0
    
    mul $t3, $t0, $t2
    mul $t4, $t1, $t2
    mul $t4, $t4, 3
    srl $t4, $t4, 1
    
    add $t5, $t3, $t4
    
    li $t6, 24
    mul $t6, $t6, $t5
    div $t6, $t6, 100
    
    li $t7, 2
    mul $t7, $t7, $t5
    div $t7, $t7, 100
    
    add $t8, $t6, $t7
    
    sub $t9, $t5, $t8
    
    li $v0, 4
    la $a0, result_gross
    syscall
    
    li $v0, 1
    move $a0, $t5
    syscall
    
    li $v0, 4
    la $a0, result_deductions
    syscall
    
    li $v0, 1
    move $a0, $t8
    syscall
    
    li $v0, 4
    la $a0, result_net
    syscall
    
    li $v0, 1
    move $a0, $t9
    syscall
    
    li $v0, 4
    la $a0, prompt_continue
    syscall
    
    li $v0, 5
    syscall
    beq $v0, $zero, exit
    j main
    
exit:
    li $v0, 10
    syscall
