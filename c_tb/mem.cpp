#include "mem.h"

void init_mem(memory * Memory, char * path, const int type){

	for( int i = 0; i < DMEM_SIZE; i++ ) {
		Memory->mem[i].cell = 0x00;
		Memory->mem[i].attr = CLEAN;
	}
	Memory->mem_en = 0;
	Memory->mem_addr = 0;
	Memory->mem_op = 0;
	Memory->mem_strb = 0;

	if( type == MEM_TYPE_INSTR ){
	
		//FILE *binfile  = fopen("test_programs/reverse_vector/code.bin", "r");
		FILE *binfile  = fopen("testcode.bin", "r");
		// test for files not existing. 

		Memory->mem[0].cell = 0x13; Memory->mem[0].attr = EXECUTED;
		Memory->mem[1].cell = 0x00; Memory->mem[1].attr = EXECUTED;
		Memory->mem[2].cell = 0x00; Memory->mem[2].attr = EXECUTED;
		Memory->mem[3].cell = 0x00; Memory->mem[3].attr = EXECUTED;

		if (binfile == NULL) 
		{   
			printf("Error! Could not open file\n"); 
			exit(-1); // must include stdlib.h 
		} 
		printf("File opened\n");

		uint32_t temp;
		short int i = 4;

		while(fscanf(binfile, "%08x", &temp ) == 1){
			Memory->mem[i++].cell = temp & 0x000000ff;
			Memory->mem[i++].cell = (temp & 0x0000ff00) >> 8;
			Memory->mem[i++].cell = (temp & 0x00ff0000) >> 16;
			Memory->mem[i++].cell = (temp & 0xff000000) >> 24;
		}
		
		printf("Loaded program size: %u Bytes\n", (i-1));
	}
	else if( type == MEM_TYPE_DATA ){
		
	}

}

void imem_protocol(memory * Memory, Vristretto_top *tb){

	
	switch(Memory->mem_en){
		case 0: {
			if(tb->instr_req_o == 1){
				tb->instr_ready_i = 1;
				Memory->mem_addr = tb->instr_addr_o;
				Memory->mem_en = 1;
			}
			else{
				tb->instr_ready_i = 0;
			}
			tb->instr_valid_i = 0;
		break;
		}
		case 1: {
		
			uint32_t temp0 = (Memory->mem[Memory->mem_addr].cell);
			uint32_t temp1 = (Memory->mem[Memory->mem_addr+1].cell << 8);
			uint32_t temp2 = (Memory->mem[Memory->mem_addr+2].cell << 16);
			uint32_t temp3 = (Memory->mem[Memory->mem_addr+3].cell << 24);
			
			
			tb->instr_valid_i = 1;
			tb->instr_ready_i = 0;
			tb->instr_rdata_i = temp3 | temp2 | temp1 | temp0;
				
			Memory->mem[Memory->mem_addr].attr |= EXECUTED;
			Memory->mem[Memory->mem_addr+1].attr |= EXECUTED;
			Memory->mem[Memory->mem_addr+2].attr |= EXECUTED;
			Memory->mem[Memory->mem_addr+3].attr |= EXECUTED;
			
			printf("Richiesta istruzione 0x%08x, indirizzo 0x%08x",temp3|temp2|temp1|temp0, Memory->mem_addr);
			Memory->mem_en = 0;

			
		}
		break;
	}
}

