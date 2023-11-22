module ControlUnit(
    input logic clk, reset,
    input logic [1:0] Op,
	input logic [1:0] VectorOp, // [41:40]
    input logic [5:0] Funct,
    input logic [4:0] Rd,
    output logic PCSrcD,
	output logic RegWriteD,
	output logic VectorRegWriteD,
	output logic VectorMemWriteD,
    output logic MemToRegD, 
	output logic MemWriteD, 
	output logic BranchD, 
	output logic ALUSrcD, 
	output logic NoWrite,
	output logic [1:0] ImmSrcD,
    output logic [3:0] ALUControlD,
    output logic [1:0] RegSrcD
);
	logic [9:0] controls;
	logic [2:0] vectorControls;
	logic Branch, ALUOp, ALUVectorOp;
	
	// Main Decoder *******************************************************************************
	always_comb
		casex(Op)
            2'b00: 
                // Data-processing immediate
                if (Funct[5]) begin
					 controls = 10'b0000101001;
					 vectorControls = 3'b000;
				end
                // Data-processing register
                else begin 
					controls = 10'b0000001001;
					vectorControls = 3'b000;
				end
            2'b01:
                // LDR
                if (Funct[0]) begin 
					controls = 10'b0001111000;
					vectorControls = 3'b000;
				end
                // STR
                else begin 
					controls = 10'b1001110100;
					vectorControls = 3'b000;
				end
            
            2'b10: 
                // B
					 begin
						controls = 10'b0110100010;
						vectorControls = 3'b000;
					end

            // Vector Data Processing
            2'b11:
			// Vector Data Processing
			if (VectorOp == 2'b00) begin
                controls = 10'b0000000000;
				vectorControls = 3'b011;
			end
			// LDR STR
			else if (VectorOp == 2'b01) begin
				// LDR
				if (Funct[0]) begin
					 vectorControls = 3'b010;
					 controls = 10'b0000100000;
				end
				// STR
				else begin 
					vectorControls = 3'b100;
					controls = 10'b0000100000;
				end
			end
			else begin
				vectorControls = 3'b000;
				controls = 10'b0000000000;
			end
		endcase
		
	assign {RegSrcD, ImmSrcD, ALUSrcD, MemToRegD, RegWriteD, MemWriteD, BranchD, ALUOp} = controls;
	assign {VectorMemWriteD, VectorRegWriteD, ALUVectorOp} = vectorControls;

	// ALU Decoder ***********************************************************************************
	always_comb
		if (ALUOp) begin // which DP Instr?
			case(Funct[4:1])
				4'b0100: ALUControlD = 4'b0000; // ADD
				4'b0010: ALUControlD = 4'b0001; // SUB
				4'b0000: ALUControlD = 4'b0010; // Multiplication
				4'b1100: ALUControlD = 4'b0011; // ORR
				4'b1101: ALUControlD = 4'b0110; // MOV
				4'b1010: ALUControlD = 4'b0001; // CMP
				default: ALUControlD = 4'bx;    // unimplemented
			endcase
		NoWrite = (Funct[4:1] == 4'b1010);
		end

		else if (ALUVectorOp) begin // which Vector DP Instr?
			case(Funct[4:1])
			// Falta ver los codigos
				4'b0100: ALUControlD = 4'b0000; // ADD
				4'b0010: ALUControlD = 4'b0001; // SUB
				4'b0000: ALUControlD = 4'b0010; // Multiplication
				4'b1100: ALUControlD = 4'b0011; // ORR
				4'b1101: ALUControlD = 4'b0110; // MOV
				4'b1010: ALUControlD = 4'b0001; // CMP
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
		assign PCSrcD = ((Rd == 5'b11111) & RegWriteD) | BranchD;

endmodule
