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

    # read input
    la   a0, buf
    li   a1, 127
    li   a7, 8
    ecall

    la   t0, buf      # pointer through string
    li   t1, 0        # current number
    li   t2, 0        # best (maximum) number

scan_loop:
    lb   t3, 0(t0)
    beqz t3, end_scan

    # digit check
    li   t4, '0'
    blt  t3, t4, not_digit
    li   t4, '9'
    bgt  t3, t4, not_digit

    # convert ASCII digit to numerical
    li   t4, '0'
    sub  t3, t3, t4       # t3 = digit (0–9)

    # current = current * 10 + digit
    li   t5, 10
    mul  t1, t1, t5
    add  t1, t1, t3

    # update best if needed
    bge  t2, t1, skip_update
    mv   t2, t1

skip_update:
    addi t0, t0, 1
    j    scan_loop

not_digit:
    li   t1, 0        # reset current
    addi t0, t0, 1
    j    scan_loop

end_scan:
    # print newline
    la   a0, nl
    li   a7, 4
    ecall

    # print best number
    mv   a0, t2
    li   a7, 1        # print_int
    ecall

    # final newline
    la   a0, nl
    li   a7, 4
    ecall

    li   a7, 10
    ecall
