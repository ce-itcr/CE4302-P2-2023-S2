module ALU #(parameter N = 8) (
    input logic signed [N-1:0] a,
    input logic signed [N-1:0] b,
    input logic [3:0] ctrl,
    output logic signed [N-1:0] result,
    output logic [3:0] flags
	 
);

    logic [N-1:0] temp_result;
	 // Variables
    reg [N-1:0] fdivisor;
    reg divisor_sign, sresult, sremainder;
    
    always_comb begin
        case(ctrl)
            4'b0000: temp_result = a + b;  // Addition
            4'b0001: temp_result = a - b;	 // Subtraction
            4'b0010: temp_result = a * b;  // Multiplication
            4'b0011: temp_result = a | b;  // Logical OR
            4'b0100: temp_result = a % b;  // Modulus
            4'b0101: temp_result = a & b;  // Logical AND
            4'b0110: temp_result = b;      // Copy Imm
            4'b0111: temp_result = a << b; // Logical shift left
				4'b1000: temp_result = a / b; // Division
            default: temp_result = 0;
        endcase
        
		  flags[3:0] = 4'b0000; // No flags set
		  
		  // Flags for division
//		  if(ctrl == 4'b1000 && (a[N-1] == 1'b1)) begin
//                divisor_sign = a[N-1];
//					 fdivisor = divisor_sign ? -a : a;
//					 temp_result = fdivisor/b;
//          end
  
		  // Flags for addition
		  if(ctrl == 4'b0000 && (a[N-1] == b[N-1]) && (a[N-1] != temp_result[N-1])) begin
				flags[1] = 1'b1; // Overflow flag
				flags[0] = 1'b1; // Carry flag
		  end
		  
		  // Flags for substraction
		  if(ctrl == 4'b0001 && (a[N-1] == 1'b1) && (b[N-1] == temp_result[N-1] == 1'b1)) begin
				flags[1] = 1'b1; // Overflow flag
				flags[0] = 1'b1; // Carry flag
		  end
		  
		  // Flags for multiply
		  if(ctrl == 4'b0010 && (a[N-1] == b[N-1]) && (temp_result[N-1] == 1'b1)) begin
				flags[1] = 1'b1; // Overflow flag
				flags[0] = 1'b1; // Carry flag
		  end else 
		  if(ctrl == 4'b0010 && (a[N-1] != b[N-1]) && (temp_result[N-1] == 1'b0)) begin
				flags[1] = 1'b1; // Overflow flag
				flags[0] = 1'b1; // Carry flag
		  end
        
        if(temp_result[N-1] && flags[1]) begin
				flags[3] = 1'b0; 	// Negative flag
		  end else begin
				flags[3] = temp_result[N-1]; 	// Negative flag
		  end
		  flags[2] = ~(|temp_result); 		// Zero flag
		  result = temp_result[N-1:0];
		  
		  //result = decimal;
    end

endmodule
