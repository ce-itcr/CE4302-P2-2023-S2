module vertical_counter(
	input logic clk_25,
	input logic enable_v_counter,
	output logic [9:0] v_counter);
	
	always@ (posedge clk_25) begin
		if (enable_v_counter == 1'b1) begin
			if (v_counter < 524) v_counter <= v_counter + 1;
			else v_counter <= 0;
		end
	end
endmodule