void dmem_protocol(memory *  Memory, Vristretto_top *tb){

	switch(Memory->mem_en){
		case 0: {
			if(tb->rdata_req_o == 1){
				tb->rdata_ready_i = 1;
				Memory->mem_addr = tb->rdata_addr_o;
				Memory->mem_strb = tb->rdata_strb_o;
				Memory->mem_en = 1;
				Memory->mem_op = 0;
			}
			else{
				tb->rdata_ready_i = 0;
			}

			if(tb->wdata_req_o == 1){
				tb->wdata_ready_i = 1;
				Memory->mem_addr = tb->wdata_addr_o;
				Memory->mem_strb = tb->wdata_strb_o;
				Memory->mem_en = 1;
				Memory->mem_op = 1;
			}
			else{
				tb->wdata_ready_i = 0;
			}

			tb->rdata_valid_i = 0;
			tb->wdata_valid_i = 0;
		break;
		}
		case 1: {
		
			uint32_t temp0 = (Memory->mem[Memory->mem_addr].cell);
			uint32_t temp1 = (Memory->mem[Memory->mem_addr+1].cell << 8);
			uint32_t temp2 = (Memory->mem[Memory->mem_addr+2].cell << 16);
			uint32_t temp3 = (Memory->mem[Memory->mem_addr+3].cell << 24);
			
			if(Memory->mem_op == 0) {
				tb->rdata_valid_i = 1;
				tb->rdata_ready_i = 0;
				switch(Memory->mem_strb){
					case 0x1: 	
						tb->rdata_data_i = temp0;
						Memory->mem[Memory->mem_addr].attr |= READ;
					break;
					case 0x3:
						tb->rdata_data_i = temp1 | temp0;
						Memory->mem[Memory->mem_addr].attr |= READ;
						Memory->mem[Memory->mem_addr+1].attr |= READ;
					break;
					case 0xf:
						tb->rdata_data_i = temp3 | temp2 | temp1 | temp0; 
						Memory->mem[Memory->mem_addr].attr |= READ;
						Memory->mem[Memory->mem_addr+1].attr |= READ;
						Memory->mem[Memory->mem_addr+2].attr |= READ;
						Memory->mem[Memory->mem_addr+3].attr |= READ;
					break;
				}
				//printf("Richiesta Load : dato 0x%08x, indirizzo 0x%08x",tb->rdata_data_i,Memory->mem_addr);
			} else if(Memory->mem_op == 1){
				tb->wdata_valid_i = 1;
				tb->wdata_ready_i = 0;
				switch(Memory->mem_strb){
					case 0x1:
						Memory->mem[Memory->mem_addr].cell = (uint8_t)(tb->wdata_data_o & 0x000000ff);
						Memory->mem[Memory->mem_addr].attr |= WRITTEN;
					break;
					case 0x3:
						Memory->mem[Memory->mem_addr].cell = (uint8_t)(tb->wdata_data_o & 0x000000ff);
						Memory->mem[Memory->mem_addr].attr |= WRITTEN;
						Memory->mem[Memory->mem_addr+1].cell = (uint8_t)((tb->wdata_data_o & 0x0000ff00) >> 8);
						Memory->mem[Memory->mem_addr+1].attr |= WRITTEN;
						
					break;
					case 0xf:
						Memory->mem[Memory->mem_addr].cell = (uint8_t)(tb->wdata_data_o & 0x000000ff);
						Memory->mem[Memory->mem_addr].attr |= WRITTEN;
						Memory->mem[Memory->mem_addr+1].cell = (uint8_t)((tb->wdata_data_o & 0x0000ff00) >> 8);
						Memory->mem[Memory->mem_addr+1].attr |= WRITTEN;
						Memory->mem[Memory->mem_addr+2].cell = (uint8_t)((tb->wdata_data_o & 0x00ff0000) >> 16);
						Memory->mem[Memory->mem_addr+2].attr |= WRITTEN;
						Memory->mem[Memory->mem_addr+3].cell = (uint8_t)((tb->wdata_data_o & 0xff000000) >> 24);
						Memory->mem[Memory->mem_addr+3].attr |= WRITTEN;
					break;
				}
				//printf("Richiesta Store : indirizzo 0x%08x",Memory->mem_addr);
			}
			Memory->mem_en = 0;
		}
		break;
	}
}

void print_mem(memory *  Memory){

	printf("\t\t0x00\t0x01\t0x02\t0x03\t0x04\t0x05\tx06\t0x07\t0x08\t0x09\t0x0A\t0x0B\t0x0C\t0x0D\tx0E\t0x0F\n\n");
	for(int i = 0; i < MEM_PRINT_SIZE/16; i++){
	
		printf("0x%08x\t",16*i);
		for(int j = 0; j < 16; j++) {
			switch(Memory->mem[16*i+j].attr){
				case CLEAN: 		printf("0x%02x\t",Memory->mem[16*i+j].cell);			break;	//White
				case WRITTEN: 		printf("\x1b[33m0x%02x\t\x1b[0m",Memory->mem[16*i+j].cell);	break;	//Yellow
				case READ: 		printf("\x1b[34m0x%02x\t\x1b[0m",Memory->mem[16*i+j].cell);	break;	//Blue
				case EXECUTED: 		printf("\x1b[36m0x%02x\t\x1b[0m",Memory->mem[16*i+j].cell);	break;	//Cyan
				case WRITTEN|READ: 	printf("\x1b[32m0x%02x\t\x1b[0m",Memory->mem[16*i+j].cell);	break;	//Green
				default: 		printf("\x1b[35m0x%02x\t",Memory->mem[16*i+j].cell);		break;	//Magenta for undefined
			}
		}
		printf("\n");
	}
}

uint32_t mem_footprint(memory * Memory){

	uint32_t i;
	uint32_t footprint = 0;
	
	for(i = 0; i < DMEM_SIZE; i++){
		if( Memory->mem[i].attr != CLEAN ) footprint++;
	}
	
	return footprint;
}
