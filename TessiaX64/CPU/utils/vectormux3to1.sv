module vectormux3to1 (
   input logic [1:0] selection,
	input logic [3:0][15:0] d0, d1, d2,
	output logic [3:0][15:0] result
);	
    assign result = selection[1] ? d2 : (selection[0] ? d1 : d0);
	 
endmodule