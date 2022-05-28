//*** Verilator testbench template ***

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Vbeta_regfile.h"
#include "verilated.h"

#include "verilated_vcd_c.h"

#define CLK_NS 10
#define CYCLES 700

void tick(int tickcount, Vbeta_regfile *tb, VerilatedVcdC *tfp);
void trace_init(Vbeta_regfile *tb, VerilatedVcdC * tfp);

int main(int argc, char **argv){
	
	Vbeta_regfile * tb = new Vbeta_regfile;
	VerilatedVcdC * tfp = new VerilatedVcdC;

	unsigned tickcount = 0;
	
	//START: Generate a trace
	trace_init(tb,tfp);
	//END: Generate a trace

	//START: Logic
	
	//Init core

	for(int i = 0; i < CYCLES; i++){
		(i == 0) ? tb->rstn_i = 0 : tb->rstn_i = 1; //N Reset for first clk cycle
		if(i > 1 && i < 32){
			tb->wr_en_i = 1;
			tb->rd_addr_i = 0x00 + i - 1;
			tb->rd_wdata_i = 2*i;
			tb->rs1_addr_i = 0x00 + i - 2;
			tb->rs2_addr_i = 0x00 + i - 2;
		}
		else{
			tb->wr_en_i = 0;		
		}

		tick(++tickcount,tb,tfp);
	}

	//END: Logic		
	
	delete tb;
	delete tfp;

}

void tick(int tickcount, Vbeta_regfile *tb, VerilatedVcdC *tfp){
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

void trace_init(Vbeta_regfile *tb, VerilatedVcdC * tfp){

	Verilated::traceEverOn(true);
	
	tb->trace(tfp,99);
	tfp->open("trace.vcd");
}

