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

    # read string
    la   a0, buf
    li   a1, 127
    li   a7, 8
    ecall

    # setup pointers
    la   t0, buf      # read pointer
    la   t1, buf      # write pointer

loop:
    lb   t2, 0(t0)
    beqz t2, finish   # end of string

    # check digit
    li   t3, '0'
    blt  t2, t3, copy_char
    li   t3, '9'
    bgt  t2, t3, copy_char

    # it IS a digit → skip it
    addi t0, t0, 1
    j    loop

copy_char:
    # copy non-digit from read → write
    sb   t2, 0(t1)
    addi t1, t1, 1
    addi t0, t0, 1
    j    loop

finish:
    # null-terminate result
    sb x0, 0(t1)

    # newline
    la   a0, nl
    li   a7, 4
    ecall

    # print cleaned string
    la   a0, buf
    li   a7, 4
    ecall

    # final newline
    la   a0, nl
    li   a7, 4
    ecall

    li   a7, 10
    ecall
