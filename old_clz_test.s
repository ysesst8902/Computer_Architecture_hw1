.data
testcase:    .word 0x1, 0xFFFFFFFF, 0x3FFF
answer:    .word 31, 0, 18
true:    .string "true"
false:    .string "false"
newline: .string "\n"
.text
main:
    li t2, 3
    la t0, testcase
    la t1, answer
testLoop:
    lw a0, 0(t0)
    jal ra, my_clz
    lw t3, 0(t1)
    beq a0, t3, setTrue
    la a0, false
    j print_result
setTrue:
    la a0, true
print_result:
    jal ra printTrueFalse
    addi t0, t0, 4
    addi t1, t1, 4
    addi t2, t2, -1
    bnez t2, testLoop
    li a7, 10
    ecall
printTrueFalse:
    li a7, 4
    ecall
    la a0, newline
    ecall
    jr ra

my_clz:
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    beq a0, x0, ifInputZero
    addi s0, x0, 0
    li s1, 31
clzFor:
    li s2, 1
    sll s2, s2, s1
    and s3, a0, s2
    bne s3, x0, funciontEnd
    addi s0, s0, 1
    addi s1, s1, -1
    bne s1, x0, clzFor
funciontEnd:
    mv a0, s0
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20
    jr ra
ifInputZero:
    li s0, 32
    j funciontEnd