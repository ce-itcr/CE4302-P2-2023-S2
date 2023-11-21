module Decode #(parameter WIDTH=8)(
    input logic clk, reset, RegWriteW,
    input logic [1:0] RegSrcD, ImmSrcD,
    input logic [3:0] WA3W,
    input logic [WIDTH-1:0] InstructionD, ResultW, PCPlus8D,
    output logic [WIDTH-1:0] RD1, RD2, ExtImmD,
    output logic [3:0] RA1D, RA2D
);

    // RA1 Multiplexer
    mux2to1 #(4) ra1mux(.d0(InstructionD[19:16]), .d1(4'b1111),
                         .selection(RegSrcD[0]), .result(RA1D));

    // RA2 Multiplexer
    mux2to1 #(4) ra2mux(.d0(InstructionD[3:0]), .d1(InstructionD[15:12]),
                         .selection(RegSrcD[1]), .result(RA2D));

    // Register File
    RegisterFile RF(.clk(!clk), .we3(RegWriteW),
                        .ra1(RA1D), .ra2(RA2D), .ra3(WA3W),
                        .wd3(ResultW), .r15(PCPlus8D),
                        .rd1(RD1), .rd2(RD2));

    // Extend Immediate
    ExtendImmediate EI(.Instruction(InstructionD[23:0]), 
                        .ImmSrc(ImmSrcD),.ExtImm(ExtImmD));

endmodule