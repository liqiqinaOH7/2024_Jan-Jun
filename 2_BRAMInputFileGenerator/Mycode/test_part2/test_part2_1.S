.global _start
.text
_start:
    lui t0, 0x1                # Load upper immediate (t0 = 0x1000)
    addi s1, t0, 4             # s1 = t0 + 4 = 0x1004
    auipc s2, 0x1              # Get the PC and add the upper immediate (s2 = PC + 0x1000). s2 = 8 + 0x1000 = 0x1008
    auipc s3, 0x2              # Get the PC and add the upper immediate (s3 = PC + 0x2000).  s3 = 12 + 0x2000 = 0x200C
    auipc s4, 0x3              # Get the PC and add the upper immediate (s4 = PC + 0x30000).  s4 = 16 + 0x3000 = 0x3010
    auipc s5, 0x4              # Get the PC and add the upper immediate (s5 = PC + 0x40000).  s5 = 20 + 0x4000 = 0x4014
    addi t1, x0, 8
    addi t2, x0, 16
    addi t3, x0, 24

# Now we save some registers to memory (sw, sh, sb) at the addresses in our registers
    sw t0, 0(t1)               # Save word from t0 to [t1]
    sw s1, 32(t1)               # Save word from s1 to [t1]+32
    sh s2, 0(t2)               # Save halfword from s2 to [t2]
    sh s3, 32(t2)               # Save halfword from s3 to [t2]+32
    sb s4, 0(t3)               # Save byte from s4 to [t3]
    sb s5, 32(t3)               # Save byte from s5 to [t3]+32

# We can load them back into other registers (keeping same addresses in base register, but offsets are added)
    lw s8, 0(t1)               # Load word into t8 from [t1]
    lh s6, 0(t2)               # Load halfword into s6 from [t2]
    lbu s7, 0(t3)              # Load byte (unsigned) into s7 from [t3]

    addi s9, x0, 3           # Set loop count to 3 in s9
    addi s10, x0, 0            # Initialize loop index in s10
    blt s10, s9, increment
    jal x0, loop		#jal部分不需要执行
    increment:
    auipc s11, 0            # 测试blt
loop:  
    beq s9, s10, end_loop      # If loop count equals to loop index, branch to end_loop

    addi s10, s10, 1            # Increase loop index

    addi t0, x0, 1            # Set a temporary variable to 1
    beq s10, t0, jump_target   # If loop index equals to 1, branch to jump_target (t0=s10)

    addi t0, x0, 10            # Set a temporary variable to 10
    bltu s10, t0, loop          # If loop index not equals to 10, jump back to loop (t0!=s10)

jump_target:
    addi t1, x0, 3           # Set another temporary variable to 10
    sub s2, t1, s10            # Calculate difference and store in s2

    jal ra, loop_diff         # Jump to loop_diff and save return address

loop_diff:
    bge s10, s2, end_loop      # If loop count greater or equals to calculated diff, branch to end_loop

    jalr t3, 4(s11)        

end_loop:
    # Loop ends here

