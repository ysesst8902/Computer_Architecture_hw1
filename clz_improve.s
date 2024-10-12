main:
    li a0, 0x3C00
    jal ra, clz_optimized
    # 程式結束：進行無限循環或跳轉到結束標籤，避免繼續執行
    li a7, 10
    ecall
    
clz_optimized:
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    li s0, 32        
    beq a0, x0, ifInputZero   # 如果輸入為 0，直接返回 32
    li s0, 0          # 初始化 s0 為零 (clz 結果)
    
check_high_16:
    srli s2, a0, 16   # 右移 16 位檢查高位
    beq s2, x0, check_low_16
    slli a0, a0, 16   # 將 a0 左移 16 位，檢查低位
    j check_high_8    # 跳到下一個高 8 位檢查

check_low_16:
    # 高 16 位為零，繼續檢查低位
    addi s0, s0, 16   # 高 16 位有 0，所以計數器加上 16

check_high_8:
    srli s2, a0, 8    # 右移 8 位檢查高 8 位
    beq s2, x0, check_low_8
    slli a0, a0, 8    # 左移 8 位
    j check_high_4

check_low_8:
    addi s0, s0, 8    # 高 8 位有 0，計數器加上 8

check_high_4:
    srli s2, a0, 4    # 右移 4 位檢查高 4 位
    beq s2, x0, check_low_4
    slli a0, a0, 4
    j check_high_2

check_low_4:
    addi s0, s0, 4

check_high_2:
    srli s2, a0, 2    # 右移 2 位檢查高 2 位
    beq s2, x0, check_low_2
    addi s0, s0, 2
    slli a0, a0, 2
    j check_final

check_low_2:
    addi s0, s0, 2   

check_final:
    srli s2, a0, 1    # 最後檢查最高位
    beq s2, x0, final_add1
    j ifInputZero

final_add1:
    addi s0, s0, 1


ifInputZero:
    mv a0, s0

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)

    addi sp, sp, 16
    jr ra
