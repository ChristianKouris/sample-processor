// Design Name:    basic_proc
// Module Name:    InstFetch 
// Project Name:   CSE141L
// Description:    instruction fetch (pgm ctr) for processor
//
// Revision:  2019.01.27
//
module InstFetch(
  input              Reset,			   // reset, init, etc. -- force PC to 0 
                     Start,			   // begin next program in series (request issued by test bench)
                     Clk,			   // PC can change on pos. edges only
                     BranchAbs,	       // jump unconditionally to Target value	     
  input        [1:0] BranchRelEn,	   // jump conditionally to Target + PC
                     ALU_flag,		   // flag from ALU, bit 1 is Z, bit 0 is N
  input        [9:0] Target,	       // jump ... "how high?"
  output logic [9:0] ProgCtr           // the program counter register itself
  );
	 
// program counter can clear to 0, increment, or jump
  always_ff @(posedge Clk)	           // or just always; always_ff is a linting construct
	if(Reset)
	  ProgCtr <= 0;				       // for first program; want different value for 2nd or 3rd
	else if(Start)					   // hold while start asserted; commence when released
	  ProgCtr <= ProgCtr;
	else if(BranchAbs)	               // unconditional absolute jump
	  ProgCtr <= Target;			   //   how would you make it conditional and/or relative?
	else if(!BranchRelEn[1] && BranchRelEn[0] && !ALU_flag[1])   // BNE BranchRelEn = 01, ALU_Flag = 0x
	  ProgCtr <= Target + ProgCtr;	   
	else if(BranchRelEn[1] && !BranchRelEn[0] && ALU_flag[0])   // BLT BranchRelEn = 10, ALU_Flag = x1
	  ProgCtr <= Target + ProgCtr;	   
	else if(BranchRelEn[1] && BranchRelEn[0] && !ALU_flag[1] && !ALU_flag[0])   // BNE BranchRelEn = 11, ALU_Flag = 00
	  ProgCtr <= Target + ProgCtr;	   
	else
	  ProgCtr <= ProgCtr+'b1; 	       // default increment (no need for ARM/MIPS +4 -- why?)

endmodule

/* Note about Start: if your programs are spread out, with a gap in your machine code listing, you will want 
to make Start cause an appropriate jump. If your programs are packed sequentially, such that program 2 begins 
right after Program 1 ends, then you won't need to do anything special here. 
*/