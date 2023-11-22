module DataMemory #(parameter WIDTH = 8)
(
	input logic clk, we,
	input logic [WIDTH-1:0] a, wd,
	output logic [WIDTH-1:0] rd);

	reg [WIDTH-1:0] RAM [63:0];

	initial $readmemb("C:/Users/kevii/OneDrive/Escritorio/GitHub/CE4302-P2-2023-S2/TessiaX64/CPU/Memory/mem.txt", RAM);

	always_ff @(negedge clk) begin
		if (we) begin
			RAM[a[63:2]] <= wd;
			$writememb("C:/Users/kevii/OneDrive/Escritorio/GitHub/CE4302-P2-2023-S2/TessiaX64/CPU/Memory/mem.txt", RAM);
		end
	end
	
	assign rd = RAM[a[63:2]];
			
endmodule