module ExtendImmediate(
    input logic [23:0] Instruction,
	input logic ImmSrc,
	output logic [63:0] ExtImm
);

// It specifies that the block contains only combinational logic and does not contain any latches or memory elements.								
always_comb
	case(ImmSrc)
		// 24-bit unsigned immediate for data processing
		2'b0: ExtImm = {40'b0, Instruction[23:0]};
		
		// 24-bit unsigned immediate for LDR and STR
		2'b1: ExtImm = {40'b0, Instruction[23:0]};
	endcase
endmodule
