// CSE141L
import definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[ 8:0] Instruction,	// machine code
  output logic [2:0] PCTarg,
  output logic [1:0] BranchEn,
  output logic Jump,
			   RegWrEn,	      // write to reg_file (common)
			   MemWrEn,	      // write to mem (store only)
			   LoadInst,	   // mem or ALU to reg_file ?
			   Ack		      // "done w/ program"
  );

/* ***** All numerical values are completely arbitrary and for illustration only *****
*/

// STR commands only -- write to data_memory
assign MemWrEn = Instruction[8:4]==5'b01101;

// all but STR and NOOP (or maybe CMP or TST) -- write to reg_file
assign RegWrEn = (Instruction[8:4]!=5'b01101) && (Instruction[8:4]!=5'b00110);

// route data memory --> reg_file for loads
//   whenever instruction = 9'b110??????; 
assign LoadInst = Instruction[8:4]==5'b01100;  // calls out load specially


// branch every time instruction = 9'b010??????;
always_comb
  if(Instruction[8:6] ==  3'b010)
    BranchEn = Instruction[5:4];
  else
    BranchEn = 00;


// jump enable command to program counter / instruction fetch module on right shift command
assign Jump = 0;

// whenever branch or jump is taken, PC gets updated or incremented from "Target"
//  PCTarg = 2-bit address pointer into Target LUT  (PCTarg in --> Target out
assign PCTarg  = Instruction[2:0];

// reserve instruction = 9'b000000000; for Ack
assign Ack = !(|Instruction);

endmodule

