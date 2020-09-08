// Create Date:    2018.10.15
// Module Name:    ALU 
// Project Name:   CSE141L
//
// Revision 2020.01.27
// Additional Comments: 
//   combinational (unclocked) ALU
import definitions::*;			         // includes package "definitions"
module ALU(
  input        [7:0] InputA,             // data inputs
                     InputB,
  input        [3:0] OP,		         // ALU opcode, part of microcode
  input              SC_in,            // shift or carry in
  output logic [7:0] Out,		         // or:  output reg [7:0] OUT,
  output logic [1:0] Flag              // output[1] = zero flag, output[0] = Negative Flag
           // you may provide additional status flags, if desired
    );								    
	 
  op_mne op_mnemonic;			         // type enum: used for convenient waveform viewing
	
  always_comb begin
    Out = 0;                             // No Op = default
    case(OP)
	   kMOV : Out = InputB;
      kLFS : Out = {InputA[5:0],^(InputB&InputA)};
      kADD : Out = InputA + InputB;
      kSUB : Out = InputA - InputB;
      kXOR : Out = InputA ^ InputB;
	   kCMP : Out = InputA - InputB;
	   kPAR : Out = {^(InputA),InputA[6:0]};
    endcase
  end

  always_comb							  // assign Zero = !Out;
    case(Out)
      'b0    : Flag[1] = 1'b1;
	  default : Flag[1] = 1'b0;
    endcase
  
  always_comb
	 case(Out[7])
		'b1	  : Flag[0] = 1'b1;
		default : Flag[0] = 1'b0;
    endcase
  always_comb
    op_mnemonic = op_mne'(OP);			 // displays operation name in waveform viewer

endmodule