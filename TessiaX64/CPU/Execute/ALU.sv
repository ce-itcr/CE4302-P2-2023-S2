module ALU #(parameter N = 8) (
    input logic signed [N-1:0] a,
    input logic signed [N-1:0] b,
    input logic [3:0] ctrl,
    output logic signed [N-1:0] result,
    output logic [3:0] flags // {neg, zero, carry, overflow} = flags;
);

    logic signed [N-1:0] temp_result;

    always_comb begin
        case (ctrl)
            4'b0000: temp_result = a + b;  // Addition
            4'b0001: temp_result = a - b;  // Subtraction
            4'b0010: temp_result = a * b;  // Multiplication
            4'b0011: temp_result = a | b;  // Logical OR
            4'b0100: temp_result = a % b;  // Modulus
            4'b0101: temp_result = a & b;  // Logical AND
            4'b0110: temp_result = b;      // Copy Imm
            4'b0111: temp_result = a / b;  // Division
            default: temp_result = 0;
        endcase

        // Set flags
        flags[3] = (temp_result < 0);         // neg
        flags[2] = (temp_result == 0);        // zero
        flags[1] = (ctrl == 4'b0000) && ((a + b) < a);  // carry for addition
        flags[0] = (ctrl == 4'b0001) && ((a - b) > a);  // overflow for subtraction
    end

    assign result = temp_result;

endmodule
