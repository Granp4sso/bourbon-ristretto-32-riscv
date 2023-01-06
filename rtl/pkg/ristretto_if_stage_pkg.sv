`ifndef IF_STAGE_PKG
`define IF_STAGE_PKG


package ristretto_if_stage_pkg;

// Prefetch Buffer Parameters

parameter integer unsigned PrefetchBufferNone =     00;
parameter integer unsigned PrefetchBufferSmall =    04;
parameter integer unsigned PrefetchBufferMedium =   08;
parameter integer unsigned PrefetchBufferLarge =    16;
parameter integer unsigned PrefetchBufferHuge =     32;

//Instruction Memory Protocol State Machine MACROS

parameter integer unsigned imem_fsm_bsize = 2;

parameter logic[1:0] IMEM_IDLE = 2'b00;
parameter logic[1:0] IMEM_WRDY = 2'b01; //Wait for ready signal 
parameter logic[1:0] IMEM_WVLD = 2'b10; //Wait for valid signal



endpackage;

`endif
