The goal of this project is to build an 8-bit Turing complete processor on an FPGA (a Tang Nano 9K) in this case.

The project will use a custom assembly language to represent programs 

A microcontroller (ie: an Arduino UNO) will be used  for IO, ROM, and RAM.
(In this project, the FPGA is effectively the CPU, while the microcontroller is every other needed part)

16 Bits will be used for each instruction, so all instructions will be formatted as such:
	(INSTRUCTION)     (ARG)
		IE: LOD # 81 - Loads the value at address #81 (b:1000 0001) to the accumulator

Registers:
- ARR - Accumulator Result Register, stores the latest result of the accumulator or the latest data loaded in
- Z - Zero Flag, set to 1 if ARR is 0, otherwise is set to 0
- OF - Overflow Flag, set to 1 if latest operation to the ARR (ADD/SUB) caused an Overflow
- BMR - Boolean Result Register, stores the latest result of a boolean operation

Instructions:
- LOD
	- Loads a value from an address to the ARR
- ADD
	- Adds a value from an address to the ARR
- SUB
	- Subtracts the value stored at an address from the ARR
- INC
	- Increments ARR by 1
- DEC
	- Decrements ARR by 1
- LOD_IMM
	- Adds an immediate value to the ARR
		- IE: LOD_IMM # A0 sets ARR to A0
- CMP
	- same as SUB, does not modify ARR, can set flags
- STR
	- Saves the current value at the ARR to a given address
- LDB
	- Loads value from an address to the BMR
- OR
	- Performs binary OR operation on the BMR with a value from a given address
- AND
	- Performs binary AND operation on the BMR with a value from a given address 
- NAND
	- Performs binary NAND operation on the BMR with a value from a given address
- NOR
	- Performs binary NOR operation on the BMR with a value from a given address
- JMP
	- Jumps to an Address
- JNZ
	- If Z = 0, jumps to an Address
- JZ
	- If Z = 1, jumps to an Address
- JOF
	- If OF = 1, jumps to an Address
