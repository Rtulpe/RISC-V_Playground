# RISC-V - RARS
# TASK - Write a program replacing all digits in a string with their complement to 9 (0→9, 1→8, 2→7 etc.)

.data
	buf:	.space 128
	prompt:	.asciz "Enter text: "
	nl:	.asciz "\n"
	
.text
.global main

main:
	# Print the prompt
	la	a0, prompt
	li	a7, 4
	ecall
	
	# Read the string
	la	a0, buf
	li	a1, 127
	li	a7, 8
	ecall
	
	# Buffer processing
	la	t0, buf		# This will read the address, basically a pointer
	
process_loop:
	lb	t1, 0(t0)
	beqz	t1, done	# If reads termination, finished
	
	# Check if char at t1 is between 0 and 9
	li	t2, '0'
	blt	t1, t2, skip_digit
	li	t2, '9'
	bgt	t1, t2, skip_digit
	
	li	t2, 105
	sub	t3, t2, t1
	sb	t3, 0(t0)
	j	next_char
	

skip_digit:
	nop	# Placeholder to do nothing basically
	
next_char:
	addi t0, t0, 1
	j	process_loop
	
	
done:
	la	a0, nl
	li	a7, 4
	ecall
	
	la	a0, buf
	li	a7, 4
	ecall
	
	# Exit
	li	a7, 10
	ecall
	