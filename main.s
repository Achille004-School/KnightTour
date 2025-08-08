# NOTES: The mathematical minimum size is 5.
#        If you use an odd size, you must start with an even number.
.equ SZ, 5
.equ STARTING_MOVE, 0 # a1


.equ CHAR_LF, 0x0A
.equ CHAR_SP, 0x20
.equ CHAR_1, 0x31
.equ CHAR_a, 0x61

.equ MOVES_SIZE, SZ*SZ
.equ CHAR_SZ, (0x30 + SZ)

    .section .rodata

__stack_size: .double 0x800

# representation of knight moves in the form of (row_offset, col_offset) byte pairs
knight_move_size: .byte 16 # 8 pairs of (row_offset, col_offset)
knight_move_pairs: .byte 2, 1
                   .byte 1, 2
                   .byte -1, 2
                   .byte -2, 1
                   .byte -2, -1
                   .byte 1, -2
                   .byte 2, -1

starting_msg: .ascii "Starting knight's tour with size "
              .byte CHAR_SZ, CHAR_LF, 0
stack_overflow_msg: .asciz "Stack overflow!\n"

    .section .data

.globl __sp
__sp: .double 0

    .section .bss

space_4_byte: .zero 4

board: .zero MOVES_SIZE
moves: .zero MOVES_SIZE

    .section .text

.globl main
main:
    la t0, __sp  # Load address of initial stack pointer holder
    sd sp, 0(t0)  # Store the initial stack pointer (64-bit)

    la a0, 1  # File descriptor for stdout
    la a1, starting_msg
    li a2, 36  # Length
    li a7, 64
    ecall

    la a0, board  # Address of board
    la a1, moves  # Address of moves
    mv a4, zero  # Current depth

    li t0, STARTING_MOVE # Copy starting move
    sb t0, 0(a1)  # Store starting move in moves

    add t1, a0, t0  # Calculate address of the first move in the board
    li t2, 1 # Set the board cell as used
    sb t2, 0(t1)

    li a2, SZ # Size of the board
    la a3, knight_move_pairs # Address of knight move pairs
    addi a4, a4, 1  # Increment current depth
    div a5, t0, a2  # Row of last move
    rem a6, t0, a2  # Col of last move
    call recurse

    j end

# a0 address of board
# a1 address of moves
# a2 size
# a3 address of knight move pairs
# a4 current depth
# a5 row of last move
# a6 col of last move
recurse:
    # Allocate stack space for the return address
    addi sp, sp, -4

    ld t0, __stack_size
    add t0, sp, t0
    ld t1, __sp
    bltu t0, t1, stack_overflow

    sw ra, 0(sp)  # Save board address

    # Check if we have filled the board
    mul t0, a2, a2  # size * size
    bgeu a4, t0, recurse_print_moves

    addi sp, sp, -40 # Allocate stack space

    ld t0, __stack_size
    add t0, sp, t0
    ld t1, __sp
    bltu t0, t1, stack_overflow

    # If the board is not filled, save the S registers for the recursion
    sw s0, 0(sp)  # Save board address
    sw s1, 4(sp)  # Save moves address
    sw s2, 8(sp)  # Save size
    sw s3, 12(sp) # Save knight move pairs address
    sw s4, 16(sp) # Save current depth
    sw s5, 20(sp) # Save row of last move
    sw s6, 24(sp) # Save column of last move
    sw s7, 28(sp) # Save current knight move
    sw s8, 32(sp) # Save new row for loop
    sw s9, 36(sp) # Save new col for loop

    mv s0, a0  # board
    mv s1, a1  # moves
    mv s2, a2  # size
    mv s3, a3  # knight move pairs address
    mv s4, a4  # current depth
    mv s5, a5  # row of last move
    mv s6, a6  # col of last move

    mv s7, zero # current knight_moves index
    recurse_for_loop:
        lbu t0, knight_move_size  # Load the size of knight moves
        sltu t0, s7, t0  # Check if we have exhausted all knight moves
        beqz t0, recurse_end

        # Calculate next move
        add t0, s3, s7  # address of the current knight move
        addi s7, s7, 2  # Increment knight moves index

        lb t1, 1(t0) # col offset
        lb t0, 0(t0) # row offset

        add s8, s5, t0  # new row
        add s9, s6, t1  # new col

        # Check if the new position is valid
        mv a0, s0  # board
        mv a1, s2  # size
        mv a2, s8  # row
        mv a3, s9  # col
        call get_value  # Get value at (row, col)
        bnez a0, recurse_for_loop  # If value is not zero, skip this move

        # Calculate the index of the new move
        mul t0, s2, s8 # row * size
        add t0, t0, s9  # t0 = row * size + col

        # Update board
        add t1, s0, t0  # address of the new move
        li t2, 1
        sb t2, 0(t1)  # Set the board cell as used

        # Update moves
        add t1, s1, s4  # address of the current move in moves
        sb t0, 0(t1)  # Store the index of the new move

        # Recurse with the new move
        mv a0, s0
        mv a1, s1
        mv a2, s2
        mv a3, s3
        addi a4, s4, 1  # Increment current depth
        mv a5, s8
        mv a6, s9
        call recurse

        # Reset board
        mul t0, s2, s8  # row * size
        add t0, t0, s9  # t0 = row * size + col
        add t1, s0, t0  # address of the new move
        sb zero, 0(t1)  # Set the board cell as not used

        # Moves does not need to be reset, as we are only storing the index of the move

        j recurse_for_loop

    recurse_print_moves:
        # Print the moves
        mv a0, a1  # moves
        mv a1, a2  # size
        call print_moves

        lw ra, 0(sp)  # Restore board address
        addi sp, sp, 4  # Deallocate stack space
        ret

    recurse_end:
        lw s0, 0(sp)  # Restore board address
        lw s1, 4(sp)  # Restore moves address
        lw s2, 8(sp)  # Restore size
        lw s3, 12(sp) # Restore knight move pairs address
        lw s4, 16(sp) # Restore current depth
        lw s5, 20(sp) # Restore row of last move
        lw s6, 24(sp) # Restore column of last move
        lw s7, 28(sp) # Restore current knight move
        lw s8, 32(sp) # Restore new row for loop
        lw s9, 36(sp) # Restore new col for loop
        lw ra, 40(sp) # Restore return address
        addi sp, sp, 44 # Deallocate stack space
        ret

