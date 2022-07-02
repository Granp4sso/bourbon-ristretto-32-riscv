main:
	addi zero zero 0
	li sp,0xfffffff0
	li a0 10
    li a1 12
    jal fast_multiply
    jal tailcode
   
fast_multiply:
	li t0 0
   
next_digit:
	andi t1 a1 1           # is rightmost bit 1?
	srai a1 a1 1
   
	beq t1 zero skip      # if right most bit 0, don't add
	add t0 t0 a0
skip:
	slli a0, a0, 1           # double first argument
	bne a1, zero, next_digit
	mv a0, t0
	jr ra
    
    
tailcode:
	lui t0 0xfffff
    addi t0 t0 0x7ff
    addi t0 t0 0x001
    jalr zero t0 0x7ff  
