`timescale 1ns/1ps

module tb_adder();

    parameter WIDTH = 8;
    logic [WIDTH-1:0] a, b;
    logic [WIDTH-1:0] result;

    // Instantiate the adder module
    adder #(.WIDTH(WIDTH)) adder_instance (
        .a(a),
        .b(b),
        .result(result)
    );

    // Test procedure
    initial begin
        // Initialize inputs
        a = 0;
        b = 0;

        // Apply random values and observe the result
        repeat (10) begin
            a = $random;
            b = $random;
            #10; // Delay for 10 time units
            $display("Time: %0t, a: %0d, b: %0d, result: %0d", $time, a, b, result);
        end

        // Finish the simulation
        $finish;
    end

endmodule
