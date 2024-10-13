.data
testcase:  .word 0x1, 0xFFFFFFFF, 0x3FFF
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
    jal ra, clz_optimized
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

clz_optimized:
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    li s0, 32        
    beq a0, x0, ifInputZero  
    li s0, 0         
    
check_high_16:
    srli s1, a0, 16   
    beq s1, x0, check_high_16_0
    srli a0, a0, 16 
    j check_high_24   

check_high_16_0:
    addi s0, s0, 16   

check_high_24:
    srli s1, a0, 8    
    beq s1, x0, check_high_24_0
    srli a0, a0, 8    
    j check_high_28

check_high_24_0:
    addi s0, s0, 8   

check_high_28:
    srli s1, a0, 4    
    beq s1, x0, check_high_28_0
    srli a0, a0, 4
    j check_high_30

check_high_28_0:
    addi s0, s0, 4

check_high_30:
    srli s1, a0, 2    
    beq s1, x0, check_high_30_0
    srli a0, a0, 2
    j check_final

check_high_30_0:
    addi s0, s0, 2   

check_final:
    srli s1, a0, 1    
    beq s1, x0, final_add1
    j ifInputZero

final_add1:
    addi s0, s0, 1

ifInputZero:
    mv a0, s0
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)

    addi sp, sp, 12
    jr ra