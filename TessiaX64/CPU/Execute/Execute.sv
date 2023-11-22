module Execute #(parameter WIDTH= 8)(
    input logic clk, reset, ALUSrcE,
    input logic [3:0] ALUControlE,
    input logic [WIDTH-1:0] SrcAE, WriteDataE, ExtImmE,
    input logic [3:0][15:0] VectorSrcAE, VectorSrcBE,
	 output logic [3:0][15:0] VectorALUResultE,
    output logic [WIDTH-1:0] ALUResultE,
    output logic [3:0] ALUFlags,
    output logic [WIDTH-1:0] SrcBE
);

    // Src BE Multiplexer
    mux2to1 #(WIDTH) srcbmux(.d0(WriteDataE), .d1(ExtImmE),
                         .selection(ALUSrcE), 
                         .result(SrcBE));

    // ALU
    ALU #(WIDTH) alu(.a(SrcAE), .b(SrcBE),
                    .ctrl(ALUControlE),
                    .result(ALUResultE),
                    .flags(ALUFlags));

    // ALU
    VectorALU aluv(.ra1(VectorSrcAE), .ra2(VectorSrcBE),
                    .ctrl(ALUControlE),
                    .result(VectorALUResultE));

endmodule
