//This file defines the parameters used in the alu
// CSE141L
//	Rev. 2020.5.27
// import package into each module that needs it
//   packages very useful for declaring global variables
package definitions;
    
// Instruction map
    const logic [3:0]kMOV  = 4'b0001;
    const logic [3:0]kLFS  = 4'b0010;
    const logic [3:0]kADD  = 4'b0011;
    const logic [3:0]kSUB  = 4'b0100;
    const logic [3:0]kXOR  = 4'b0101;
	 const logic [3:0]kCMP  = 4'b0110;
	 const logic [3:0]kPAR  = 4'b0111;
	 const logic [3:0]kBNE  = 4'b1001;
	 const logic [3:0]kBLT  = 4'b1010;
	 const logic [3:0]kBGT  = 4'b1011;
	 const logic [3:0]kLDR  = 4'b1100;
	 const logic [3:0]kSTR  = 4'b1101;
// enum names will appear in timing diagram
    typedef enum logic[3:0] {
        END, MOV, LSF, ADD, SUB, XOR, CMP, PAR } op_mne;
// note: kADD is of type logic[3:0] (4-bit binary)
//   ADD is of type enum -- equiv., but watch casting
//   see ALU.sv for how to handle this   
endpackage // definitions
