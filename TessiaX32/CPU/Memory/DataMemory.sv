module DataMemory(input logic clk, we,
						input logic [31:0] a, wd,
						output logic [31:0] rd);

	reg [31:0] RAM [64:0];

	initial $readmemb("C:/Users/kevii/OneDrive/Escritorio/Arqui 2/CE4302-P2-2023-S2/TessiaX32/CPU/Memory/mem.txt", RAM);

	always_ff @(negedge clk) begin
		if (we) begin
			RAM[a[31:2]] <= wd;
			$writememb("C:/Users/kevii/OneDrive/Escritorio/Arqui 2/CE4302-P2-2023-S2/TessiaX32/CPU/Memory/mem.txt", RAM);
		end
	end
	
	assign rd = RAM[a[31:2]];
			
endmodule