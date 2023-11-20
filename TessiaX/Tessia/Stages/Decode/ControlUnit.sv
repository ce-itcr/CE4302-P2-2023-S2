module ControlUnit #(parameter WIDTH=8)(
    input logic clk, reset,
    input logic [1:0] Op,
    input logic [5:0] Funct,
    input logic [3:0] Rd,
    output logic PCSrcD, RegWriteD,
    MemToRegD, MemWriteD, BranchD, ALUSrcD, NoWrite,
    output logic [3:0] ALUControlD,
    output logic [1:0] ImmSrcD, RegSrcD
);
	logic [9:0] controls;
	logic Branch, ALUOp;
	
	// Main Decoder *******************************************************************************
	always_comb
		casex(Op)
            2'b00: 
                // Data-processing immediate
                if (Funct[5]) controls = 10'b0000101001;
                // Data-processing register
                else controls = 10'b0000001001;
            
            2'b01:
                // LDR
                if (Funct[0]) controls = 10'b0101111000;
                // STR
                else controls = 10'b1001110100;
            
            2'b10: 
                // B
                controls = 10'b0110100010;
			
			2'b11:
				// Vector processing
				controls = 10'b0000000000;


		endcase
		
	assign {RegSrcD, ImmSrcD, ALUSrcD, MemToRegD, RegWriteD, MemWriteD, BranchD, ALUOp} = controls;

	// ALU Decoder ***********************************************************************************
	always_comb
		if (ALUOp) begin // which Data Processing Instruction?
			case(Funct[4:1])
				4'b0000: ALUControlD = 4'b0000; // Addition
				4'b0001: ALUControlD = 4'b0001; // Substraction
				4'b0010: ALUControlD = 4'b0010; // Multiplication
				4'b0011: ALUControlD = 4'b0000; // Logical OR
				4'b0100: ALUControlD = 4'b0000; // Modulus
				4'b0101: ALUControlD = 4'b0000; // Logical AND
				4'b0110: ALUControlD = 4'b0110; // Move
				4'b0111: ALUControlD = 4'b0111; // Divition
				4'b1000: ALUControlD = 4'b0001; // Compare Ra Rb
				default: ALUControlD = 4'bx;    // unimplemented
			endcase
			
			NoWrite = (Funct[4:1] == 4'b1010);
        end 
        else begin
			// add or sub for non-DP instructions
			ALUControlD = Funct[5] ? 4'b0000 : 4'b0001;
			NoWrite = 1'b0;
		end
		
		// PC Logic *****************************************************************
		assign PCSrcD = ((Rd == 4'b1111) & RegWriteD) | BranchD;

endmodule
