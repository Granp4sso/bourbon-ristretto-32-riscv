//*** Verilator testbench template ***

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Vbeta_top.h"
#include "verilated.h"

#include "verilated_vcd_c.h"

#define CLK_NS 10
#define CYCLES 700

void tick(int tickcount, Vbeta_top *tb, VerilatedVcdC *tfp);
void trace_init(Vbeta_top *tb, VerilatedVcdC * tfp);
void imem_protocol(unsigned  int * Memory, int * imem_en, int * imem_addr, Vbeta_top *tb);
void dmem_protocol(unsigned  int * Memory, int * dmem_en, int * dmem_addr, int * dmem_strb, int * op, Vbeta_top *tb);

int main(int argc, char **argv){
	
	Vbeta_top * tb = new Vbeta_top;
	VerilatedVcdC * tfp = new VerilatedVcdC;

	unsigned tickcount = 0;
	
	//START: Generate a trace
	trace_init(tb,tfp);
	//END: Generate a trace

	//START: Logic
	
	//Init core

	int i = 0;
	unsigned int imem[150] = {
		0x00000013, 	//NOP
		0x01A00313, 	//ADDI x6,x0,0x01a OK
		0x01034193, 	//XORI x3,x6,0x010 OK
		0x01036213, 	//ORI x4,x6,0x010 OK
		0x01037293, 	//ANDI x5,x6,0x010 OK
		0x00000013, 	//NOP
		0x00431313, 	//SLLI x6,x6,0x004 OK
		0x00235313, 	//SRLI x6,x6,0x002 OK
		0x40235313, 	//SRAI x6,x6,0x002 OK
		0x01034193,  	//XORI x3,x6,0x010 OK
		0x70A00313,	//ADDI x6,x0,70a
		0x40235313, 	//SRAI x6,x6,0x002 OK
		0x00000013, 	//NOP
		0xfff00313,	//ADDI x6,zero,0xfff
		0x7ff32393,	//SLTI x7,x6,0x7ff
		0x7ff33393,	//SLTIU x7,x6,0x7ff
		
		0x00220413,	//ADDI x8,x4,0x02
		0x00841393,	//SLLI x7,x8,0x08
		0x00841413,	//SLLI x8,x8,0x08	
		
		0x71A00313, 	//ADDI x6,x0,0x01a OK
		0xBFF00493,	//ADDI x9,x0,0xBff
		0x0084D513,	//SRLI x10,x9,0x10
		0x4084D593,	//SRAI x11,x9,0x10

		//Testing Reg instructions

		0x00300093,	//ADDI x1,x0,0x003
		0x00200113,	//ADDI x2,x0,0x002
		0x002081B3,	//ADD x3,x1,x2	OK
		0x40208233,	//SUB x4,x1,x2	OK

		0x0AA00293,	//addi x5,x0,0x0aa
		0x0051C333,	//xor  x6,x3,x5	OK
		0x00527333,	//and  x6,x4,x5	OK
		0x00526333,	//or   x6,x4,x5	OK
		0x001313B3,	//sll  x7,x6,x1	OK
		0x0013D433,	//srl  x8,x7,x1 OK
		0x4044D4B3,	//SRA  x9,x9,x4 OK
		0x4024D4B3,	//SRA  x9,x9,x2 OK
		0x4014D493,
		0x00A5A633,	//SLT x12,x11,x10
		0x00A5B633,	//SLTU x12,x11,x10
		0x00B536B3,	//SLTU x13,x10,x11		

		//Testing LUI and AUIPC instructions

		0x87654537,	//LUI x10,0x87654 OK
		0x00000597,	//AUIPC x11,0	  OK

		//Testing Jumps and Branches

		//0x010000EF,	//JAL x1,0x00010 OK
		//0x00000013, 	//NOP
		//0x00000013, 	//NOP
		//0x00000013, 	//NOP
		//0x01C081E7,	//JALR x3,x1,0x0001c OK

		//Testing Branches

		//0x10000063,	//BEQ x0,x0,0x100 OK
		0x10100063,	//BEQ x0,x1,0x100 OK Not Taken
		0xFE001BE3,	//BNE x0,x0,-10   OK Not Taken
		//0xFE101AE3,	//BNE x0,x1,-12	  OK,

		0xFE934CE3,	//BLT x6,x9-8	  OK Not Take
		//0xFE64CCE3,   //BLT x9,x6,-8	  OK Taken
		0xFE64DCE3,	//BGE x9,x6,-8	  OK Not Taken
		//0xFE935CE3,	//BGE x6,x9,-8	  OK Taken
		0xFE937CE3,	//BGEU x6,x9,-8	  OK Not Taken
		//0xFE64FCE3,	//BGEU x9,x6,-8   OK Taken
		0xFE64ECE3,	//BLTU x9,x6,-8	  Not Taken
		//0xFE936CE3,	//BLTU x6,x9,-8	  Taken

		0x00002683,	//LW	x13,0x000,x0
		0x4024D4B3,	//SRA  x9,x9,x2 OK
		0x00002683,	//LW	x13,0x000,x0
		0x00002683,	//LW	x13,0x000,x0
		0x00400113,	//ADDI
		0x02110023,	//SB
		0x02010A03,	//LB
		0x123451B7,	//LUI x3,0x12345	
		0x00301023,	//SH x3,0x000,x0
		0x00001503,	//LH x10,0x000,x0
		0x00302023,	//SW x3,0x000,x0
		0x00002503,	//LW x10,0x000,x0

	


	};

	unsigned int factorial_imem[150] = {
		0x00000013, 	//NOP
		0x00300093,	//first 3 bytes are the argument
		0xFFF08113,
		0x001001B3,
		0x00100F13,
		0x00100233,
		0xFFE20213,
		0xFFF10113,
		0x000102B3,
		0x001181B3,
		0x41E282B3,
		0xFE029CE3,
		0x41E10133,
		0x41E20233,
		0x003000B3,
		0xFE0212E3,	//Il registro x3 contiene il risultato finale

		0x00302023,
		0x00002303,
		0x00435393,
		0x00702223,
		0x00402403,	//fine load,store e srli

	};

	int imem_en = 0;
	int imem_addr = 0;

	unsigned int dmem[150] = {
		0x12345678,
	};
	int dmem_en = 0;
	int dmem_addr = 0;
	int dmem_strb = 0;
	int dmem_op = 0;
	
	while(i < CYCLES){

		printf("Cycle %d : ",i);

		imem_protocol(factorial_imem,&imem_en,&imem_addr,tb);
		dmem_protocol(dmem,&dmem_en,&dmem_addr,&dmem_strb, &dmem_op, tb);

		(i == 0) ? tb->rstn_i = 0 : tb->rstn_i = 1; //N Reset for first clk cycle
		//At the moment every RV32I I-type is working except for SLTI and SLTIU

		tick(++tickcount,tb,tfp);
		i++;

		printf("\n");
	}

	//END: Logic		
	
	delete tb;
	delete tfp;

}

