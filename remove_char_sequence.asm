.data
prompt:    .string "Enter string: "
prompt_a:  .string "Enter first index (0-based): "
prompt_b:  .string "Enter second index (0-based): "
buf:       .space 128
nl:        .string "\n"

.text
.globl main
main:
    # print prompt and read string
    la   a0, prompt
    li   a7, 4
    ecall

    la   a0, buf
    li   a1, 127
    li   a7, 8        # read_string
    ecall

    # remove trailing newline (if any)
    la   t0, buf
strip_nl:
    lb   t1, 0(t0)
    beqz t1, nl_done
    li   t2, 10       # '\n' ascii
    beq  t1, t2, zap_nl
    addi t0, t0, 1
    j    strip_nl
zap_nl:
    sb   x0, 0(t0)
nl_done:

    # prompt and read first index (zero-based)
    la   a0, prompt_a
    li   a7, 4
    ecall
    li   a7, 5        # read_int
    ecall
    mv   t3, a0       # t3 = idxA

    # prompt and read second index (zero-based)
    la   a0, prompt_b
    li   a7, 4
    ecall
    li   a7, 5
    ecall
    mv   t4, a0       # t4 = idxB

    # normalize so t3 <= t4
    ble  t3, t4, indexed_ok
    mv   t5, t3
    mv   t3, t4
    mv   t4, t5
indexed_ok:

    # Now remove characters with original indices in [t3 .. t4]
    la   t0, buf      # read pointer (reads original buffer)
    la   t1, buf      # write pointer (writes kept chars)
    li   t2, 0        # position counter (ZERO-BASED now!)

remove_loop:
    lb   t6, 0(t0)
    beqz t6, remove_done

    # if position < start => copy
    blt  t2, t3, write_char
    # if position > end => copy
    bgt  t2, t4, write_char

    # otherwise (t3 <= t2 <= t4) => skip this char
    addi t0, t0, 1
    addi t2, t2, 1
    j    remove_loop

write_char:
    sb   t6, 0(t1)
    addi t1, t1, 1
    addi t0, t0, 1
    addi t2, t2, 1
    j    remove_loop

remove_done:
    sb   x0, 0(t1)    # null-terminate result

    # print newline then result
    la   a0, nl
    li   a7, 4
    ecall

    la   a0, buf
    li   a7, 4
    ecall

    # final newline and exit
    la   a0, nl
    li   a7, 4
    ecall

    li   a7, 10
    ecall
