module TessiaX32_tb();
	logic clk;
	logic reset;
	logic RegWrite, MemToReg;
	logic [31:0] ALUResult;
	logic [3:0] ALUFlags, A3;
	logic [31:0] Instruction;
	logic [31:0] WriteData, WD3, ResultWB;
	logic [31:0] SrcA, SrcB;
	logic [1:0] ForwardA, ForwardB;
	logic [3:0] ALUOP;
	logic BranchTaken;
	logic [3:0] ALUFlagsE0;
	
	// instantiate device to be tested
	TessiaX32 DUT(
		.clk(clk), 
		.reset(reset),
    	.ALUResultE(ALUResult),
   	.ALUFlagsE(ALUFlags),
		.Instruction(Instruction),
		.WriteData(WriteData),
		.RegWrite(RegWrite),
		.A3(A3),
		.WD3(WD3),
		.MemToReg(MemToReg),
		.ResultWB(ResultWB),
		.SrcA(SrcA),
		.SrcB(SrcB),
		.ForwardA(ForwardA), 
		.ForwardB(ForwardB),
		.ALUOP(ALUOP),
		.BranchTaken(BranchTaken),
		.ALUFlagsE0(ALUFlagsE0));
	
	// initialize test
	initial
	begin
		reset <= 1; # 100; reset <= 0;
	end

	integer clk_count = 0;
	always begin
		if (clk_count < 100) begin
			clk <= 1; #5;
			clk <= 0; #5;
			clk_count = clk_count + 1;
		end else begin
			#1; // Wait for any remaining logic to settle before stopping the clock
			$stop;
		end
	end

	// at end of program
	always @(negedge clk)
	begin
		// $display("The ALU result is: %d, The", ALUResult);
		if (RegWrite) begin
			$display("Decode {Reg to Write: %d, Value: %d}", A3, WD3);
		end
			$display("Execute {Operation: %b, SrcA: %d, SrcB: %d, ALUResult: %d, ALUFlagsE0: %b ALUFlagsE: %b, BranchTaken: %d}",ALUOP, SrcA, SrcB, ALUResult,ALUFlagsE0, ALUFlags, BranchTaken);
			//$display("WriteBack {MemToReg: %d, ResultW: %d}", MemToReg, ResultWB);
			$display("\n \n");
	end
endmodule