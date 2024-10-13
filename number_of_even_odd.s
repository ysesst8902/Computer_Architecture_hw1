main:
    li a0, 0x2
    jal ra, EvenOddbit
    li a7, 10
    ecall 
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
    
EvenOddbit:
    addi sp, sp, -20   
    sw ra, 0(sp)      
    sw s0, 4(sp)          
    sw s1, 8(sp)   
    sw s2, 12(sp)     
    sw s3, 16(sp)
    mv s3, a0
    
    # calculate start idx
    jal ra, clz_optimized    # use clz_optimized 
    li s0, 31             # t0 = 31
    sub s0, s0, a0        # s0 = 31 - clz_optimized(n)
    li s1, 0              # odd = 0
    li s2, 0              # even = 0

loop:
    blt s0, x0, end_loop  # if s0 < 0, jump to end
    li t1, 1              # t1 = 1
    sll t1, t1, s0        # t1 = 1 << start
    and t1, t1, s3        # If n & (1 << s0)

    beq t1, x0, next      #If n & (1 << clz) == 0, pass

    andi t2, s0, 1        # check s0 is odd or even (s0 & 1)
    bnez t2, odd_case     # if odd, jump odd_case

    addi s2, s2, 1        # even++
    j next

odd_case:
    addi s1, s1, 1        # odd++

next:
    addi s0, s0, -1       # s0--
    j loop

end_loop:
    mv a0, s2
    mv a1, s1
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20
    jr ra
