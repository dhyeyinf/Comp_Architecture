.data
	prompt1: .asciiz "Enter the first Integer: "
	prompt2: .asciiz "Enter the second Integer: "
	result_add: .asciiz "\nAddition Result is: "
	result_sub: .asciiz "\nSubtraction Result is: "
	result_mul: .asciiz "\nMultiplication Result is: "
	
.text
    #taking input as number 1	
    li $v0, 4              
    la $a0, prompt1        
    syscall                
    
    li $v0, 5              
    syscall               
    move $t0, $v0          
    #taking input as number 2
    li $v0, 4              
    la $a0, prompt2        
    syscall                
    
    li $v0, 5              
    syscall                
    move $t1, $v0           
    # Perform Addition
    add $t2, $t0, $t1      
    
    li $v0, 4              
    la $a0, result_add     
    syscall                
    
    li $v0, 1              
    move $a0, $t2          
    syscall                   
    # Perform Subtraction
    sub $t2, $t0, $t1      
    
    li $v0, 4              
    la $a0, result_sub     
    syscall                
    
    li $v0, 1              
    move $a0, $t2          
    syscall                  
    # Perform Multiplication
    mul $t2, $t0, $t1      
    
    li $v0, 4              
    la $a0, result_mul     
    syscall                
 
    li $v0, 1              
    move $a0, $t2         
    syscall                    
    # Exit the program
    li $v0, 10             
    syscall
		