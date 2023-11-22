module adder #(parameter WIDTH=8)(
    input logic [WIDTH-1:0] a, b,
	output logic [WIDTH-1:0] result
);			
	assign result = a + b;
endmodule
