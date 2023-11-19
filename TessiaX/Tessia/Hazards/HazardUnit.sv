module HazardUnit(
    input logic Match_1E_M,
    input logic Match_1E_W,
    input logic Match_2E_M,
    input logic Match_2E_W,
	input logic Match_12D_E,
    input logic RegWriteM, RegWriteW, MemToRegE,
	input logic PCSrcD, PCSrcE, PCSrcM, PCSrcW,
	input logic BranchTakenE,
    output logic [1:0] ForwardAE, ForwardBE,
	output logic StallF,
	output logic StallD,
	output logic FlushD, FlushE
);

	logic LDRStall;
	logic PCWrPendingF;
	
	always_comb begin
		// Forwarding Logic
		ForwardAE = 2'b00;
		ForwardBE = 2'b00;
        // Check Matches for the destination in Write Back Stage
		if(RegWriteW) begin 
			if (Match_1E_W) begin
				ForwardAE = 2'b01;
			end
			if (Match_2E_W) begin
				ForwardBE = 2'b01;
			end
		end 
		// Check Matches for the destination in Memory Stage
		if(RegWriteM) begin 
			if(Match_1E_M) begin
			    ForwardAE = 2'b10;
			end 
			if (Match_2E_M) begin
			    ForwardBE = 2'b10;
			end
		end 

		// Stalls Logic
		LDRStall = Match_12D_E && MemToRegE;
		PCWrPendingF = PCSrcD || PCSrcE || PCSrcM;

		// StallD = LDRStall;
		// StallF = LDRStall || PCWrPendingF;
		// FlushE = LDRStall || BranchTakenE;
		// FlushD = BranchTakenE || PCWrPendingF || PCSrcW;

		StallD = LDRStall;
		StallF = LDRStall || PCWrPendingF;
		FlushE = LDRStall || BranchTakenE;
		FlushD = BranchTakenE || PCWrPendingF || PCSrcW;

		// StallD = LDRStall;
		// StallF = LDRStall;
		// FlushE = LDRStall || BranchTakenE;
		// FlushD = BranchTakenE;

	end
	
endmodule 