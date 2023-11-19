module DataMemory(
    input logic clk,
    input logic writeEnable,
    input logic [31:0] address,
    input logic [31:0] writeData,
    output logic [31:0] readData
);
    // Define memory size
    localparam int MEM_SIZE = 1024;

    // Internal memory storage
    logic [31:0] memory [0:MEM_SIZE-1];

    // Write operation
    always_ff @(negedge clk) begin
        if (writeEnable)
            memory[address] <= writeData;
    end

    // Read operation
    always_comb begin
        readData = memory[address];
    end
endmodule
