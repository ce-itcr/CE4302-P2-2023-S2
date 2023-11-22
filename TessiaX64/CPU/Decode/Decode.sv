module Decode #(parameter WIDTH=8)(
    input logic clk, reset, RegWriteW, MemToRegW,
    input logic [1:0] ImmSrcD,
    input logic [1:0] RegSrcD,
    input logic [4:0] WA3W,
    input logic VectorRegWriteW,
    input logic [WIDTH-1:0] InstructionD, ResultW, PCPlus8D,
    input logic [3:0][15:0] VectorResultW,
    output logic [WIDTH-1:0] RD1, RD2, ExtImmD,
    output logic [3:0][15:0] VectorRD1, VectorRD2,
    output logic [4:0] RA1D, RA2D
);

    // RA1 Multiplexer
    mux2to1 #(5) ra1mux(.d0(InstructionD[51:47]), .d1(5'b11111),
                         .selection(RegSrcD[0]), .result(RA1D));

    // RA2 Multiplexer
    mux2to1 #(5) ra2mux(.d0(InstructionD[4:0]), .d1(InstructionD[46:42]),
                         .selection(RegSrcD[1]), .result(RA2D));

    // Register File
    RegisterFile #(64) RF(.clk(!clk), .we3(RegWriteW), .we31(MemToRegW),
                        .ra1(RA1D), .ra2(RA2D), .ra3(WA3W),
                        .wd3(ResultW), .r31(PCPlus8D),
                        .rd1(RD1), .rd2(RD2));
    // Register File
    VectorRegisterFile VRF(.clk(!clk), .we3(VectorRegWriteW),
                        .ra1(RA1D[3:0]), .ra2(RA2D[3:0]), .ra3(WA3W[3:0]),
                        .wd3(VectorResultW),
                        .rd1(VectorRD1), .rd2(VectorRD2));
    // Extend Immediate
    ExtendImmediate EI(.Instruction(InstructionD[23:0]), 
                        .ImmSrc(ImmSrcD),.ExtImm(ExtImmD));

endmodule
