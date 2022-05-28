//*** Verilator testbench template ***

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Vbeta_alu.h"
#include "verilated.h"

#include "verilated_vcd_c.h"

#define CLK_NS 10
#define CYCLES 50

void tick(int tickcount, Vbeta_alu *tb, VerilatedVcdC *tfp);
void trace_init(Vbeta_alu *tb, VerilatedVcdC * tfp);

int main(int argc, char **argv){
	
	Vbeta_alu * tb = new Vbeta_alu;
	VerilatedVcdC * tfp = new VerilatedVcdC;

	unsigned tickcount = 0;
	
	//START: Generate a trace
	trace_init(tb,tfp);
	//END: Generate a trace

	//START: Logic
	
	//Init core

	int i = 0;
	while(i < CYCLES){
		
		if(tb->alu_op_end_o == 1){
			(i == 0) ? tb->rstn_i = 0 : tb->rstn_i = 1; //N Reset for first clk cycle
			if (i == 1){
				tb->operand_a_i = 0x00300210;
				tb->operand_b_i = 0x10000002;
				tb->operation_i = 0x00000020;//0010 0000 ADD
			}
			else if (i == 2){
				tb->operand_a_i = 0x00300210;
				tb->operand_b_i = 0x10000002;
				tb->operation_i = 0x00000010;//0001 0000 SUB
			}
			else if (i == 3){
				tb->operand_a_i = 0x00000001;
				tb->operand_b_i = 0x00000002;
				tb->operation_i = 0x00000004;//0000 0100 left shift
			}
			else if (i == 4){
				tb->operand_a_i = 0x00300210;
				tb->operand_b_i = 0x10000072;
				tb->operation_i = 0x00000001;//0000 0001 Logic AND
			}
			else if (i == 5){
				tb->operand_a_i = 0xff000000;
				tb->operand_b_i = 0x00000004;
				tb->operation_i = 0x00000008;//0000 1000 right shift
			}
			else if (i == 6){
				tb->operand_a_i = 0xff000000;
				tb->operand_b_i = 0x00000004;
				tb->operation_i = 0x0000000c;//0000 1100 right A shift
			}
			else if (i == 7){
				tb->operand_a_i = 0x00300210;
				tb->operand_b_i = 0x00000072;
				tb->operation_i = 0x00000001;//0000 0001 Logic AND
			}
			else if (i == 8){
				tb->operand_a_i = 0x00300210;
				tb->operand_b_i = 0x00000072;
				tb->operation_i = 0x000000c0;//0000 0001 SLTU
			}
			else if (i == 9){
				tb->operand_a_i = 0x00300210;
				tb->operand_b_i = 0x40000072;
				tb->operation_i = 0x000000c0;//0000 0001 SLTU
			}
			else if (i == 10){
				tb->operand_a_i = 0xc0300210;
				tb->operand_b_i = 0x00000072;
				tb->operation_i = 0x000000c0;//0000 0001 SLTU
			}
			else if (i == 11){
				tb->operand_a_i = 0x0300210;
				tb->operand_b_i = 0xc0000072;
				tb->operation_i = 0x000000c0;//0000 0001 SLTU
			}
			else if (i == 12){
				tb->operand_a_i = 0xa7300210;
				tb->operand_b_i = 0xa5000072;
				tb->operation_i = 0x000000c0;//0000 0001 SLTU
			}
			else if (i == 13){
				tb->operand_a_i = 0xf6300210;
				tb->operand_b_i = 0xf8ffff72;
				tb->operation_i = 0x000000c0;//0000 0001 SLTU
			}
			else if (i == 14){
				tb->operand_a_i = 0x00000000;
				tb->operand_b_i = 0x00000000;
				tb->operation_i = 0x000000c0;//0000 0001 SLTU
			}

			printf("Op[%d]: %02x\tA:%08x\tB:%08x\n",i,tb->operation_i,tb->operand_a_i,tb->operand_b_i);
			i++;

		}

		tick(++tickcount,tb,tfp);
	}

	//END: Logic		
	
	delete tb;
	delete tfp;

}

void tick(int tickcount, Vbeta_alu *tb, VerilatedVcdC *tfp){
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

void trace_init(Vbeta_alu *tb, VerilatedVcdC * tfp){

	Verilated::traceEverOn(true);
	
	tb->trace(tfp,99);
	tfp->open("trace.vcd");
}

