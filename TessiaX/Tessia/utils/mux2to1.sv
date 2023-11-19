module mux2to1 #(parameter WIDTH = 8)(
    input logic  [WIDTH-1:0] d0, d1,
    input logic selection,
	output logic [WIDTH-1:0] result
);
	assign result = selection ? d1 : d0;
endmodule
