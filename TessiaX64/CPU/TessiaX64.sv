module TessiaX64(
    input logic clk, reset,
    output logic [31:0] DataToWriteIntoMemory,
    output logic [3:0] RegisterToWrite,
    output logic [31:0] DataToWriteIntoRegister,
    output logic [31:0] AddressToWriteIntoMemory,
    output logic EnableRegisterWrite,
    output logic EnbaleMemoryWrite
);

    logic [63:0] InstructionF, InstructionD, ReadData;
    logic [63:0] ResultW;
    logic PCSrcW;
    logic [63:0] PCPlus8;
    logic [3:0] ALUFlags;
    logic [63:0] PCF;
    logic RegWriteW;
    logic [1:0] RegSrcD;
    logic [4:0] WA3W;
    logic [63:0] RD1, RD2, ExtImmD;
    logic PCSrcD, RegWriteD, MemToRegD, MemWriteD;
    logic BranchD, ALUSrcD, NoWriteD;
    logic [3:0] ALUControlD;
    logic ImmSrcD;
    logic [3:0] Flags;
    logic PCSrcE, RegWriteE, MemToRegE, MemWriteE;
    logic BranchE, ALUSrcE, NoWriteE;
    logic [3:0] ALUControlE, 
    logic [4:0] WA3E;
    logic [3:0] FlagsE, CondE;
    logic [63:0] RD1E, RD2E;
    logic [4:0] RA1D, RA2D, RA1E, RA2E;
    logic [63:0] SrcAE, WriteDataE, ExtImmE;
    logic PCSrcEout, RegWriteEout, MemWriteEout;
    logic PCSrcM, RegWriteM, MemWriteM, MemToRegM;
    logic [63:0] ALUOutM, WriteDataM, ReadDataM;
    logic [63:0] ALUResultE;
    logic [3:0] WA3M;

    // Assigments for the TessiaX32 outputs *********************************************
    assign DataToWriteIntoMemory = WriteDataM;
    assign RegisterToWrite = WA3W;
    assign EnableRegisterWrite = RegWriteW;
    assign EnbaleMemoryWrite = MemWriteM;
    assign DataToWriteIntoRegister = ResultW;
    assign AddressToWriteIntoMemory = ALUOutM;
    // Assigments for the TessiaX32 outputs *********************************************

    logic MemToRegW;
    logic [31:0] ReadDataW, ALUOutW;
    logic [1:0] ForwardAE, ForwardBE;
    logic StallF, StallD, FlushD, FlushE;
    logic BranchTakenE;

    //***************************** FETCH STAGE ***********************************
    InstructionMemory imem(
        .a(PCF), 
        .rd(InstructionF)
    );

    Fetch #(32) FetchStage(
        .clk(clk), 
        .reset(reset),
        .PCSrcW(PCSrcW),
        .enablePCFlipFlop(!StallF), 
        .ResultW(ResultW),
        .ALUResultE(ALUResultE),
        .PCF(PCF), 
        .PCPlus8F(PCPlus8),
        .BranchTakenE(BranchTakenE)
    );

    flopenrc #(32) FetchDecodeFlipFlop(
        .clk(clk), 
        .reset(FlushD), 
        .en(!StallD), 
        .d({InstructionF}), 
        .q(InstructionD)
    );

    //***************************** DECODE STAGE ***********************************
    ControlUnit #(32) controlunit(
        .clk(clk), 
        .reset(reset), 
        .Op(InstructionD[59:58]),
        .Funct(InstructionD[57:52]),
        .Rd(InstructionD[46:42]),
        .PCSrcD(PCSrcD), 
        .RegWriteD(RegWriteD),
        .MemToRegD(MemToRegD), 
        .MemWriteD(MemWriteD), 
        .BranchD(BranchD), 
        .ALUSrcD(ALUSrcD), 
        .NoWrite(NoWriteD),
        .ALUControlD(ALUControlD),
        .ImmSrcD(ImmSrcD), 
        .RegSrcD(RegSrcD)
    );

    Decode #(32) DecodeStage(
        .clk(clk), 
        .reset(reset), 
        .RegWriteW(RegWriteW),
        .RegSrcD(RegSrcD), 
        .ImmSrcD(ImmSrcD),
        .WA3W(WA3W), 
        .InstructionD(InstructionD), 
        .ResultW(ResultW), 
        .PCPlus16D(PCPlus8),
        .RD1(RD1), 
        .RD2(RD2), 
        .ExtImmD(ExtImmD),
        .RA1D(RA1D), 
        .RA2D(RA2D)
    );

    // Decode - Execute Flip Flop
    flopenrc #(127) DecodeExecuteFlipFlop(
        .clk(clk), 
        .reset(FlushE), 
        .en(1'b1), 
        .d({
            PCSrcD,
            RegWriteD,
            MemToRegD,
            MemWriteD,
            ALUControlD,
            BranchD,
            ALUSrcD,
            NoWriteD,
            InstructionD[63:60],
            ALUControlE == 4'b0001 ? ALUFlags : 4'b0000,
            RD1,
            RD2,
            InstructionD[46:42],
            ExtImmD,
            RA1D,
            RA2D
            }), 
        .q({
            PCSrcE,
            RegWriteE,
            MemToRegE,
            MemWriteE,
            ALUControlE,
            BranchE,
            ALUSrcE,
            NoWriteE,
            CondE,
            FlagsE,
            RD1E,
            RD2E,
            WA3E,
            ExtImmE,
            RA1E,
            RA2E
            }));

    //***************************** EXECUTE STAGE ***********************************
    ConditionalUnit CondUnit(
        .clk(clk), 
        .reset(reset), 
        .PCSrcE(PCSrcE),
        .RegWriteE(RegWriteE), 
        .MemWriteE(MemWriteE), 
        .BranchE(BranchE),
        .NoWrite(NoWriteE),
        .CondE(CondE), 
        .FlagsE(FlagsE), 
        .PCSrcEout(PCSrcEout), 
        .RegWriteEout(RegWriteEout), 
        .MemWriteEout(MemWriteEout),
        .BranchTakenE(BranchTakenE));

    // Forwading Multiplexer for SrcAE
    mux3to1 #(64) forwmulA(
        .d0(RD1E), 
        .d1(ResultW),
        .d2(ALUOutM),
        .selection(ForwardAE), 
        .result(SrcAE)
    );

    // Forwading Multiplexer for Write Data E
    mux3to1 #(64) forwmulB(
        .d0(RD2E), 
        .d1(ResultW),
        .d2(ALUOutM),
        .selection(ForwardBE), 
        .result(WriteDataE)
    );

    HazardUnit hazards(
        .Match_1E_M(RA1E == WA3M ? 1'b1 : 1'b0),
        .Match_1E_W(RA1E == WA3W ? 1'b1 : 1'b0),
        .Match_2E_M(RA2E == WA3M ? 1'b1 : 1'b0),
        .Match_2E_W(RA2E == WA3W ? 1'b1 : 1'b0),
        .Match_12D_E((RA1D == WA3E) || (RA2D == WA3E)),
        .RegWriteM(RegWriteM), 
        .RegWriteW(RegWriteW),
        .PCSrcD(PCSrcD),
        .PCSrcE(PCSrcE),
        .PCSrcM(PCSrcM),
        .PCSrcW(PCSrcW),
        .BranchTakenE(BranchTakenE),
        .ForwardAE(ForwardAE), 
        .ForwardBE(ForwardBE),
        .MemToRegE(MemToRegE),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD),
        .FlushE(FlushE)
    );

    Execute #(64) ExecuteStage(
        .clk(clk), 
        .reset(reset), 
        .ALUSrcE(ALUSrcE),
        .ALUControlE(ALUControlE),
        .SrcAE(SrcAE),
        .WriteDataE(WriteDataE), 
        .ExtImmE(ExtImmE),
        .ALUResultE(ALUResultE),
        .ALUFlags(ALUFlags)
    );

    flopenrc #(72) ExecuteMemoryFlipFlop(
        .clk(clk), 
        .reset(reset), 
        .en(1'b1), 
        .d({
            PCSrcEout,
            RegWriteEout,
            MemToRegE,
            MemWriteEout,
            ALUResultE,
            WriteDataE,
            WA3E
            }), 
        .q({
            PCSrcM,
            RegWriteM,
            MemToRegM,
            MemWriteM,
            ALUOutM,
            WriteDataM,
            WA3M
            }));

    //***************************** MEMORY STAGE ***********************************
    DataMemory #(64) dmem(
        .clk(clk), 
        .we(MemWriteM),
        .a(ALUOutM), 
        .wd(WriteDataM),
        .rd(ReadDataM)
    );

    flopenrc #(71) MemoryWriteBackFlipFlop(
        .clk(clk), 
        .reset(reset), 
        .en(1'b1), 
        .d({
            PCSrcM,
            RegWriteM,
            MemToRegM,
            ReadDataM,
            ALUOutM,
            WA3M
            }), 
        .q({
            PCSrcW,
            RegWriteW,
            MemToRegW,
            ReadDataW,
            ALUOutW,
            WA3W
            })
    );

    //***************************** WRITE BACK STAGE ***********************************
    WriteBack #(32) writeback(
        .MemToRegW(MemToRegW),
        .ReadDataW(ReadDataW), 
        .ALUOutW(ALUOutW),
        .ResultW(ResultW)
    );

endmodule