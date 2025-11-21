		.data
prompt: .asciz "Enter the String: "
buffer: .space 256

	.text
	.globl main
main:
	li a7, 4	# print the prompt, a7 is syscall?
	la a0, prompt
	ecall
	
	li a7, 8
	la a0, buffer
	li a1, 255
	ecall
	
	la a0, buffer
	
	li a7, 4 	#Print Buffer
	la a0, buffer
	ecall
	

    la t3, buffer        # scan pointer
find_end:
    lbu t0, (t3)        
    beqz t0, end_found  # stop at null
    addi t3, t3, 1
    j find_end
end_found:
    addi t3, t3, -1     # t3 = last before null

    #LR Pointer
    #T1 = Start, T2 = End
    la t1, buffer        
    mv t2, t3            

flip_loop:
    bge t1, t2, done     # stop if pointers cross

#LEFT DIGIT (T5 & T6 is limit)
left_digit:
    lbu t0, (t1)
    li t5, '0'
    li t6, '9'
    blt t0, t5, left_inc
    bgt t0, t6, left_inc
    j left_found
left_inc:
    addi t1, t1, 1
    bge t1, t2, done
    j left_digit
left_found:

#Right DIGIT (T5 & T6 is limit)
right_digit:
    lbu t0, (t2)
    li t5, '0'
    li t6, '9'
    blt t0, t5, right_dec
    bgt t0, t6, right_dec
    j right_found
right_dec:
    addi t2, t2, -1
    blt t1, t2, right_digit
    j done
right_found:

    # SWAP
    lbu t0, (t1)
    lbu t3, (t2)
    sb t3, (t1)
    sb t0, (t2)

    addi t1, t1, 1
    addi t2, t2, -1
    j flip_loop

done:
    # PRINT
    li a7, 4
    la a0, buffer
    ecall

    # exit
    li a7, 10
    ecall