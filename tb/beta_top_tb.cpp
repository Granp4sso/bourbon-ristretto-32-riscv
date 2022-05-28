//*** Verilator testbench template ***

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Vbeta_top.h"
#include "verilated.h"

#include "verilated_vcd_c.h"

#define CLK_NS 10
#define CYCLES 50

void tick(int tickcount, Vbeta_top *tb, VerilatedVcdC *tfp);
void trace_init(Vbeta_top *tb, VerilatedVcdC * tfp);

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
	int Memory[100] = {
		0x01A00313, 	//ADDI x6,x0,0x01a OK
		//0x71032093, 	//SLTI x1,x6,0x710  NOT OK
		//0x71033113, 	//SLTIU x2,x6,0x710 NOT OK
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
		 

	};
	

	while(i < CYCLES){

		tb->fetch_en_i = 1;

		(i == 0) ? tb->rstn_i = 0 : tb->rstn_i = 1; //N Reset for first clk cycle
		if(i >= 1 && i <= 7){
			tb->instr_data_i = Memory[tb->instr_addr_o/4];
			
		}
		else if(i >= 8 && i <= 13){
			tb->instr_data_i = Memory[tb->instr_addr_o/4];
			tb->fetch_en_i = 0;
		}
		else if(i == 14){
			tb->instr_data_i = Memory[tb->instr_addr_o/4];
			tb->fetch_en_i = 1;
		}
		else if(i >= 15 && i <= 17){
			tb->instr_data_i = Memory[tb->instr_addr_o/4];
			tb->fetch_en_i = 0;
		}
		else if(i == 18){
			tb->instr_data_i = Memory[tb->instr_addr_o/4];
			tb->fetch_en_i = 1;
		}
		else if(i >= 19 && i <= 21){
			tb->instr_data_i = Memory[tb->instr_addr_o/4];
			tb->fetch_en_i = 0;
		}
		else if(i >= 22 && i <= 24){
			tb->instr_data_i = Memory[tb->instr_addr_o/4];
			tb->fetch_en_i = 1;
		}
		else if(i >= 25 && i <= 27){
			tb->instr_data_i = Memory[tb->instr_addr_o/4];
			tb->fetch_en_i = 0;
		}
		else if(i >= 28){
			tb->instr_data_i = Memory[tb->instr_addr_o/4];
			tb->fetch_en_i = 1;
		}
		else{
			tb->instr_data_i = 0;
		}

		tick(++tickcount,tb,tfp);
		i++;
	}

	//END: Logic		
	
	delete tb;
	delete tfp;

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