# a0 board
# a1 size
# a2 row
# a3 col
get_value:
    mv t0, a0

    li a0, 1 # Default value (used cell)
    bgeu a2, a1, get_value_ret
    bgeu a3, a1, get_value_ret

    mul t1, a1, a2
    add t1, t1, a3
    add t0, t0, t1
    lbu a0, 0(t0)

    get_value_ret:
        ret

# a0 moves
# a1 size
print_moves:
    addi sp, sp, -8 # Allocate stack space

    ld t0, __stack_size
    add t0, sp, t0
    ld t1, __sp
    bltu t0, t1, stack_overflow

    sw s0, 0(sp)  # Save s0
    sw s1, 4(sp)  # Save s1

    mv s0, a0  # moves
    mv s1, a1  # size

    mv t0, zero  # Index for moves
    mul t1, a1, a1  # Size of the moves array
    la t2, space_4_byte

    li t4, CHAR_SP  # Space character
    sb t4, 2(t2)  # Store space character in 4_byte

    print_moves_loop:
        bgeu t0, t1, print_moves_end  # If index >= size^2, end loop

        add t3, s0, t0  # Get address of the current move
        lb t3, 0(t3)  # Load the move index

        div t4, t3, s1  # Get row (index / size)
        addi t4, t4, CHAR_a  # Convert to ASCII character
        sb t4, 0(t2)  # Store row character in space_4_byte

        rem t4, t3, s1  # Get column (index % size)
        addi t4, t4, CHAR_1  # Convert to ASCII character
        sb t4, 1(t2)  # Store column character in space_4_byte

        li a0, 1  # File descriptor for stdout
        mv a1, t2  # Address of the space_4_byte
        li a2, 3  # Length of the string (2 characters + space)
        li a7, 64  # syscall for write
        ecall

        addi t0, t0, 1  # Increment index
        j print_moves_loop

    print_moves_end:
        li t4, CHAR_LF  # Line feed character
        sb t4, 2(t2)  # Store space character in 4_byte

        li a0, 1  # File descriptor for stdout
        addi a1, t2, 2  # Address of the space char in space_4_byte
        li a2, 1  # Length of the character (space)
        li a7, 64  # syscall for write
        ecall

        lw s0, 0(sp)  # Restore s0
        lw s1, 4(sp)  # Restore s1
        addi sp, sp, 8  # Deallocate stack space

        ret

.globl end
end:
    li a0, 0
    li a7, 93
    ecall

.globl stack_overflow
stack_overflow:
    la a0, 1  # File descriptor for stdout
    la a1, stack_overflow_msg
    li a2, 16  # Length
    li a7, 64
    ecall
    j error

.globl error
error:
    li a0, 1
    li a7, 93
    ecall