void imem_protocol(unsigned int * Memory, int * imem_en, int * imem_addr, Vbeta_top *tb){

	switch(*imem_en){
		case 0: {
			if(tb->instr_req_o == 1){
				tb->instr_ready_i = 1;
				*imem_addr = tb->instr_addr_o;
				*imem_en = 1;
			}
			else{
				tb->instr_ready_i = 0;
			}
			tb->instr_valid_i = 0;
		break;
		}
		case 1: {
			tb->instr_valid_i = 1;
			tb->instr_ready_i = 0;
			tb->instr_rdata_i = Memory[*imem_addr/4];
			printf("Richiesta istruzione 0x%08x, indirizzo 0x%08x",Memory[*imem_addr/4],*imem_addr);
			*imem_en = 0;
		}
		break;
	}
}

void dmem_protocol(unsigned  int * Memory, int * dmem_en, int * dmem_addr, int * dmem_strb, int * op, Vbeta_top *tb){

	switch(*dmem_en){
		case 0: {
			if(tb->rdata_req_o == 1){
				tb->rdata_ready_i = 1;
				*dmem_addr = tb->rdata_addr_o;
				*dmem_strb = tb->rdata_strb_o;
				*dmem_en = 1;
				*op = 0;
			}
			else{
				tb->rdata_ready_i = 0;
			}

			if(tb->wdata_req_o == 1){
				tb->wdata_ready_i = 1;
				*dmem_addr = tb->wdata_addr_o;
				*dmem_strb = tb->wdata_strb_o;
				*dmem_en = 1;
				*op = 1;
			}
			else{
				tb->wdata_ready_i = 0;
			}

			tb->rdata_valid_i = 0;
			tb->wdata_valid_i = 0;
		break;
		}
		case 1: {
			if(*op == 0) {
				tb->rdata_valid_i = 1;
				tb->rdata_ready_i = 0;
				switch(*dmem_strb){
					case 0x1: tb->rdata_data_i = Memory[*dmem_addr/4] & 0x000000ff;	break;
					case 0x3: tb->rdata_data_i = Memory[*dmem_addr/4] & 0x0000ffff;	break;
					case 0xf: tb->rdata_data_i = Memory[*dmem_addr/4]; break;
				}
				printf("Richiesta Load : dato 0x%08x, indirizzo 0x%08x",tb->rdata_data_i,*dmem_addr);
			} else if(*op == 1){
				tb->wdata_valid_i = 1;
				tb->wdata_ready_i = 0;
				switch(*dmem_strb){
					case 0x1: Memory[*dmem_addr/4] = tb->wdata_data_o & 0x000000ff;	break;
					case 0x3: Memory[*dmem_addr/4] = tb->wdata_data_o & 0x0000ffff;	break;
					case 0xf: Memory[*dmem_addr/4] = tb->wdata_data_o ; break;
				}
				printf("Richiesta Store : indirizzo 0x%08x",*dmem_addr);
			}
			*dmem_en = 0;
		}
		break;
	}
}

void tick(int tickcount, Vbeta_top *tb, VerilatedVcdC *tfp){
	tb->eval();
	if(tfp) //dump 2ns before the tick
		tfp->dump(tickcount*CLK_NS - 2);
	tb->clk_i = 1;
	tb->eval();
	if(tfp) //Tick every CLK_NS
		tfp->dump(tickcount*CLK_NS);
	tb->clk_i = 0;
	tb->eval();
	if(tfp){ //Trailing edge dump
		tfp->dump(tickcount*CLK_NS+5);
		tfp->flush();
	}
}

void trace_init(Vbeta_top *tb, VerilatedVcdC * tfp){

	Verilated::traceEverOn(true);
	
	tb->trace(tfp,99);
	tfp->open("trace.vcd");
}

