module ALU_tb;

   // Parameters
    parameter N = 16;

    // Inputs and outputs
    logic signed [N-1:0] a, b;
    logic [3:0] ctrl;
    logic signed [N-1:0] result;
    logic [3:0] flags;

    // Clock and reset
    logic clk = 0;
    initial forever #5 clk = ~clk;

    // Instantiate ALU
    ALU #(N) uut (
        .a(a),
        .b(b),
        .ctrl(ctrl),
        .result(result),
        .flags(flags)
    );

    // Test procedure
    initial begin
        // Test case 1: Addition with positive numbers
        a = 4857;
        b = 7465;
        ctrl = 4'b0000;
        #10;
        $display("Test Case 1 Result: %d, Flags: %b", result, flags);
        assert(result == 12322) else $error("Test Case 1 Failed");
        assert(flags == 4'b0000) else $error("Test Case 1 Flags Failed");

        // Test case 2: Subtraction with positive numbers
        a = 7465;
        b = 4857;
        ctrl = 4'b0001;
        #10;
        $display("Test Case 2 Result: %d, Flags: %b", result, flags);
        assert(result == 2608) else $error("Test Case 2 Failed");
        assert(flags == 4'b0000) else $error("Test Case 2 Flags Failed");

        // Test case 3: Addition with negative numbers
        a = -5;
        b = 2;
        ctrl = 4'b0000;
        #10;
        $display("Test Case 3 Result: %d, Flags: %b", result, flags);
        assert(result == -3) else $error("Test Case 3 Failed");
        assert(flags == 4'b1000) else $error("Test Case 3 Flags Failed");

        // Test case 4: Substraction with negative numbers
        a = -5;
        b = 2;
        ctrl = 4'b0001;
        #10;
        $display("Test Case 4 Result: %d, Flags: %b", result, flags);
        assert(result == -7) else $error("Test Case 4 Failed");
        assert(flags == 4'b1000) else $error("Test Case 4 Flags Failed");

        // Test case 5: Condition for Branch Equal
        a = 10;
        b = 10;
        ctrl = 4'b0001;
        #10;
        $display("Test Case 5 Result: %d, Flags: %b", result, flags);
        assert(result == 0) else $error("Test Case 5 Failed");
        assert(flags == 4'b0100) else $error("Test Case 5 Flags Failed");


        // Test case 6: Condition for Branch Greater Than
        a = 10;
        b = 2;
        ctrl = 4'b0001;
        #10;
        $display("Test Case 6 Result: %d, Flags: %b", result, flags);
        assert(result == 8) else $error("Test Case 6 Failed");
        assert(flags == 4'b0000) else $error("Test Case 6 Flags Failed");

        // Test case 7: Condition for Branch Less Than
        a = 2;
        b = 4;
        ctrl = 4'b0001;
        #10;
        $display("Test Case 7 Result: %d, Flags: %b", result, flags);

        // If all tests pass, execute $finish
        $finish;
    end

endmodule
