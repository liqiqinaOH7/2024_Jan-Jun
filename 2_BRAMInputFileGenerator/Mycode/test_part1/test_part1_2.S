.global _start
.text
_start:
    addi t0, zero, 4          # t0 = 4
    addi t1, zero, 2          # t1 = 2
    add s0, t0, t1            # s0 = t0 + t1 = 6
    sub s1, t0, s0            # s1 = t0 - s0 = -2
    xor s2, t0, s0            # s2 = t0 ^ s0 = 2
    or  s3, t0, s0            # s3 = t0 | s0 = 6
    and s4, t0, s0            # s4 = t0 & s0 = 4
    slt t2, t0, s0            # t2 = (t0 < s0) ? 1 : 0 = 1
    sltu s5, t0, s0           # s5 = (t0 < s0) ? 1 : 0 = 1
    slli s6, s5, 1            # s6 = s5 << 1 = 2
    srli t3, s6, 1            # t3 = s6 >> 1 = 1
    srai t4, s5, 1            # t4 = s5 >> 1 = 0
    slti t5, s5, 3            # t5 = (s5 < 3) ? 1 : 0 = 1
    sltiu t6, s5, 5           # t6 = (s5 < 5) ? 1 : 0 = 1
    xori s7, s5, 1            # s7 = s5 ^ 1 = 0
    ori  s8, s5, 1            # s8 = s5 | 1 = 1
    andi s9, s5, 3            # s9 = s5 & 3 = 1
