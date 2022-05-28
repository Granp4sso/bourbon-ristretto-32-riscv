//*** Verilator testbench template ***

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Vbeta_shift_unit.h"
#include "verilated.h"

#include "verilated_vcd_c.h"

#define CLK_NS 10
#define CYCLES 50

void tick(int tickcount, Vbeta_shift_unit *tb, VerilatedVcdC *tfp);
void trace_init(Vbeta_shift_unit *tb, VerilatedVcdC * tfp);

int main(int argc, char **argv){
	
	Vbeta_shift_unit * tb = new Vbeta_shift_unit;
	VerilatedVcdC * tfp = new VerilatedVcdC;

	unsigned tickcount = 0;
	
	//START: Generate a trace
	trace_init(tb,tfp);
	//END: Generate a trace

	//START: Logic
	
	//Init core

	int i = 0;
	while(i < CYCLES){
		//0001 1110 0000 -> 0011 0100 0000
		//tb->exe_pc_i = 0x00000000;

		(i == 0) ? tb->rstn_i = 0 : tb->rstn_i = 1; //N Reset for first clk cycle
		if(i > 0){
			tb->operand_a_i = 0x01a00000;
			tb->operand_b_i = 0x04;
			tb->shift_mode_i = 0x01;
			tb->shift_en_i = 0x1;
			if(tb->shu_busy_o == 0 && i > 1) tb->shift_en_i = 0x0;
		}
		if(i > 4){
			tb->operand_a_i = 0x1a000000;
			tb->operand_b_i = 0x08;
			tb->shift_mode_i = 0x2;
			tb->shift_en_i = 0x1;
			if(tb->shu_busy_o == 0 && i > 5) tb->shift_en_i = 0x0;
		}
		if(i > 12){
			tb->operand_a_i = 0xfa000000;
			tb->operand_b_i = 0x08;
			tb->shift_mode_i = 0x3;
			tb->shift_en_i = 0x1;
			if(tb->shu_busy_o == 0 && i > 13) tb->shift_en_i = 0x0;
		}
		/*if(i == 2) tb->instr_i = 0x01A00313; //ADDI x6,x0,0x01a OK
		if(i == 3) tb->instr_i = 0x71032093; //SLTI x1,x6,0x710  NOT OK
		if(i == 4) tb->instr_i = 0x71033113; //SLTIU x2,x6,0x710 NOT OK
		if(i == 5) tb->instr_i = 0x01034193; //XORI x3,x6,0x010 OK
		if(i == 6) tb->instr_i = 0x01036213; //ORI x4,x6,0x010 OK
		//if(i == 7) tb->instr_i = 0x01037293; //ANDI x5,x6,0x010 OK
		if(i == 7) tb->instr_i = 0x00000013; // NOP
		if(i >= 8 && i < 12) tb->instr_i = 0x00431313; //SLLI x6,x6,0x004 OK
		if(i >= 12 && i < 15) tb->instr_i = 0x00235313; //SRLI x6,x6,0x002 OK
		if(i >= 15 && i < 18) tb->instr_i = 0x40235313; //SRAI x6,x6,0x002
		if(i >= 18) tb->instr_i = 0x01034193; //XORI x3,x6,0x010 */

		tick(++tickcount,tb,tfp);
		i++;
	}

	//END: Logic		
	
	delete tb;
	delete tfp;

}

void tick(int tickcount, Vbeta_shift_unit *tb, VerilatedVcdC *tfp){
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

void trace_init(Vbeta_shift_unit *tb, VerilatedVcdC * tfp){

	Verilated::traceEverOn(true);
	
	tb->trace(tfp,99);
	tfp->open("trace.vcd");
}

