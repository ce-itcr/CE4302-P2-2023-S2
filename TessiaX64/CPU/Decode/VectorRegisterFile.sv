module VectorRegisterFile #(parameter REGSIZE = 15,
									 parameter VECTORSPERREG = 4, 
									 parameter DATAWIDTH = 16, 
									 parameter REGSIZEINT = 4) (
    input logic clk, we3,
	input logic [REGSIZEINT-1:0] ra1, ra2, ra3,
	input logic [VECTORSPERREG-1:0][DATAWIDTH-1:0] wd3,
	output logic [VECTORSPERREG-1:0][DATAWIDTH-1:0] rd1, rd2
);

	logic [VECTORSPERREG-1:0][DATAWIDTH-1:0] vrf[REGSIZE-1:0];
	
	
	always_ff @(posedge clk)
		if (we3) vrf[ra3] <= wd3;
	assign rd1 = vrf[ra1];
	assign rd2 = vrf[ra2];
endmodule
