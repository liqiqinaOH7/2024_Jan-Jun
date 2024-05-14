.global _start
.text
_start:
addi s1,x0,4
addi s2,x0,5
addi s4,x0,6
add t0,s1,s2 #t0=9
sub s3,t0,s4 #s3=3
nop
sw t0,0(s1)	#Mem[4]=9
lw t1,0(s1)
or t2,t1,s1	#t2=9|4=0xD

