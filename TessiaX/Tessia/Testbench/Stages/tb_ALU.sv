`timescale 1ns/1ps

module tb_ALU();

    parameter N = 8;
    logic signed [N-1:0] a, b;
    logic [3:0] ctrl;
    logic signed [N-1:0] result;
    logic [3:0] flags; // {neg, zero, carry, overflow}

    // Instantiate the ALU module
    ALU #(.N(N)) alu_instance (
        .a(a),
        .b(b),
        .ctrl(ctrl),
        .result(result),
        .flags(flags)
    );

    // Test procedure
    initial begin
        // Initialize inputs
        a = 0;
        b = 0;
        ctrl = 0;

        // Test each operation
        for (int i = 0; i < 8; i++) begin
            a = $random % 256;
            b = $random % 256;
            ctrl = i;
            #10; // Wait for 10 time units
            $display("Time: %0t, a: %0d, b: %0d, ctrl: %0b, result: %0d, flags: %0b", $time, a, b, ctrl, result, flags);
        end

        // Finish the simulation
        $finish;
    end

endmodule
