.global _start
.text
_start:
    lui   a0, 0x00000   # 设置DataRam的起始地址为0x00000000，也用作被排序数组的起始地址是，即DataRam的起始地址
    addi t0, zero, 4           # t0 = 4
    addi t1, zero, 2           # t1 = 2
    add t2, t0, t1             # t2 = t0 + t1 = 6
    sub t3, t0, t1             # t3 = t0 - t1 = 2
    xor t4, t0, t1             # t4 = t0 ^ t1 = 6
    or  t5, t0, t1             # t5 = t0 | t1 = 6
    and t6, t0, t1             # t6 = t0 & t1 = 0
    slt t7, t0, t1             # t7 = (t0 < t1) ? 1 : 0 = 0
    sltu t8, t0, t1            # t8 = (t0 < t1) ? 1 : 0 = 0
    slli t9, t0, 1             # t9 = t0 << 1 = 8
    srli t10, t1, 1            # t10 = t1 >> 1 = 1
    srai t11, t0, 1            # t11 = t0 >> 1 = 2
    slti t12, t0, 3            # t12 = (t0 < 3) ? 1 : 0 = 0
    sltiu t13, t0, 5           # t13 = (t0 < 5) ? 1 : 0 = 1
    xori t14, t0, 1            # t14 = t0 ^ 1 = 5
    ori  t15, t0, 1            # t15 = t0 | 1 = 5
    andi t16, t0, 3            # t16 = t0 & 3 = 0