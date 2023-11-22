module tb_SegmentedMemory;

    // Testbench Variables
    logic clk;
    logic [63:0] address;
    logic [63:0] data_in;
    logic [3:0] [15:0] vect_in;
    logic [3:0] [15:0] vect_out;
    logic [63:0] data_out;
    logic read, write, vect;
    logic valid;

    // Instantiate the SegmentedMemory module
    SegmentedMemory uut(
        .clk(clk),
        .address(address),
        .data_in(data_in),
        .vect_in(vect_in),
        .vect_out(vect_out),
        .data_out(data_out),
        .read(read),
        .write(write),
        .vect(vect),
        .valid(valid)
    );

    // Clock generation
    always #5 clk = ~clk;  // Generate a clock with a period of 10 time units

    // Test Procedure
    initial begin
        // Initialize test variables
        clk = 0;
        address = 0;
        data_in = 0;
        vect = 0;
        read = 0;
        write = 0;
        valid = 0;
        vect_in = 0;

        // Vector write test
        address = 512; // Address within memory0 block
        vect_in = '{16'hAAAA, 16'hBBBB, 16'hCCCC, 16'hDDDD}; // Example vector data
        vect = 1; write = 1; read = 0; // Enable vector write mode
        #10; // Wait one clock cycle
        vect = 0; write = 0; // Disable vector write mode

        // Vector read test
        vect = 1; read = 1; write = 0; // Enable vector read mode
        #10; // Wait one clock cycle
        vect = 0; read = 0; // Disable vector read mode

        // Finish the simulation
        $finish;
    end
	 
  // Testbench Variables
//  logic clk;
//  logic [63:0] test_addr;
//  logic [63:0] test_data_in;
//  logic [63:0] test_data_out;
//  logic read, write;
//  logic valid;
//
//  // Instantiate the SegmentedMemory module
//  SegmentedMemory uut(
//    .clk(clk),
//    .address(test_addr),
//    .data_in(test_data_in),
//    .data_out(test_data_out),
//    .read(read),
//    .write(write),
//    .valid(valid)
//  );
//
//  // Clock generation
//  always #5 clk = ~clk;  // Generate a clock with a period of 10 time units
//
//  // Test Procedure
//  initial begin
//    // Initialize test variables
//    clk = 0;
//    test_addr = 0;
//    test_data_in = 0;
//    read = 0;
//    write = 0;
//    valid = 0;
//
//    // Test sequence
//    // Example: Read from instruction memory
//    test_addr = 512;  // Example address in instruction memory
//    read = 1; write = 0;
//    #10;  // Wait one clock cycle
//    read = 0;

    // Example: Write to data memory
//    test_addr = 512;  // Example address in data memory
//    test_data_in = 64'h123456789ABCDEF0;  // Example data
//    write = 1; read = 0;
//    #10;  // Wait one clock cycle
//    write = 0;

    // Add more test cases as needed

    // Finish the simulation
//    $finish;
//  end

endmodule
