#ifndef _Stim_MCPU_MEM_H
#define _Stim_MCPU_MEM_H

#include <queue>
#include <inttypes.h>
#include "MCPU_MEM_ports.h"

class Stim_MCPU_MEM {
	struct Command {
		uint8_t opcode;
		uint32_t addr;
		uint32_t wdata[8];
		uint32_t wbe;
	};
	
	MCPU_MEM_ports *ports;
	std::queue<Command> cmdq;
	
	uint8_t next_valid;
	uint8_t next_opcode;
	uint32_t next_addr;
	uint32_t next_wdata[8];
	uint32_t next_wbe;
	
	int stall_1a;

	const char *instance;
	
public:
	Stim_MCPU_MEM(MCPU_MEM_ports *_ports) : ports(_ports), next_valid(0), instance("unknown") { };
	Stim_MCPU_MEM(MCPU_MEM_ports *_ports, const char *instance) : ports(_ports), next_valid(0), instance(instance) { };
	
	void read(uint32_t addr, int through);
	void write(uint32_t addr, uint8_t data[32], uint32_t be, int through);
	void prefetch(uint32_t addr);
	void clean(uint32_t addr);
	
	void clk();
	
	int done();
};

#endif
