// Revision Date:    2020.08.05
// Design Name:    BasicProcessor
// Module Name:    TopLevel 
// CSE141L
// partial only										   
module top_level(		   // you will have the same 3 ports
    input        init,	   // init/reset, active high
			        req,    // start next program
	              clk,	   // clock -- posedge used inside design
    output logic ack	   // done flag from DUT
    );

wire [ 9:0] PgmCtr,        // program counter
			   PCTarg;
wire [ 8:0] Instruction;   // our 9-bit opcode
wire [ 7:0] ReadA, ReadB;  // reg_file outputs
wire [ 7:0] InA, InB, 	   // ALU operand inputs
            ALU_out;       // ALU result
wire [ 7:0] RegWriteValue, // data in to reg file
            MemWriteValue, // data in to data_memory
	   	   MemReadValue,  // data out from data_memory
				RegWriteTemp;  // data out from the 2:1 mux
wire [ 2:0] TargSel;				
wire [ 1:0] WriteReg,      // data in to Write Register Address
				Flag,				// ALU output[1] = zero flag, output[0] = Negative Flag
				BranchEn;	   // to program counter: branch enable
wire        MemWrite,	   // data_memory write enable
			   RegWrEn,	   // reg_file write enable
				LoadInst,
            Jump;	       // to program counter: jump 
logic[15:0] CycleCt;	   // standalone; NOT PC!

// Fetch stage = Program Counter + Instruction ROM
  InstFetch IF1 (		       // this is the program counter module
	.Reset        (init   ) ,  // reset to 0
	.Start        (req   ) ,  // SystemVerilog shorthand for .grape(grape) is just .grape 
	.Clk          (clk     ) ,  //    here, (Clk) is required in Verilog, optional in SystemVerilog
	.BranchAbs    (Jump    ) ,  // jump enable
	.BranchRelEn  (BranchEn) ,  // branch enable
	.ALU_flag	  (Flag    ) ,  // 
    .Target       (PCTarg  ) ,  // "where to?" or "how far?" during a jump or branch
	.ProgCtr      (PgmCtr  )	   // program count = index to instruction memory
	);					  

LUT LUT1(.Addr         (TargSel ) ,
         .Target       (PCTarg  )
    );

// instruction ROM -- holds the machine code pointed to by program counter
  InstROM #(.W(9)) IR1(
	.InstAddress  (PgmCtr     ) , 
	.InstOut      (Instruction)
	);

// Decode stage = Control Decoder + Reg_file
// Control decoder
  Ctrl Ctrl1 (
	.Instruction  (Instruction) ,  // from instr_ROM
	.Jump         (Jump       ) ,  // to PC to handle jump/branch instructions
	.BranchEn     (BranchEn   )	,  // to PC
	.RegWrEn      (RegWrEn    )	,  // register file write enable
	.MemWrEn      (MemWrite   ) ,  // data memory write enable
    .LoadInst     (LoadInst   ) ,  // selects memory vs ALU output as data input to reg_file
    .PCTarg       (TargSel    ) ,    
    .Ack          (ack        )	   // "done" flag
  );

// reg file
	RegFile #(.W(8),.D(2)) RF1 (			  // D(3) makes this 8 elements deep
		.Clk       (clk),
		.WriteEn   (RegWrEn)    , 
		.RaddrA    (Instruction[3:2]),        //concatenate with 0 to give us 4 bits
		.RaddrB    (Instruction[1:0]), 
		.Waddr     (WriteReg), 	      // mux above
		.DataIn    (RegWriteValue) , 
		.DataOutA  (ReadA        ) , 
		.DataOutB  (ReadB		 )
	);
/* one pointer, two adjacent read accesses: 
  (sample optional approach)
	.raddrA ({Instruction[5:3],1'b0});
	.raddrB ({Instruction[5:3],1'b1});
*/
    assign InA = ReadA;						  // connect RF out to ALU in
	assign InB = ReadB;	          			  // interject switch/mux if needed/desired
// controlled by Ctrl1 -- must be high for load from data_mem; otherwise usually low
	assign RegWriteTemp = LoadInst? MemReadValue : ALU_out;  // 2:1 switch into reg_file
	assign RegWriteValue = Instruction[8] ? Instruction[7:0] : RegWriteTemp; //2:1 to load an immediate constant or reg val
	assign WriteReg = Instruction[8] ? 2'b11 : Instruction[3:2];
    ALU ALU1  (
	  .InputA  (InA),
	  .InputB  (InB), 
	  .SC_in   ('b1),
	  .OP      (Instruction[7:4]),
	  .Out     (ALU_out),//regWriteValue),
	  .Flag		                              // status flag; may have others, if desired
	  );
  
	DataMem DM(
		.DataAddress  (ReadB)    , 
		.WriteEn      (MemWrite), 
		.DataIn       (ReadA), 
		.DataOut      (MemReadValue), 
		.Clk          (clk),
		.Reset		  (init)
	);
	
/* count number of instructions executed
      not part of main design, potentially useful
      This one halts when Ack is high  
*/
always_ff @(posedge clk)
  if (req == 1)	   // if(start)
  	CycleCt <= 0;
  else if(ack == 0)   // if(!halt)
  	CycleCt <= CycleCt+16'b1;

endmodule