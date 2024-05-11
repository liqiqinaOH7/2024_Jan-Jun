.global _start
.text
_start:
    lui t0, 0x1                # Load upper immediate (t0 = 0x10000)
    addi s1, t0, 4             # s1 = t0 + 4 = 0x10004
    auipc s2, 0x1              # Get the PC and add the upper immediate (s2 = PC + 0x10000). s2 = 4 + 0x10000 = 0x10004
    auipc s3, 0x2              # Get the PC and add the upper immediate (s3 = PC + 0x20000).  s3 = 8 + 0x20000 = 0x20008
    auipc s4, 0x3              # Get the PC and add the upper immediate (s4 = PC + 0x30000).  s4 = 12 + 0x30000 = 0x3000C
    auipc s5, 0x4              # Get the PC and add the upper immediate (s5 = PC + 0x40000).  s5 = 16 + 0x40000 = 0x40010