module VectorALU #(parameter N = 8, REGSIZE = 15, VECTORSPERREG = 4, DATAWIDTH = 16) (
    input logic clk,
    input logic signed [VECTORSPERREG-1:0][DATAWIDTH-1:0] ra1,
    input logic signed [VECTORSPERREG-1:0][DATAWIDTH-1:0] ra2,
    input logic [3:0] ctrl,
    output logic signed [VECTORSPERREG-1:0][DATAWIDTH-1:0] result
);
    logic overflow;
    logic division_by_zero;
    logic signed [VECTORSPERREG-1:0][DATAWIDTH-1:0] temp_result;
    logic division_by_zero_local;

    always_ff @(posedge clk) begin
        case (ctrl)
            4'b0000: // Addition
                for (int i = 0; i < VECTORSPERREG; i++) begin
                    temp_result[i] = ra1[i] + ra2[i];
                end
            4'b0001: // Subtraction
                for (int i = 0; i < VECTORSPERREG; i++) begin
                    temp_result[i] = ra1[i] - ra2[i];
                end
            4'b0010: // Multiplication
                for (int i = 0; i < VECTORSPERREG; i++) begin
                    temp_result[i] = ra1[i] * ra2[i];
                end
            4'b0011: // Copy Imm
                temp_result = ra2;
            4'b0100: // Division
                for (int i = 0; i < VECTORSPERREG; i++) begin
                    if (ra2[i] != 0) begin
                        temp_result[i] = ra1[i] / ra2[i];
                    end else begin
                        temp_result[i] = 0;
                    end
                end
				4'b0101: // Abs, Dir Vectorial
				    for (int i = 0; i < VECTORSPERREG; i++) begin
                     temp_result[3] = ra1[1] - ra1[3];								 
						   temp_result[2] = ra1[0] - ra1[2];
							
							if(temp_result[3][DATAWIDTH-1])
								temp_result[3] = -temp_result[3];
							
							if(temp_result[2][DATAWIDTH-1])
								temp_result[2] = -temp_result[2];
							
							if (ra1[3] < ra1[1])
								 temp_result[1] = 1;
							else
								 temp_result[1] = -1;

							if (ra1[0] < ra1[2])
								 temp_result[0] = 1;
							else
								 temp_result[0] = -1;
							
                end
				4'b0110: // Error
					 for (int i = 0; i < VECTORSPERREG; i++) begin
						  temp_result[3] = ra1[3] - ra1[2];
						  temp_result[2] = 4'b0000;
						  temp_result[1] = 4'b0000;
						  temp_result[0] = 4'b0000;
						  $display("ra1[%0d] = %h", i, ra1[i]); 
					 end
            default: // Default
                temp_result = 0;
        endcase

        // Check for overflow 
        overflow = 0;
        for (int i = 0; i < VECTORSPERREG; i++) begin
            if ((ctrl == 4'b0000 && (ra1[i] > 0 && ra2[i] > 0 && temp_result[i] < 0)) ||
                (ctrl == 4'b0001 && ((ra1[i] > 0 && ra2[i] < 0 && temp_result[i] > 0) || (ra1[i] < 0 && ra2[i] > 0 && temp_result[i] > 0)))) begin
                overflow = 1;
            end
        end

        // Division by zero check
        division_by_zero_local = 0;
        for (int i = 0; i < VECTORSPERREG; i++) begin
            if (ctrl == 4'b0100 && ra2[i] == 0) begin
                division_by_zero_local = 1;
            end
        end
    end

    // Assign local variables to outputs
    assign division_by_zero = division_by_zero_local;
    assign result = temp_result;

endmodule