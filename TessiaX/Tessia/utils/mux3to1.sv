module mux3to1 #(parameter WIDTH = 8)(
    input logic  [WIDTH-1:0] d0, d1, d2,
    input logic [1:0] selection,
	output logic [WIDTH-1:0] result
);
    assign result = selection[1] ? d2 : (selection[0] ? d1 : d0);
endmodule
