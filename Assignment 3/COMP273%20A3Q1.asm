	.text
	.globl main

main:
	la $s0, array
	#li $s1, 0
	
loop1:	li $v0, 5		#load read int instruction
	syscall			#execute read int instruction
	move $v1, $v0		#v1 = v0, low index
	li $v0, 5		#reload read int instruction
	syscall			#execute read int instruction
	move $t2, $v0		#t2 = v0, high index
	move $t1, $v1		#t1 = low index, t1 is pointer
	move $s1, $t1		#set program counter to low index, s1 is program counter
	li $s5, 4		#load 4 so i can multiply pc by 4
	mult $s1, $s5		#increment program counter by 4
	mflo $s1		#move the multiplied result to program counter
	addi $t2, $t2, 1
	j inc		#proceed to loop2


inc:	beq $t1,$t2, dec	#if t1=t2, go to loop 3, (if pointer = high index)
	li $v0, 1		#load print string instruction
	add $s2, $s0, $s1	
	lw $a0, 0($s2)		#load the number into a0
	syscall			#perform syscall, prints a0
	add $t1,$t1,1		#increase pointer by 1
	addi $s1, $s1, 4	#increase memory pointer by 4
	j loop4			#print a space, for ascending

dec: 	beq $t1,$v1, exit
	subi $s1,$s1,4
	li $v0, 1
	add $s2, $s0, $s1
	lw $a0, 0($s2)
	syscall
	subi $t1,$t1,1
	j loop5			#print a space, for descending

loop4: 	la $a0, space		#print a space function for ascending
	li $v0, 4
	syscall
	j inc
	
loop5: 	la $a0, space		#print a space function for descending
	li $v0, 4
	syscall
	j dec

exit:

	.data
array: .word 10, 5, 2, 20, 20, -5, 3, 19, 9, 1
space: .asciiz " "
