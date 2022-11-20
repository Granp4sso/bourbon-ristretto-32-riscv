
#Vector Table

nop											# 0x00 empty address
Handler_rst: 				j	Reset		# 0x04 Reset Handler
Handler_misal_instr: 		j	Tailcode	# 0x08 Misaligned Instruction Handler
nop											# 0x0c Instruction Access Fault Handler
Handler_illeg_instr: 		j	Tailcode	# 0x10 Illegal instruction Handler
nop											# 0x14 Breakpoint Handler
Handler_misal_load : 		j	Tailcode	# 0x18 Load address misaligned Handler
nop											# 0x1c Load access fault Handler
Handler_misal_store: 		j	Tailcode	# 0x20 Store/AMO address misaligned Handler
nop											# 0x24 Store/AMO access fault Handler
Handler_ecall_u:	 		j	Tailcode	# 0x28 Environment call from U-mode Handler
nop											# 0x2c Reserved
nop											# 0x30 Reserved
Handler_ecall_m:	 		j	Tailcode	# 0x34 Environment call from M-mode Handler

nop											# 0x38
nop											# 0x3c
nop											# 0x40
nop											# 0x44
nop											# 0x48
nop											# 0x4c
nop											# 0x50
Handler_sw_int : 			j 	sw_int		# 0x54 SW interrupt handler
nop											# 0x58
nop											# 0x5c
nop											# 0x60
Handler_tim_int : 			j 	tim_int		# 0x64 TIM interrupt handler
nop											# 0x68
nop											# 0x6c
nop											# 0x70
Handler_ext_int : 			j 	ext_int		# 0x74 EXT interrupt handler
nop											# 0x78

Reset:

	li sp,0xfffffff0
	li t0,0x8		
    li t1 0x888		
    csrrw zero,0x300,t0						#Enable global interrupts
    csrrw zero,0x304,t1						#Enable all interrupts (Ext, Tim, Sw)
    jal Main

Main:


    jal Tailcode

    
sw_int:

    li s1,0x008
    csrrc zero,0x344,s1						#clear SW pending
    ret										# mret 30200073
    
tim_int:

    li s1,0x080
    csrrc zero,0x344,s1						#clear TIM pending
    ret										# mret 30200073
    
ext_int:

    li s1,0x800
    csrrc zero,0x344,s1						#clear EXT pending
    ret										# mret 30200073

Tailcode:

	lui t0 0xfffff
    addi t0 t0 0x7ff
    addi t0 t0 0x001
    jalr zero t0 0x7fc  
  
