.data
	number1: .word 20
	number2: .word 4
.text
	lw $t0, number1
	lw $t1, number2
	
	sub $t2,$t0,$t1
	li $v0,1 	
	sub $a0,$t2,$zero
	syscall
