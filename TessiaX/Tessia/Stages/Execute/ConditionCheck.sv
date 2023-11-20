module ConditionCheck(
    input logic [3:0] Cond, Flags,
	output logic CondEx
);
					  
	logic neg, zero, carry, overflow, ge;
	assign {neg, zero, carry, overflow} = Flags;
	assign ge = (neg == overflow);
	
	always_comb
		case(Cond)
			4'b0000: CondEx = zero; // EQ
			4'b0001: CondEx = ~zero; // NE
			4'b0010: CondEx = ge; // GE
			4'b0011: CondEx = ~ge; // LT
			4'b0100: CondEx = ~zero & ge; // GT
			4'b0101: CondEx = ~(~zero & ge); // LE
			4'b0110: CondEx = 1'b1; // Always 
			default: CondEx = 1'bx; // undefined
		endcase
endmodule
