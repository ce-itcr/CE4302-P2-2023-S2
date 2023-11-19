module flopenrc #(parameter WIDTH = 8) (
    input logic clk, reset, en, 
	input logic [WIDTH-1:0] d, 
	output logic [WIDTH-1:0] q
); 
	logic [WIDTH-1:0] out;
	always_ff @(posedge clk) begin
		if (reset) out <= 0;
		else if(en) out <= d;
	end
	assign q = out;	
endmodule
