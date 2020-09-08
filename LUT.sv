/* CSE141L
   possible lookup table for PC target
   leverage a few-bit pointer to a wider number
   Lookup table acts like a function: here Target = f(Addr);
 in general, Output = f(Input); lots of potential applications 
*/
module LUT(
  input       [ 2:0] Addr,
  output logic[ 9:0] Target
  );

always_comb begin
  Target = 10'h001;	   // default to 1 (or PC+1 for relative)
  // we need 2, -5, -6, -7, -8, -13, -14, -17
  case(Addr)		   
	3'b000:   Target = 10'h002;   // 2, i.e., move ahead 2 lines of machine code
	3'b001:	 Target = 10'h3fb;	// -5, two's comp 11 1111 1011
	3'b010:	 Target = 10'h3fa;	// -6,  11 1111 1010
	3'b011:	 Target = 10'h3f9;	// -7,  11 1111 1001
	3'b100:	 Target = 10'h3f8;	// -8,  11 1111 1000
	3'b101:	 Target = 10'h3f3;	// -13, 11 1111 0011
	3'b110:	 Target = 10'h3f2;	// -14, 11 1111 0010
	3'b111:	 Target = 10'h3ef;	// -17, 11 1110 1111
  endcase
end

endmodule