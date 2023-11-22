module TessiaX64_tb();
    logic clk;
	logic reset;
    logic [4:0] RegisterToWrite;
    logic [63:0] DataToWriteIntoRegister;
    logic [63:0] AddressToWriteIntoMemory;
    logic [63:0] DataToWriteIntoMemory;
    logic EnableRegisterWrite;
    logic EnableMemoryWrite;
	logic [63:0] Instruction;
	logic [4:0] A1, A2;
	logic [63:0] Rd1, Rd2;
	logic [63:0] ALUResult;
	logic [63:0] SrcA, SrcB;
	logic [3:0] Operation;
	logic [63:0] ReadData;
	logic MemToReg;
	logic RegWriteM1;
	
	// instantiate device to be tested
	TessiaX64 DUT
	(
		.clk(clk), 
		.reset(reset),
		.DataToWriteIntoMemory(DataToWriteIntoMemory),
		.RegisterToWrite(RegisterToWrite),
		.DataToWriteIntoRegister(DataToWriteIntoRegister),
		.EnableRegisterWrite(EnableRegisterWrite),
		.EnableMemoryWrite(EnableMemoryWrite),
		.AddressToWriteIntoMemory(AddressToWriteIntoMemory),
		.Instruction(Instruction),
		.A1(A1),
		.A2(A2),
		.Rd1(Rd1),
		.Rd2(Rd2),
		.ALUResult(ALUResult),
		.SrcA(SrcA),
		.SrcB(SrcB),
		.Operation(Operation),
		.ReadData(ReadData),
		.MemToReg(MemToReg),
		.RegWriteM1(RegWriteM1)
	);

	// initialize test
	initial
	begin
		reset <= 1; # 100; reset <= 0;
	end

	integer clk_count = 0;
	always begin
		if (clk_count < 1000) begin
			clk <= 1; #5;
			clk <= 0; #5;
			clk_count = clk_count + 1;
		end else begin
			#1; // Wait for any remaining logic to settle before stopping the clock
			$stop;
		end
	end

	// Display the key signals
	// always @(EnableRegisterWrite, EnableMemoryWrite)
	// begin
	// 	// TessiaX32 will write a new value to a Register
	// 	if (EnableRegisterWrite) begin
	// 		$display("R%d = %d\n", RegisterToWrite, DataToWriteIntoMemory);
	// 	end
	// 	// TessiaX32 will write a new value to memory
	// 	else if (EnableMemoryWrite) begin
	// 		$display("RAM[%d] = %d\n", AddressToWriteIntoMemory, DataToWriteIntoMemory);
	// 	end
	// end
	always @(negedge clk)
	begin
		// Display when writing to a register
		if (EnableRegisterWrite == 1'b1 || MemToReg == 1'b1) begin
			$display("R%d = %d\n", RegisterToWrite, DataToWriteIntoRegister);
		end
		// Display when writing to memory
		if (EnableMemoryWrite == 1'b1) begin
			$display("MEMORY[%d] = %d\n", AddressToWriteIntoMemory, DataToWriteIntoMemory);
		end
	end

	// always @(ALUResult)
	// begin
	// 	// TessiaX32 will write a new value to a Register
	// 	$display("SrcA is %d, SrcB is %d, Operation is %b, ALU Result is: %d\n", SrcA, SrcB, Operation, ALUResult);
	// end
endmodule 