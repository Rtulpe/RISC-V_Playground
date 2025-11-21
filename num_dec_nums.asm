.data
prompt: .string "Enter text: "
buf:    .space 128
nl:     .string "\n"

.text
.globl main
main:
    # print prompt
    la   a0, prompt
    li   a7, 4
    ecall

    # read string into buf
    la   a0, buf
    li   a1, 127
    li   a7, 8
    ecall

    la   t0, buf     # pointer through string
    li   t1, 0       # count of numbers
    li   t2, 0       # in_num flag (0 = no, 1 = yes)

scan_loop:
    lb   t3, 0(t0)
    beqz t3, end_scan

    # check if digit
    li   t4, '0'
    blt  t3, t4, not_digit
    li   t4, '9'
    bgt  t3, t4, not_digit

    # it's a digit
    beq  t2, x0, start_number
digit_continue:
    addi t0, t0, 1
    li   t2, 1
    j    scan_loop

start_number:
    addi t1, t1, 1   # count++
    li   t2, 1       # now inside number
    addi t0, t0, 1
    j    scan_loop

not_digit:
    li   t2, 0       # leaving a number
    addi t0, t0, 1
    j    scan_loop

end_scan:
    # newline
    la   a0, nl
    li   a7, 4
    ecall

    # print count
    mv   a0, t1
    li   a7, 1       # print_int
    ecall

    # final newline
    la   a0, nl
    li   a7, 4
    ecall

    li   a7, 10
    ecall
