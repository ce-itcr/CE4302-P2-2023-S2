module WriteBack #(parameter WIDTH=8)(
    input logic MemToRegW,
    input logic [WIDTH-1:0] ReadDataW, ALUOutW,
    output logic [WIDTH-1:0] ResultW
);

    // Mux Mem To Reg
    mux2to1 #(WIDTH) memtoregmux(.d0(ALUOutW), .d1(ReadDataW),
                         .selection(MemToRegW), 
                         .result(ResultW));

endmodule
