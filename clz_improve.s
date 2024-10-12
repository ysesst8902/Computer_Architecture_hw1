main:
    li a0, 0x3C00
    jal ra, clz_optimized
    # �{�������G�i��L���`���θ���쵲�����ҡA�קK�~�����
    li a7, 10
    ecall
    
clz_optimized:
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    li s0, 32        
    beq a0, x0, ifInputZero   # �p�G��J�� 0�A������^ 32
    li s0, 0          # ��l�� s0 ���s (clz ���G)
    
check_high_16:
    srli s2, a0, 16   # �k�� 16 ���ˬd����
    beq s2, x0, check_low_16
    slli a0, a0, 16   # �N a0 ���� 16 ��A�ˬd�C��
    j check_high_8    # ����U�@�Ӱ� 8 ���ˬd

check_low_16:
    # �� 16 �쬰�s�A�~���ˬd�C��
    addi s0, s0, 16   # �� 16 �즳 0�A�ҥH�p�ƾ��[�W 16

check_high_8:
    srli s2, a0, 8    # �k�� 8 ���ˬd�� 8 ��
    beq s2, x0, check_low_8
    slli a0, a0, 8    # ���� 8 ��
    j check_high_4

check_low_8:
    addi s0, s0, 8    # �� 8 �즳 0�A�p�ƾ��[�W 8

check_high_4:
    srli s2, a0, 4    # �k�� 4 ���ˬd�� 4 ��
    beq s2, x0, check_low_4
    slli a0, a0, 4
    j check_high_2

check_low_4:
    addi s0, s0, 4

check_high_2:
    srli s2, a0, 2    # �k�� 2 ���ˬd�� 2 ��
    beq s2, x0, check_low_2
    addi s0, s0, 2
    slli a0, a0, 2
    j check_final

check_low_2:
    addi s0, s0, 2   

check_final:
    srli s2, a0, 1    # �̫��ˬd�̰���
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
