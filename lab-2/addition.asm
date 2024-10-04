.data
	number1: .word 5
	number2: .word 12
.text
	lw $t0, number1
	lw $t1, number2
	
	add $t2,$t1,$t0
	li $v0,1
	add $a0,$zero,$t2
	syscall