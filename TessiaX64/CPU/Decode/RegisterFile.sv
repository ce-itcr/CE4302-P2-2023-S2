module RegisterFile #(parameter WIDTH = 8)
(
    input logic clk, we3,
	input logic [4:0] ra1, ra2, ra3,
	input logic [WIDTH-1:0] wd3, r31,
	output logic [WIDTH-1:0] rd1, rd2
);
	// Declare 31 64-bit registers array
	logic [WIDTH-1:0] rf[30:0]
	
	// Three ported Register File
	// Read two ports combinationally
	// Write third port on rising edge of clock
	// Register 31 reads PC+16 instead
	
	always_ff @(posedge clk)
		if (we3) rf[ra3] <= wd3;
	assign rd1 = (ra1 == 5'b11111) ? r31 : rf[ra1];
	assign rd2 = (ra2 == 5'b11111) ? r31 : rf[ra2];
endmodule
