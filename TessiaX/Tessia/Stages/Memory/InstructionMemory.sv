module InstructionMemory(
    input logic [31:0] a,
	output logic [31:0] rd
);

  // Define the ROM array with initial values
  logic [31:0] ROM [63:0];

	 // Initialize ROM with values
	initial begin
		ROM[0] = 32'hE04F000F;
		ROM[1] = 32'hE2800002;
		ROM[2] = 32'hE3A0A040;
		ROM[3] = 32'hE04F100F;
		ROM[4] = 32'hE15A0001;
		ROM[5] = 32'hA000005;
		ROM[6] = 32'hE2812000;
		ROM[7] = 32'hE0023000;
		ROM[8] = 32'hE7813000;
		ROM[9] = 32'hE5914000;
		ROM[10] = 32'hE2811001;
		ROM[11] = 32'hE8000009;
		ROM[12] = 32'hE2811064;
		
		for (int i = 13; i < 64; i++) begin
		  ROM[i] = 32'h0;
		end
	end
	// Assign the output based on the input address
	assign rd = ROM[a[31:2]]; // word aligned
endmodule