module ConditionalUnit(
    input logic clk, reset, PCSrcE,
    RegWriteE, MemWriteE, BranchE, NoWrite,
    input [3:0] CondE, FlagsE,
    output logic PCSrcEout, RegWriteEout, MemWriteEout,
    output logic BranchTakenE
);

    logic CondExE;

	// write controls are conditional
	ConditionCheck cc(CondE, FlagsE, CondExE);

    // Define the Outputs
    assign PCSrcEout = PCSrcE & CondExE;
    assign RegWriteEout = RegWriteE & CondExE & ~NoWrite;
	assign MemWriteEout = MemWriteE & CondExE;
    assign BranchTakenE = BranchE & CondExE;

endmodule
