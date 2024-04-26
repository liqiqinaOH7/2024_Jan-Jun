.global _start
.text
_start:
	addi t0, zero, 4           # t0 = 4
	addi t1, zero, 2           # t1 = 2
	add t1, t0, t1             # t1 = t0 + t1 = 6
	sub t2, t0, t1             # t2 = t0 - t1 = -2
	xor t3, t0, t1             # t3 = t0 ^ t1 = 2
	or  t4, t0, t1             # t4 = t0 | t1 = 6
	and t5, t0, t1             # t5 = t0 & t1 = 4
	slt t6, t0, t1             # t6 = (t0 < t1) ? 1 : 0 = 1
	sltu t0, t0, t1            # t0 = (t0 < t1) ? 1 : 0 = 1
	slli t1, t0, 1             # t1 = t0 << 1 = 2
	srli t2, t1, 1             # t2 = t1 >> 1 = 1
	srai t3, t0, 1             # t3 = t0 >> 1 = 0
	slti t4, t0, 3             # t4 = (t0 < 3) ? 1 : 0 = 1
	sltiu t5, t0, 5            # t5 = (t0 < 5) ? 1 : 0 = 1
	xori t6, t0, 1             # t6 = t0 ^ 1 = 0
	ori  t1, t0, 1             # t1 = t0 | 1 = 1
	andi t2, t0, 3             # t2 = t0 & 3 = 1
