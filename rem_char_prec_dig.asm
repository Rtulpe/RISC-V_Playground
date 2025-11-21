.data
prompt: .string "Enter string: "
buf:    .space 128
nl:     .string "\n"

.text
.globl main
main:
    # Prompt for string
    la   a0, prompt
    li   a7, 4
    ecall

    # Read string into buf
    la   a0, buf
    li   a1, 127
    li   a7, 8        # read_string
    ecall

    # Remove trailing newline from input
    la   t0, buf
clean_nl:
    lb   t1, 0(t0)
    beqz t1, nl_done
    li   t2, 10       # '\n'
    beq  t1, t2, zap_nl
    addi t0, t0, 1
    j    clean_nl
zap_nl:
    sb   x0, 0(t0)
nl_done:

    # ------------------------------
    # Remove chars preceded by digits
    # ------------------------------

    la   t0, buf      # read pointer
    la   t1, buf      # write pointer
    li   t2, 0        # previous char (not a digit)

process_loop:
    lb   t3, 0(t0)    # current char
    beqz t3, finish   # end of string?

    # Check if previous char was digit: '0' <= t2 <= '9'
    li   t4, '0'
    li   t5, '9'
    blt  t2, t4, keep_char   # previous < '0' → not digit
    bgt  t2, t5, keep_char   # previous > '9' → not digit

    # If we reach here: previous IS digit → skip current char
    mv   t2, t3
    addi t0, t0, 1
    j    process_loop

keep_char:
    # Keep the character
    sb   t3, 0(t1)
    addi t1, t1, 1

    # Update previous
    mv   t2, t3
    addi t0, t0, 1
    j    process_loop

finish:
    sb   x0, 0(t1)    # null-terminate output

    # Print a newline
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
