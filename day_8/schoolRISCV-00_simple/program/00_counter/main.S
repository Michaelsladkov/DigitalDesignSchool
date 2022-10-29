# RISC-V simple counter program
#
# Stanislav Zhelnio, 2020
#

            .text

start:      addi a0, zero, 3
            addi a1, zero, 1
counter:    sll a0, a0, a1           # t0 = t0 + 1
            andi a0, a0, 0x00FF
            beq zero, zero, counter  # if t0 == t1 then counter
