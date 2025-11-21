.data
prompt: .string "Enter string: "
buf:    .space 128
nl:     .string "\n"

.text
.globl main
main:
    # Print prompt
    la   a0, prompt
    li   a7, 4
    ecall

    # Read string
    la   a0, buf
    li   a1, 127
    li   a7, 8
    ecall

    # Remove newline
    la   t0, buf
clean_nl:
    lb   t1, 0(t0)
    beqz t1, nl_done
    li   t2, 10
    beq  t1, t2, zap_nl
    addi t0, t0, 1
    j    clean_nl
zap_nl:
    sb   x0, 0(t0)
nl_done:

    # --------------------------------------------------
    # Remove all uppercase letters except the first
    # of each consecutive uppercase sequence
    # --------------------------------------------------

    la   t0, buf    # read pointer
    la   t1, buf    # write pointer
    li   t2, 0      # flag: 0 = not in uppercase sequence, 1 = inside uppercase sequence

process_loop:
    lb   t3, 0(t0)
    beqz t3, finish

    # Test if uppercase: 'A' <= t3 <= 'Z'
    li   t4, 'A'
    blt  t3, t4, not_uppercase
    li   t4, 'Z'
    bgt  t3, t4, not_uppercase

    # -------------------
    # It IS uppercase
    # -------------------
    beqz t2, first_upper   # if flag=0, keep it
    # flag=1 → we are already in uppercase sequence → skip character
    addi t0, t0, 1
    j    process_loop

first_upper:
    # keep the first uppercase letter
    sb   t3, 0(t1)
    addi t1, t1, 1
    addi t0, t0, 1
    li   t2, 1       # mark we are now inside the uppercase run
    j    process_loop

not_uppercase:
    # lowercase or other → always keep
    sb   t3, 0(t1)
    addi t1, t1, 1
    addi t0, t0, 1
    li   t2, 0       # uppercase sequence ended
    j    process_loop

finish:
    # Null-terminate output
    sb   x0, 0(t1)

    # Print newline
    la   a0, nl
    li   a7, 4
    ecall

    # Print resulting string
    la   a0, buf
    li   a7, 4
    ecall

    # Exit
    li   a7, 10
    ecall
