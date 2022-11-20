//*** Verilator testbench template ***

#include <stdio.h>
#include <stdlib.h>
#include "Vristretto_top.h"
#include "verilated.h"

#include "verilated_vcd_c.h"
#include "mem.h"

#define CLK_NS 10
#define CYCLES 100000
#define DEBUG_MODE 1

short int GLOBAL_HALT = 0;

void tick(int tickcount, Vristretto_top *tb, VerilatedVcdC *tfp);
void trace_init(Vristretto_top *tb, VerilatedVcdC * tfp);

int main(int argc, char **argv){
	
	Vristretto_top * tb = new Vristretto_top;
	VerilatedVcdC * tfp = new VerilatedVcdC;

	unsigned tickcount = 0;
	
	//START: Generate a trace
	trace_init(tb,tfp);
	//END: Generate a trace

	//START: Logic
	
	//Init core

	int i = 0;

	memory imem;
	memory dmem;

	printf("%s\n",argv[1]);
	init_mem(&imem,argv[1],MEM_TYPE_INSTR);
	init_mem(&dmem,argv[1],MEM_TYPE_DATA);

	while(i < CYCLES && GLOBAL_HALT == 0){
	
		/*if( i == 50 ) tb->sw_intr_i = 1;
		else tb->sw_intr_i = 0;
		
		if( i == 51 ) tb->tim_intr_i = 1;
		else tb->tim_intr_i = 0;
		
		if( i == 52 ) tb->ext_intr_i = 1;
		else tb->ext_intr_i = 0;*/


		if(tb->instr_addr_o == 0xfffffffc) GLOBAL_HALT = 1; //every program must end with a jump to 0xffffffff
		else if(tb->instr_addr_o >= IMEM_SIZE){
			GLOBAL_HALT = 1;
			printf("Requesting out of range memory location...\n");
		}
		else{
			printf("Cycle %d : ",i);
			imem_protocol(&imem,tb);
			dmem_protocol(&dmem,tb);
		}
		
		(i == 0) ? tb->rstn_i = 0 : tb->rstn_i = 1;

		tick(++tickcount,tb,tfp);
		i++;

		printf("\n");

	}
	//END: Logic	
	printf("Printing Instruction Memory..\n\n");
	print_mem(&imem);
	
	printf("\n\nPrinting Data Memory..\n\n");
	print_mem(&dmem);

	printf("Report:\n");
	printf("Clock Cycles: %u\nInstruction Memory Used: %u Bytes\nData Memory Used: %u Bytes\n",i-14,mem_footprint(&imem),mem_footprint(&dmem));
	
	delete tb;
	delete tfp;

}

void tick(int tickcount, Vristretto_top *tb, VerilatedVcdC *tfp){
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

void trace_init(Vristretto_top *tb, VerilatedVcdC * tfp){

	Verilated::traceEverOn(true);
	
	tb->trace(tfp,99);
	tfp->open("trace.vcd");
}

