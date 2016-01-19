	.text
	.globl main

main:
	la $a0, string1		# print first prompt
	jal puts

	la $a0, firstName		# get user's first input
	jal gets

	move $a0, $v0			# print length of first input
	li $v0,1
	syscall

	la $a0, string3 		# print second prompt
	jal puts

	la $a0, lastName		# get user's second input
	jal gets

	move $a0, $v0			# print length of second input
	li $v0,1
	syscall

	la $a0, string3		# print "You entered: "
	jal puts

	la $a0, lastName		# print out user's second input
	jal puts
	
	move $a0, $v0			# print length of second input
	li $v0,1
	syscall

	la $a0, comma			# print a comma
	jal puts

	la $a0, firstName		# print out user's first input
	jal puts

	move $a0, $v0			# print length of first input
	li $v0,1
	syscall

	li $v0,10 				# exit
	syscall

##############FUNCTIONS/SUBROUTINES#################
gets:
	lw $t4, limit 			# t4 load limit
	subi $t4, $t4, 1 		# sub by 1 since \0 takes up a space

	sw $ra, 0($sp)			# need for return
	sub $sp, $sp, 4
	move $t1,$a0			# buffer counter
	li $t3, 0 				# t3 keep track of size


loop1:
	jal GetChar 			# use driver
	sb $v0, 0($t1)			# store array
	add $t3, $t3, 1			# inc size
	add $t1, $t1, 1			# inc array pointer

	beq $t3, $t4, end1		# if limit reached, jump to end
	bne $v0, 10, loop1		# if not end, loop to get next char

end1:		
	sb $zero, -1($t1)		# add a null
	sub $t3, $t3, 1

	move $v0, $t3
	add $sp, $sp, 4		
	lw $ra, 0($sp)
	jr $ra 					# return

puts:
	sw $ra, 0($sp)			# need for return
	sub $sp, $sp, 4	
	move $t1, $a0
	li $s7, 0				# s7 keep track of size
		
loop2:
	lb $t2, 0($t1)
	beq $t2,$zero end2		# if null, jump to end
	move $a0,$t2
	jal PutChar				# use driver
	add $t1,$t1,1
	addi $s7, $s7,1
	jal loop2				# keep looping
	
end2:
	move, $v0, $s7
	add $sp, $sp, 4
	lw $ra, 0($sp)
	jr $ra 					# return

##############DRIVERS#############
GetChar:
	lui $a3, 0xffff			# base address of memory map
CkReady:
	lw $t5, 0($a3)			# read from receiver control register
	andi $t5, $t5, 0x1		# extract ready bit
	beqz $t5, CkReady		# if 1, then load char, else keep looping
	lw $v0, 4($a3)			# load character from keyboard
	jr $ra 					# return to place in program before function call

PutChar:
	lui $a3, 0xffff			# base address of memory map
XReady:
	lw $t5, 8($a3) 			# read from transmitter control register
	andi $t5, $t5, 0x1		# extract ready bit
	beqz $t5, XReady 		# if 1, then store char, else keep looping
	sw $a0, 12($a3) 		# send character to display
	jr $ra 					# return to place in program before
	 						# function call

############DATA#############
	.data
string1: .asciiz "Enter First Name:\n"
string2: .asciiz "Enter Last Name:\n"
string3: .asciiz "You entered: "
comma: .asciiz ", "

firstName: .space 101
lastName: .space 101
limit: .word 100
