module InstructionMemory(
    input logic [31:0] a,
	output logic [31:0] rd
);

  // Define the ROM array with initial values
  logic [31:0] ROM [63:0];

	 // Initialize ROM with values
	initial begin
		ROM[0] = 32'b01100010110000000000000000001010;
		ROM[1] = 32'b01100010110000000001000000000000;
		ROM[2] = 32'b01100001000000010000000000000000;
		ROM[3] = 32'b01011010000000000000000000000101;
		ROM[4] = 32'b01100000000000000011000000000001;
		ROM[5] = 32'b01100010000000010100000000000000;
		ROM[6] = 32'b01100110000001000011000000000000;
		ROM[7] = 32'b01100010000000010001000000000001;
		ROM[8] = 32'b01101000000000000000000000001000;
		ROM[9] = 32'b01100000001011110101000000001111;
		
		for (int i = 10; i < 64; i++) begin
		  ROM[i] = 32'h0;
		end
	end
	// Assign the output based on the input address
	assign rd = ROM[a[31:2]]; // word aligned
endmodule