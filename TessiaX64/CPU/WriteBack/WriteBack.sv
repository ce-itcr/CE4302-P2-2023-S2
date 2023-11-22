module WriteBack #(parameter WIDTH=8)(
    input logic MemToRegW,
    input logic VectorMemWriteW,
    input logic [WIDTH-1:0] ReadDataW, ALUOutW,
    output logic [WIDTH-1:0] ResultW,
    output logic [3:0][15:0] VectorReadDataW, VectorALUOutW,
    output logic [3:0][15:0] VectorResultW
);

    // Mux Mem To Reg
    mux2to1 #(WIDTH) memtoregmux(.d0(ALUOutW), .d1(ReadDataW),
                         .selection(MemToRegW), 
                         .result(ResultW));

    // Mux Mem To Reg Vector
    vectormux2to1 Vmemtoregmux(.d0(VectorALUOutW), .d1(VectorReadDataW),
                         .selection(VectorMemWriteW), 
                         .result(VectorResultW));
endmodule
