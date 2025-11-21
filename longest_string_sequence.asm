.data
prompt: .string "Enter text: "
nl:     .string "\n"
buf:    .space 128
best:   .space 32

.text
.globl main
main:
    # print prompt
    la   a0, prompt
    li   a7, 4
    ecall

    # read input into buf
    la   a0, buf
    li   a1, 127
    li   a7, 8
    ecall

    # setup registers
    la   t0, buf     # current char pointer
    li   t1, 0       # current run length
    li   t2, 0       # best run length
    la   s0, best    # best buffer start
    la   s1, buf     # start of current run
    la   s2, best    # temp write pointer

scan_loop:
    lb   t3, 0(t0)
    beqz t3, end_scan

    # check digit
    li   t4, '0'
    blt  t3, t4, not_digit
    li   t4, '9'
    bgt  t3, t4, not_digit

    # digit case
    beq  t1, x0, first_digit
continue_digit:
    addi t1, t1, 1
    addi t0, t0, 1
    j    scan_loop

first_digit:
    mv   s1, t0
    addi t1, t1, 1
    addi t0, t0, 1
    j    scan_loop

not_digit:
    bge  t2, t1, reset_run

    # new best run
    mv   t2, t1      # save new best length
    la   s2, best    # where to copy
    mv   t5, s1      # read pointer

copy_best:
    beq  t1, x0, reset_run
    lb   t6, 0(t5)
    sb   t6, 0(s2)
    addi t5, t5, 1
    addi s2, s2, 1
    addi t1, t1, -1
    j    copy_best

reset_run:
    li   t1, 0
    addi t0, t0, 1
    j    scan_loop

end_scan:
    # check final run
    bge  t2, t1, finish

    mv   t2, t1
    la   s2, best
    mv   t5, s1

copy_last:
    beq  t1, x0, finish
    lb   t6, 0(t5)
    sb   t6, 0(s2)
    addi t5, t5, 1
    addi s2, s2, 1
    addi t1, t1, -1
    j    copy_last

finish:
    # null-terminate best
    la   t4, best
    add  t4, t4, t2
    sb   x0, 0(t4)

    # newline
    la   a0, nl
    li   a7, 4
    ecall

    # print best
    la   a0, best
    li   a7, 4
    ecall

    # final newline
    la   a0, nl
    li   a7, 4
    ecall

    # exit
    li   a7, 10
    ecall
