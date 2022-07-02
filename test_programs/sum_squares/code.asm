main:
	addi zero zero 0
	li sp,0xfffffff0
	li a0 10
    jal sum_squares
    jal tailcode
    
    
sum_squares:

prologue:
	addi sp,sp -16
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw ra 12(sp)
    
    li s0 1
    mv s1 a0
    li s2 0
    
loop_start:
	bge s0 s1 loop_end
    mv a0 s0
    jal square
    add s2 s2 a0
    addi s0 s0 1
    j loop_start
    
loop_end:
	mv a0 s2
    
epilogue:

	lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw ra 12(sp)
    addi sp sp 16
    jr ra
    

square:

	addi sp sp -12
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    
    mv s0 a0
    li s1 0x000
    li s2 0x000
    
    sqloop:
		beq s1 s0 end_sqloop
        addi s1 s1 1
        add s2 s2 s0
        j sqloop
        
        
    end_sqloop:
    
    mv a0 s2
    
	lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    addi sp sp 12
    
    jr ra
    
tailcode:
	lui t0 0xfffff
    addi t0 t0 0x7ff
    addi t0 t0 0x001
    jalr zero t0 0x7ff  

