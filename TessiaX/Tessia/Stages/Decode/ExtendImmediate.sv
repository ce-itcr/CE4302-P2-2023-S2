module ExtendImmediate(
    input logic [23:0] Instruction,
	input logic [1:0] ImmSrc,
	output logic [31:0] ExtImm
);

// It specifies that the block contains only combinational logic and does not contain any latches or memory elements.								
always_comb
	case(ImmSrc)
		// 8-bit unsigned immediate for data processing
		2'b00: ExtImm = {24'b0, Instruction[7:0]};
		
		// 12-bit unsigned immediate for LDR and STR
		2'b01: ExtImm = {20'b0, Instruction[11:0]};
		
		// 24-bit two's complement shifted branch
		2'b10: ExtImm = {{6{Instruction[23]}}, Instruction[23:0], 2'b00};
		
		default: ExtImm = 32'bx; // Undefined
	endcase
endmodule
