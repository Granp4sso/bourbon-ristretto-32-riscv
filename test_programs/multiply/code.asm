main:
	addi zero zero 0
	li sp,0xfffffff0
	li a0 10
    li a1 12
    jal multiply
    jal tailcode
   
multiply:
	li   t0, 0         # set t0 to 0
accumulate:
	add  t0 t0 a0
	addi a1 a1 -1      # decrement a10
	bgt a1 zero accumulate
	mv  a0 t0           # copy t0 value to a0
	jr ra                  # return to calling function
    
    
tailcode:
	lui t0 0xfffff
    addi t0 t0 0x7ff
    addi t0 t0 0x001
    jalr zero t0 0x7ff  
