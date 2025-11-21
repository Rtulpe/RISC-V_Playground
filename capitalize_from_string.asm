.data
prompt1: .string "Enter the first string: "
prompt2: .string "Enter the second string: "
buf1:    .space 128
buf2:    .space 128
nl:      .string "\n"

.text
.globl main

main:
    # Print prompt for the first string
    la   a0, prompt1
    li   a7, 4
    ecall

    # Read the first string
    la   a0, buf1
    li   a1, 127
    li   a7, 8
    ecall

    # Print prompt for the second string
    la   a0, prompt2
    li   a7, 4
    ecall

    # Read the second string
    la   a0, buf2
    li   a1, 127
    li   a7, 8
    ecall

    # Remove newline from the first string
    la   t0, buf1
    jal  ra, clean_nl

    # Remove newline from the second string
    la   t0, buf2
    jal  ra, clean_nl

    # --------------------------------------------------
    # Main logic to process the strings
    # --------------------------------------------------
    la   t0, buf1      # t0 = pointer to current char in buf1

outer_loop:
    lb   t1, 0(t0)     # t1 = current char from buf1
    beqz t1, finish   # if null terminator, we are done

    # Check if the character is a lowercase letter ('a' <= char <= 'z')
    li   t2, 'a'
    blt  t1, t2, next_char_outer # if char < 'a', skip
    li   t2, 'z'
    bgt  t1, t2, next_char_outer # if char > 'z', skip

    # It is a lowercase letter, now search for it in buf2
    la   t3, buf2      # t3 = pointer to current char in buf2

inner_loop:
    lb   t4, 0(t3)     # t4 = current char from buf2
    beqz t4, next_char_outer # if end of buf2, no match found

    # Compare the character from buf1 (t1) with the one from buf2 (t4)
    beq  t1, t4, capitalize_char

    # No match, move to the next character in buf2
    addi t3, t3, 1
    j    inner_loop

capitalize_char:
    # Match found, capitalize the character in buf1 by subtracting 32
    addi t1, t1, -32
    sb   t1, 0(t0)
    # Once capitalized, no need to check the rest of buf2 for this char
    j    next_char_outer

next_char_outer:
    # Move to the next character in buf1
    addi t0, t0, 1
    j    outer_loop

finish:
    # Print a newline for clean output
    la   a0, nl
    li   a7, 4
    ecall

    # Print the resulting string
    la   a0, buf1
    li   a7, 4
    ecall

    # Print a final newline
    la   a0, nl
    li   a7, 4
    ecall

    # Exit the program
    li   a7, 10
    ecall

# --------------------------------------------------
# Function to remove the trailing newline from a string
# t0 should contain the address of the buffer
# --------------------------------------------------
clean_nl:
    lb   t1, 0(t0)
    beqz t1, nl_done     # if null, done
    li   t2, 10          # ASCII for newline
    beq  t1, t2, zap_nl  # if newline, zap it
    addi t0, t0, 1
    j    clean_nl
zap_nl:
    sb   x0, 0(t0)       # replace newline with null
nl_done:
    jr   ra              # return
