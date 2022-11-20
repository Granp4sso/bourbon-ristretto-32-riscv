#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

#include "Vristretto_top.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

#define IMEM_SIZE 1024*32 //32KB of memory
#define DMEM_SIZE 1024*32 //32KB of memory
#define MEM_TYPE_DATA 0
#define MEM_TYPE_INSTR 1
#define MEM_PRINT_SIZE 1024*1

#define CLEAN   	0x00
#define WRITTEN 	0x01
#define READ		0x02
#define EXECUTED 	0x04


struct memcell{
	uint8_t cell;
	uint8_t attr;
};

struct memory{

	memcell mem[DMEM_SIZE];
	int mem_en;
	int mem_addr;
	int mem_op;
	int mem_strb;
};

void init_mem(memory * Memory, char * path,  const int type);
void imem_protocol(memory * Memory, Vristretto_top *tb);
void dmem_protocol(memory * Memory, Vristretto_top *tb);
void print_mem(memory * Memory);
uint32_t mem_footprint(memory * Memory);
