.global _start
.text

_start:
    lui t0, 0x1
    nop
    nop
    nop

    addi s1, t0, 4
    nop
    nop
    nop

    auipc s2, 0x1
    nop
    nop
    nop

    auipc s3, 0x2
    nop
    nop
    nop

    auipc s4, 0x3
    nop
    nop
    nop

    auipc s5, 0x4
    nop
    nop
    nop

    addi t1, x0, 8
    nop
    nop
    nop

    addi t2, x0, 16
    nop
    nop
    nop

    addi t3, x0, 24
    nop
    nop
    nop

    sw t0, 0(t1)
    nop
    nop
    nop

    sw s1, 32(t1)
    nop
    nop
    nop

    sh s2, 0(t2)
    nop
    nop
    nop

    sh s3, 32(t2)
    nop
    nop
    nop

    sb s4, 0(t3)
    nop
    nop
    nop

    sb s5, 32(t3)
    nop
    nop
    nop

    lw s8, 0(t1)
    nop
    nop
    nop

    lh s6, 0(t2)
    nop
    nop
    nop

    lbu s7, 0(t3)
    nop
    nop
    nop

    addi s9, x0, 3
    nop
    nop
    nop

    addi s10, x0, 0
    nop
    nop
    nop

    blt s10, s9, increment
    nop
    nop
    nop

    jal x0, loop		#jal部分不需要执行
    nop
    nop
    nop

increment:
    auipc s11, 0            # 测试blt
    nop
    nop
    nop

loop:
    beq s9, s10, end_loop
    nop
    nop
    nop

    addi s10, s10, 1            # Increase loop index
    nop
    nop
    nop

    addi t0, x0, 1
    nop
    nop
    nop

    beq s10, t0, jump_target   # If loop index equals to 1, branch to jump_target (t0=s10)
    nop
    nop
    nop

    addi t0, x0, 10
    nop
    nop
    nop

    bltu s10, t0, loop          # If loop index not equals to 10, jump back to loop (t0!=s10)
    nop
    nop
    nop

jump_target:
    addi t1, x0, 3
    nop
    nop
    nop

    sub s2, t1, s10
    nop
    nop
    nop

    jal ra, loop_diff         # Jump to loop_diff and save return address
    nop
    nop
    nop

loop_diff:
    bge s10, s2, end_loop
    nop
    nop
    nop

    jalr t3, 4(s11)
    nop
    nop
    nop

end_loop:
    nop
    nop
    nop