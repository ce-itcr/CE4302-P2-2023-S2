module Decode #(parameter WIDTH=8)(
    input logic clk, reset, RegWriteW,
    input logic ImmSrcD,
    input logic [1:0] RegSrcD,
    input logic [4:0] WA3W,
    input logic [WIDTH-1:0] InstructionD, ResultW, PCPlus16D,
    output logic [WIDTH-1:0] RD1, RD2, ExtImmD,
    output logic [4:0] RA1D, RA2D
);

    // RA1 Multiplexer
    mux2to1 #(4) ra1mux(.d0(InstructionD[51:47]), .d1(5'b11111),
                         .selection(RegSrcD[0]), .result(RA1D));

    // RA2 Multiplexer
    mux2to1 #(4) ra2mux(.d0(InstructionD[4:0]), .d1(InstructionD[46:42]),
                         .selection(RegSrcD[1]), .result(RA2D));

    // Register File
    RegisterFile #(64) RF(.clk(!clk), .we3(RegWriteW),
                        .ra1(RA1D), .ra2(RA2D), .ra3(WA3W),
                        .wd3(ResultW), .r31(PCPlus16D),
                        .rd1(RD1), .rd2(RD2));

    // Extend Immediate
    ExtendImmediate EI(.Instruction(InstructionD[23:0]), 
                        .ImmSrc(ImmSrcD),.ExtImm(ExtImmD));

endmodule
