module Tessia_tb;

  // Define constants

  // Declare signals
  reg clk;
  reg reset;
  wire [31:0] Result, A, B;

  // Instantiate the module
  Tessia uut (
    .clk(clk),
    .reset(reset),
    .Result(Result),
    .A(A),
    .B(B)
  );

  // Initial stimulus
  initial begin
    // Initialize inputs
    reset = 1;
    #1 reset = 0;  // Deassert reset after 20 time units

    // Apply additional inputs or sequences here

    // Monitor and display outputs
    forever begin
      #10;  // Wait for 10 time units before displaying outputs
      $display("Time=%0t | Result=%h | A=%h | B=%h", $time, Result, A, B);

      // Stop simulation after 100 time units
      if ($time >= 1000) begin
        $stop;
      end
    end
  end


	// initialize test
	initial
	begin
		reset <= 1; # 100; reset <= 0;
	end

	integer clk_count = 0;
	always begin
		if (clk_count < 1500) begin
			clk <= 1; #5;
			clk <= 0; #5;
			clk_count = clk_count + 1;
		end else begin
			#1; // Wait for any remaining logic to settle before stopping the clock
			$stop;
		end
	end

	// at end of program
	always @(negedge clk)
	begin
		$display("Tessia {A: %d, B: %d, ALUResult: %d}",A, B, Result);
		$display("\n \n");
	end

  // Add more test scenarios and sequences as needed

endmodule
