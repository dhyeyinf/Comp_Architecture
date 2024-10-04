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
    # Input Collection
    li $v0, 4                  # Print string syscall
    la $a0, prompt_hours        # Load address of prompt_hours
    syscall                     # Print the prompt
    
    li $v0, 5                  # Read integer syscall
    syscall                     # Read regular hours
    move $t0, $v0               # Store regular hours in $t0
    
    li $v0, 4                  # Print string syscall
    la $a0, prompt_overtime     # Load address of prompt_overtime
    syscall                     # Print the prompt
    
    li $v0, 5                  # Read integer syscall
    syscall                     # Read overtime hours
    move $t1, $v0               # Store overtime hours in $t1
    
    li $v0, 4                  # Print string syscall
    la $a0, prompt_wage         # Load address of prompt_wage
    syscall                     # Print the prompt
    
    li $v0, 5                  # Read integer syscall
    syscall                     # Read hourly wage
    move $t2, $v0               # Store hourly wage in $t2
    
    # Payroll Calculations
    # Gross Salary Calculation
    mul $t3, $t0, $t2           # Regular salary = regular hours * wage
    
    mul $t4, $t1, $t2           # Overtime pay = overtime hours * wage
    mul $t4, $t4, 3             # Multiply by 1.5 (using 3/2 approach)
    srl $t4, $t4, 1             # Divide by 2 (logical shift right by 1)
    
    add $t5, $t3, $t4           # Gross salary = regular salary + overtime pay
    
    # Deductions Calculation
    # Tax deduction (24% of gross salary)
    li $t6, 24                  # Load 24 (tax rate)
    mul $t6, $t6, $t5           # Calculate 24% of gross salary
    div $t6, $t6, 100           # Divide by 100
    
    # Insurance deduction (2% of gross salary)
    li $t7, 2                   # Load 2 (insurance rate)
    mul $t7, $t7, $t5           # Calculate 2% of gross salary
    div $t7, $t7, 100           # Divide by 100
    
    # Total Deductions
    add $t8, $t6, $t7           # Total deductions = tax + insurance
    
    # Net Salary Calculation
    sub $t9, $t5, $t8           # Net salary = gross salary - total deductions
    
    # Output Results
    # Print Gross Salary
    li $v0, 4                  # Print string syscall
    la $a0, result_gross        # Load address of result_gross
    syscall                     # Print "Gross Salary: "
    
    li $v0, 1                  # Print integer syscall
    move $a0, $t5               # Move gross salary to $a0
    syscall                     # Print the gross salary
    
    # Print Total Deductions
    li $v0, 4                  # Print string syscall
    la $a0, result_deductions   # Load address of result_deductions
    syscall                     # Print "Total Deductions: "
    
    li $v0, 1                  # Print integer syscall
    move $a0, $t8               # Move total deductions to $a0
    syscall                     # Print the total deductions
    
    # Print Net Salary
    li $v0, 4                  # Print string syscall
    la $a0, result_net          # Load address of result_net
    syscall                     # Print "Net Salary: "
    
    li $v0, 1                  # Print integer syscall
    move $a0, $t9               # Move net salary to $a0
    syscall                     # Print the net salary
    
    # Loop for Multiple Employees
    li $v0, 4                  # Print string syscall
    la $a0, prompt_continue     # Load address of prompt_continue
    syscall                     # Print the prompt
    
    li $v0, 5                  # Read integer syscall
    syscall                     # Read user's response
    beq $v0, $zero, exit        # If 0, exit the program
    j main                      # If 1, process another employee
    
exit:
    li $v0, 10                 # Exit syscall
    syscall                     # Exit the program
