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

    # ------------------------------
    # Convert every 3rd lowercase letter
    # ------------------------------

    la   t0, buf      # pointer to chars
    li   t1, 0        # lowercase counter

process_loop:
    lb   t2, 0(t0)
    beqz t2, finish   # end of string

    # Check lowercase: 'a' <= t2 <= 'z'
    li   t3, 'a'
    blt  t2, t3, next_char
    li   t3, 'z'
    bgt  t2, t3, next_char

    # It IS lowercase -> count it
    addi t1, t1, 1

    # If counter == 3 → uppercase it
    li   t3, 3
    bne  t1, t3, next_char

    # Convert lowercase → uppercase (ASCII - 32)
    addi t2, t2, -32
    sb   t2, 0(t0)

    # Reset counter
    li   t1, 0

next_char:
    addi t0, t0, 1
    j    process_loop

finish:
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
