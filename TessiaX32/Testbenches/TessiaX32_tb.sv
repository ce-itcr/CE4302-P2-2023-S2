module TessiaX32_tb();
    logic clk;
	logic reset;
    logic [31:0] DataToWriteIntoMemory;
    logic [3:0] RegisterToWrite;
    logic [31:0] DataToWriteIntoRegister;
    logic EnableRegisterWrite;
    logic EnbaleMemoryWrite;
	logic [31:0] AddressToWriteIntoMemory;
	
	// instantiate device to be tested
	TessiaX32 DUT
	(
		.clk(clk), 
		.reset(reset),
		.DataToWriteIntoMemory(DataToWriteIntoMemory),
		.RegisterToWrite(RegisterToWrite),
		.DataToWriteIntoRegister(DataToWriteIntoRegister),
		.EnableRegisterWrite(EnableRegisterWrite),
		.EnbaleMemoryWrite(EnableRegisterWrite),
		.AddressToWriteIntoMemory(AddressToWriteIntoMemory)
	);

	// initialize test
	initial
	begin
		reset <= 1; # 100; reset <= 0;
	end

	integer clk_count = 0;
	always begin
		if (clk_count < 400) begin
			clk <= 1; #5;
			clk <= 0; #5;
			clk_count = clk_count + 1;
		end else begin
			#1; // Wait for any remaining logic to settle before stopping the clock
			$stop;
		end
	end

	// Display the key signals
	always @(EnableRegisterWrite, EnbaleMemoryWrite)
	begin
		// TessiaX32 will write a new value to a Register
		if (EnableRegisterWrite) begin
			$display("Writing a the value %d into the register %d\n", RegisterToWrite, DataToWriteIntoRegister);
		end
		// TessiaX32 will write a new value to memory
		else if (EnbaleMemoryWrite) begin
			$display("Writing the value %d into the memory address %d\n", DataToWriteIntoMemory, AddressToWriteIntoMemory);
		end
	end
endmodule