#The program takes a vector pointer in a0 and the size in a1. In the end it returns the same pointer, but with the reversed vector in memory

main:
	addi zero zero 0
	li sp,0xfffffff0
	li a0 0x00000800
    li a1 5
    
    #init vector A (a0)
    mv t0 a0
    mv t1 zero
    init_vector:
        sw t1 0(t0)
        addi t1 t1 1
        addi t0 t0 4
        bne t1 a1 init_vector
        
    #call reverse function
    jal reverse
    jal tailcode
    
    
reverse:

prologue:
	addi sp,sp -28
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw a0 16(sp)
    sw a1 20(sp)
    sw ra 24(sp)
    
	mv s0 a0	#V Base Address
    mv s1 a0	#RevV Base Address
    mv s2 a1	#offset to V base address 
    mv s3 a1	#offset to rev V base address 
    
    mv t0 s0	#V base address (const)
    mv t1 s1	#Temp Size (const)
    
    #1) Multiply s2 by four
    li a1 4
    mv a0 s2
    jal fast_multiply
    mv s2 a0
    
    #2) Multiplty s3 by four
    mv s3 s2
    mv t5 s3
    
loop_start:
    #3) Decrement s2 by four
    addi s2 s2 -4
    #4) read from s0 + s2
    add t3 s0 s2
    lw t2 0(t3)
    #5) store to s1 + s3
    add t4 s1 s3
    sw t2 0(t4)
	#6) Increment s3 by four
    addi s3 s3 4
    #7) If s2 bge zero go to 3
    bne s2 zero loop_start
    
loop_end:

	mv a0 s0
    add a0 a0 t5
    
epilogue:

	lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    #lw a0 16(sp)
    lw a1 20(sp)
    lw ra 24(sp)
    addi sp sp 28
    jr ra
    
tailcode:
	lui t0 0xfffff
    addi t0 t0 0x7ff
    addi t0 t0 0x001
    jalr zero t0 0x7ff  
    
fast_multiply:

	addi sp,sp -12
    sw s0 0(sp)
    sw s1 4(sp)
    sw ra 8(sp)
    
	li s0 0
   
    next_digit:
        andi s1 a1 1           # is rightmost bit 1?
        srai a1 a1 1

        beq s1 zero skip      # if right most bit 0, don't add
        add s0 s0 a0
    skip:
        slli a0, a0, 1           # double first argument
        bne a1, zero, next_digit
    
    mv a0, s0
    
    lw s0 0(sp)
    lw s1 4(sp)
    lw ra 8(sp)
    addi sp sp 12
    jr ra

