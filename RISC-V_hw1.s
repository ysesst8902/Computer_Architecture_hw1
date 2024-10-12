main:
    li a0, 0x3C00
    jal ra, fp16_to_fp32
    # 程式結束：進行無限循環或跳轉到結束標籤，避免繼續執行
    li a7, 10
    ecall

# a0: 輸入浮點數，格式為 IEEE 754 單精度
# 返回值為 a0 (修改後的結果)
clz:
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    beq a0, x0, ifInputZero
    addi s0, x0, 0
    li s1, 31
count_zero:
    li s2, 1
    sll s2, s2, s1
    and s3, a0, s2

    bne s3, x0, count_zero_End
    addi s0, s0, 1
    addi s1, s1, -1
    bne s1, x0, count_zero
ifInputZero:
    li s0, 32
count_zero_End:
    mv a0, s0
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20
    jr ra
    
fp16_to_fp32:
    addi sp, sp, -16
    sw ra, 0(sp)
    
    slli t0, a0, 16 # 將輸入浮點數左移 16 位 w
    li t1, 0x7FFFFFFF
    and t3, t0, t1 # 取出指數與尾數 nonsign
    sw t0, 4(sp)
    sw t3, 8(sp)
    sw a0, 12(sp)
    mv a0, t3
    jal ra, clz
    mv t4, a0 # renorm_shift: t4 暫存clz回傳結果
    lw t0, 4(sp)
    lw t3, 8(sp)
    lw a0, 12(sp)
    li t1, 0x80000000 # t1 暫存32bit數字
    
    li t1, 5
    bgt t4, t1, overflow
    li t4, 0 # renorm_shift
    j isOverflowEnd
overflow:
    addi t4, t4, -5  # renorm_shift 

isOverflowEnd:
    li t1, 0x04000000
    add t5, t1, t3
    srli t5, t5, 8
    li t1, 0x7F800000
    and t5, t5, t1 # inf_nan_mask
    
    addi t1, t3, -1
    srli t1, t1, 31 #t1 暫存 zero_mask
    sll t3, t3, t4
    srli t3, t3, 3 # (nonsign << renorm_shift >> 3)
    li t6, 0x70 
    sub t4, t6, t4 
    slli t4, t4, 23 # ((0x70 - renorm_shift) << 23)
    add t3, t3, t4 # ((nonsign << renorm_shift >> 3) + ((0x70 - renorm_shift) << 23))
    or t3, t3, t5
    not t1, t1
    and t3, t3, t1    
    or t3, t3, t2
    mv a0, t3
    lw ra, 0(sp)
    addi sp, sp, 16
    jr ra