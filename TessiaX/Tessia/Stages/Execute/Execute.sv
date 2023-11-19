module execute #(parameter WIDTH= 8)(
    input logic clk, reset, ALUSrcE,
    input logic [3:0] ALUControlE,
    input logic [WIDTH-1:0] SrcAE, WriteDataE, ExtImmE,
    output logic [WIDTH-1:0] ALUResultE,
    output logic [3:0] ALUFlags,
    output logic [WIDTH-1:0] SrcBE
);

    

    // Src BE Multiplexer
    mux2to1 #(32) srcbmux(.d0(WriteDataE), .d1(ExtImmE),
                         .selection(ALUSrcE), 
                         .result(SrcBE));

    // ALU
    ALU #(32) alu(.a(SrcAE), .b(SrcBE),
                    .ctrl(ALUControlE),
                    .result(ALUResultE),
                    .flags(ALUFlags));


endmodule
