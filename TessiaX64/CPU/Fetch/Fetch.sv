module Fetch #(parameter WIDTH= 8)(
    input logic clk, reset, PCSrcW, enablePCFlipFlop,
    input logic BranchTakenE,
    input logic [WIDTH-1:0] ResultW, ALUResultE,
    output logic [WIDTH-1:0] PCF, PCPlus4F
);
    logic [WIDTH-1:0] PrePCNext, PCNext;

    // Pre Next PC Multiplexer
    mux2to1 #(WIDTH) prepcmux(.d0(PCPlus4F), .d1(ResultW),
                         .selection(PCSrcW), .result(PrePCNext));

    // Next PC Multiplexer
    mux2to1 #(WIDTH) pcmux(.d0(PrePCNext), .d1(ALUResultE),
                         .selection(BranchTakenE), .result(PCNext));

    flopenrc #(WIDTH) pcregister(
        .clk(clk), 
        .reset(reset), 
        .en(enablePCFlipFlop), 
        .d(PCNext), 
        .q(PCF));

    // (PC + 8) Adder
    adder #(WIDTH) pcadd1(.a(PCF), .b(64'd4), .result(PCPlus4F));

endmodule