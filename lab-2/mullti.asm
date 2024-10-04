.data
	number1: .word 3
	number2: .word 9
.text
	lw $t0,number1
	lw $t1,number2
	mul $t2,$t1,$t0
	
	li $v0,1
	add $a0,$t2,$zero
	syscall

