module horizontal_counter(
	input logic clk_25,
	output logic enable_v_counter = 0,
	output logic [9:0] h_counter);
	
	always@ (posedge clk_25) begin
		if (h_counter < 799) begin
			h_counter <= h_counter + 1;
			enable_v_counter <= 0;
		end
		else begin
			h_counter <= 0;
			enable_v_counter <= 1;
		end
	end
endmodule
