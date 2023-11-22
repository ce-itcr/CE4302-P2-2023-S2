module vectormux2to1 (
   input logic selection,
	input logic [3:0][15:0] d0, d1,
	output logic [3:0][15:0] result
);	
	assign result = selection ? d1 : d0;

endmodule