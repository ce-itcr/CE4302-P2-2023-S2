module SegmentedMemory(
	 input logic clk,
    input logic [63:0] address,
    input logic [63:0] data_in,
    output logic [63:0] data_out,
    input logic read, write,
    output logic valid
);

		// Example memory size
		localparam MEM_SIZE = 512; //307712;
		localparam INSTR_START = 0;
		localparam INSTR_END = 511;   // Assuming first half for instructions
		localparam DATA_START = 512; 
		localparam BLOQ_DATA_0_START = 512; // 10240 bloks 
		localparam BLOQ_DATA_0_END = 10751;
		localparam BLOQ_DATA_1_START = 10752; // 10240 bloks 
		localparam BLOQ_DATA_1_END = 20991;
		localparam BLOQ_DATA_2_START = 20992; // 10240 bloks 
		localparam BLOQ_DATA_2_END = 31231;
		localparam BLOQ_DATA_3_START = 31232; // 10240 bloks 
		localparam BLOQ_DATA_3_END = 41471;
		localparam BLOQ_DATA_4_START = 41472; // 10240 bloks 
		localparam BLOQ_DATA_4_END = 51711;
		localparam BLOQ_DATA_5_START = 51712; // 10240 bloks 
		localparam BLOQ_DATA_5_END = 61951;
		localparam BLOQ_DATA_6_START = 61952; // 10240 bloks 
		localparam BLOQ_DATA_6_END = 72191;
		localparam BLOQ_DATA_7_START = 72192; // 10240 bloks 
		localparam BLOQ_DATA_7_END = 82431;
		localparam BLOQ_DATA_8_START = 82432; // 10240 bloks 
		localparam BLOQ_DATA_8_END = 92671;
		localparam BLOQ_DATA_9_START = 92672; // 10240 bloks 
		localparam BLOQ_DATA_9_END = 102911;
		localparam BLOQ_DATA_10_START = 102912; // 10240 bloks 
		localparam BLOQ_DATA_10_END = 113151; 

		localparam BLOQ_DATA_11_START = 113152;
		localparam BLOQ_DATA_11_END = 123391;
		localparam BLOQ_DATA_12_START = 123392;
		localparam BLOQ_DATA_12_END = 133631;
		localparam BLOQ_DATA_13_START = 133632;
		localparam BLOQ_DATA_13_END = 143871;
		localparam BLOQ_DATA_14_START = 143872;
		localparam BLOQ_DATA_14_END = 154111;
		localparam BLOQ_DATA_15_START = 154112;
		localparam BLOQ_DATA_15_END = 164351;
		localparam BLOQ_DATA_16_START = 164352;
		localparam BLOQ_DATA_16_END = 174591;
		localparam BLOQ_DATA_17_START = 174592;
		localparam BLOQ_DATA_17_END = 184831;
		localparam BLOQ_DATA_18_START = 184832;
		localparam BLOQ_DATA_18_END = 195071;
		localparam BLOQ_DATA_19_START = 195072;
		localparam BLOQ_DATA_19_END = 205311;
		localparam BLOQ_DATA_20_START = 205312;
		localparam BLOQ_DATA_20_END = 215551;
		localparam BLOQ_DATA_21_START = 215552;
		localparam BLOQ_DATA_21_END = 225791;
		localparam BLOQ_DATA_22_START = 225792;
		localparam BLOQ_DATA_22_END = 236031;
		localparam BLOQ_DATA_23_START = 236032;
		localparam BLOQ_DATA_23_END = 246271;
		localparam BLOQ_DATA_24_START = 246272;
		localparam BLOQ_DATA_24_END = 256511;
		localparam BLOQ_DATA_25_START = 256512;
		localparam BLOQ_DATA_25_END = 266751;
		localparam BLOQ_DATA_26_START = 266752;
		localparam BLOQ_DATA_26_END = 276991;
		localparam BLOQ_DATA_27_START = 276992;
		localparam BLOQ_DATA_27_END = 287231;
		localparam BLOQ_DATA_28_START = 287232;
		localparam BLOQ_DATA_28_END = 297471;
		localparam BLOQ_DATA_29_START = 297472;
		localparam BLOQ_DATA_29_END = 307711; 
		
		localparam BLOQ_PROGRAM_START = 307712;
		localparam BLOQ_PROGRAM_END = 317951;

		
		
		localparam BLOCK_SIZE = 10240; 
		localparam DATA_END = MEM_SIZE - 1;

		// Memory array
		logic [63:0] memory [MEM_SIZE-1:0];
		logic [63:0] memory0 [BLOQ_DATA_0_END:BLOQ_DATA_0_START];
		logic [63:0] memory1 [BLOQ_DATA_1_END:BLOQ_DATA_1_START];
		logic [63:0] memory2 [BLOQ_DATA_2_END:BLOQ_DATA_2_START];
		logic [63:0] memory3 [BLOQ_DATA_3_END:BLOQ_DATA_3_START];
		logic [63:0] memory4 [BLOQ_DATA_4_END:BLOQ_DATA_4_START];
		logic [63:0] memory5 [BLOQ_DATA_5_END:BLOQ_DATA_5_START];
		logic [63:0] memory6 [BLOQ_DATA_6_END:BLOQ_DATA_6_START];
		logic [63:0] memory7 [BLOQ_DATA_7_END:BLOQ_DATA_7_START];
		logic [63:0] memory8 [BLOQ_DATA_8_END:BLOQ_DATA_8_START];
		logic [63:0] memory9 [BLOQ_DATA_9_END:BLOQ_DATA_9_START];
		logic [63:0] memory10 [BLOQ_DATA_10_END:BLOQ_DATA_10_START];
		logic [63:0] memory11 [BLOQ_DATA_11_END:BLOQ_DATA_11_START];
		logic [63:0] memory12 [BLOQ_DATA_12_END:BLOQ_DATA_12_START];
		logic [63:0] memory13 [BLOQ_DATA_13_END:BLOQ_DATA_13_START];
		logic [63:0] memory14 [BLOQ_DATA_14_END:BLOQ_DATA_14_START];
		logic [63:0] memory15 [BLOQ_DATA_15_END:BLOQ_DATA_15_START];
		logic [63:0] memory16 [BLOQ_DATA_16_END:BLOQ_DATA_16_START];
		logic [63:0] memory17 [BLOQ_DATA_17_END:BLOQ_DATA_17_START];
		logic [63:0] memory18 [BLOQ_DATA_18_END:BLOQ_DATA_18_START];
		logic [63:0] memory19 [BLOQ_DATA_19_END:BLOQ_DATA_19_START];
		logic [63:0] memory20 [BLOQ_DATA_20_END:BLOQ_DATA_20_START];
		logic [63:0] memory21 [BLOQ_DATA_21_END:BLOQ_DATA_21_START];
		logic [63:0] memory22 [BLOQ_DATA_22_END:BLOQ_DATA_22_START];
		logic [63:0] memory23 [BLOQ_DATA_23_END:BLOQ_DATA_23_START];
		logic [63:0] memory24 [BLOQ_DATA_24_END:BLOQ_DATA_24_START];
		logic [63:0] memory25 [BLOQ_DATA_25_END:BLOQ_DATA_25_START];
		logic [63:0] memory26 [BLOQ_DATA_26_END:BLOQ_DATA_26_START];
		logic [63:0] memory27 [BLOQ_DATA_27_END:BLOQ_DATA_27_START];
		logic [63:0] memory28 [BLOQ_DATA_28_END:BLOQ_DATA_28_START];
		logic [63:0] memory29 [BLOQ_DATA_29_END:BLOQ_DATA_29_START];
		logic [63:0] memoryProgram [BLOQ_PROGRAM_START:BLOQ_PROGRAM_END];
		

		// Control logic
		always_ff @(negedge clk) begin
			valid = 0;
			data_out = 64'd0;

//			data_out = memory[address];
			valid = 1;

			if (address >= INSTR_START && address <= INSTR_END) begin // Instruction memory space
				if (read) begin
					data_out = memory[address];
					valid = 1;
				end

			end
			else if (address >= BLOQ_DATA_0_START && address <= BLOQ_DATA_0_END) begin // Data memory space
            if (read) begin
                data_out = memory0[address];
                valid = 1;
            end
            if (write) begin
                memory0[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test0.txt", memory0, BLOQ_DATA_0_START, BLOQ_DATA_0_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_1_START && address <= BLOQ_DATA_1_END) begin // Data memory space
            if (read) begin
                data_out = memory1[address];
                valid = 1;
            end
            if (write) begin
                memory1[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test1.txt", memory1, BLOQ_DATA_1_START, BLOQ_DATA_1_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_2_START && address <= BLOQ_DATA_2_END) begin // Data memory space
            if (read) begin
                data_out = memory2[address];
                valid = 1;
            end
            if (write) begin
                memory2[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test2.txt", memory2, BLOQ_DATA_2_START, BLOQ_DATA_2_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_3_START && address <= BLOQ_DATA_3_END) begin // Data memory space
            if (read) begin
                data_out = memory3[address];
                valid = 1;
            end
            if (write) begin
                memory3[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test3.txt", memory3, BLOQ_DATA_3_START, BLOQ_DATA_3_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_4_START && address <= BLOQ_DATA_4_END) begin // Data memory space
            if (read) begin
                data_out = memory4[address];
                valid = 1;
            end
            if (write) begin
                memory4[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test4.txt", memory4, BLOQ_DATA_4_START, BLOQ_DATA_4_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_5_START && address <= BLOQ_DATA_5_END) begin // Data memory space
            if (read) begin
                data_out = memory5[address];
                valid = 1;
            end
            if (write) begin
                memory5[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test5.txt", memory5, BLOQ_DATA_5_START, BLOQ_DATA_5_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_6_START && address <= BLOQ_DATA_6_END) begin // Data memory space
            if (read) begin
                data_out = memory6[address];
                valid = 1;
            end
            if (write) begin
                memory6[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test6.txt", memory6, BLOQ_DATA_6_START, BLOQ_DATA_6_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_7_START && address <= BLOQ_DATA_7_END) begin // Data memory space
            if (read) begin
                data_out = memory7[address];
                valid = 1;
            end
            if (write) begin
                memory7[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test7.txt", memory7, BLOQ_DATA_7_START, BLOQ_DATA_7_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_8_START && address <= BLOQ_DATA_8_END) begin // Data memory space
            if (read) begin
                data_out = memory8[address];
                valid = 1;
            end
            if (write) begin
                memory8[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test8.txt", memory8, BLOQ_DATA_8_START, BLOQ_DATA_8_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_9_START && address <= BLOQ_DATA_9_END) begin // Data memory space
            if (read) begin
                data_out = memory9[address];
                valid = 1;
            end
            if (write) begin
                memory9[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test9.txt", memory9, BLOQ_DATA_9_START, BLOQ_DATA_9_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_10_START && address <= BLOQ_DATA_10_END) begin // Data memory space
            if (read) begin
                data_out = memory10[address];
                valid = 1;
            end
            if (write) begin
                memory10[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test10.txt", memory10, BLOQ_DATA_10_START, BLOQ_DATA_10_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_11_START && address <= BLOQ_DATA_11_END) begin // Data memory space
            if (read) begin
                data_out = memory11[address];
                valid = 1;
            end
            if (write) begin
                memory11[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test11.txt", memory11, BLOQ_DATA_11_START, BLOQ_DATA_11_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_12_START && address <= BLOQ_DATA_12_END) begin // Data memory space
            if (read) begin
                data_out = memory12[address];
                valid = 1;
            end
            if (write) begin
                memory12[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test12.txt", memory12, BLOQ_DATA_12_START, BLOQ_DATA_12_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_13_START && address <= BLOQ_DATA_13_END) begin // Data memory space
            if (read) begin
                data_out = memory13[address];
                valid = 1;
            end
            if (write) begin
                memory13[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test13.txt", memory13, BLOQ_DATA_13_START, BLOQ_DATA_13_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_14_START && address <= BLOQ_DATA_14_END) begin // Data memory space
            if (read) begin
                data_out = memory14[address];
                valid = 1;
            end
            if (write) begin
                memory14[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test14.txt", memory14, BLOQ_DATA_14_START, BLOQ_DATA_14_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_15_START && address <= BLOQ_DATA_15_END) begin // Data memory space
            if (read) begin
                data_out = memory15[address];
                valid = 1;
            end
            if (write) begin
                memory15[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test15.txt", memory15, BLOQ_DATA_15_START, BLOQ_DATA_15_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_16_START && address <= BLOQ_DATA_16_END) begin // Data memory space
            if (read) begin
                data_out = memory16[address];
                valid = 1;
            end
            if (write) begin
                memory16[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test16.txt", memory16, BLOQ_DATA_16_START, BLOQ_DATA_16_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_17_START && address <= BLOQ_DATA_17_END) begin // Data memory space
            if (read) begin
                data_out = memory17[address];
                valid = 1;
            end
            if (write) begin
                memory17[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test17.txt", memory17, BLOQ_DATA_17_START, BLOQ_DATA_17_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_18_START && address <= BLOQ_DATA_18_END) begin // Data memory space
            if (read) begin
                data_out = memory18[address];
                valid = 1;
            end
            if (write) begin
                memory18[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test18.txt", memory18, BLOQ_DATA_18_START, BLOQ_DATA_18_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_19_START && address <= BLOQ_DATA_19_END) begin // Data memory space
            if (read) begin
                data_out = memory19[address];
                valid = 1;
            end
            if (write) begin
                memory19[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test19.txt", memory19, BLOQ_DATA_19_START, BLOQ_DATA_19_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_20_START && address <= BLOQ_DATA_20_END) begin // Data memory space
            if (read) begin
                data_out = memory20[address];
                valid = 1;
            end
            if (write) begin
                memory20[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test20.txt", memory20, BLOQ_DATA_20_START, BLOQ_DATA_20_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_21_START && address <= BLOQ_DATA_21_END) begin // Data memory space
            if (read) begin
                data_out = memory21[address];
                valid = 1;
            end
            if (write) begin
                memory21[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test21.txt", memory21, BLOQ_DATA_21_START, BLOQ_DATA_21_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_22_START && address <= BLOQ_DATA_22_END) begin // Data memory space
            if (read) begin
                data_out = memory22[address];
                valid = 1;
            end
            if (write) begin
                memory22[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test22.txt", memory22, BLOQ_DATA_22_START, BLOQ_DATA_22_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_23_START && address <= BLOQ_DATA_23_END) begin // Data memory space
            if (read) begin
                data_out = memory23[address];
                valid = 1;
            end
            if (write) begin
                memory23[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test23.txt", memory23, BLOQ_DATA_23_START, BLOQ_DATA_23_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_24_START && address <= BLOQ_DATA_24_END) begin // Data memory space
            if (read) begin
                data_out = memory24[address];
                valid = 1;
            end
            if (write) begin
                memory24[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test24.txt", memory24, BLOQ_DATA_24_START, BLOQ_DATA_24_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_25_START && address <= BLOQ_DATA_25_END) begin // Data memory space
            if (read) begin
                data_out = memory25[address];
                valid = 1;
            end
            if (write) begin
                memory25[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test25.txt", memory25, BLOQ_DATA_25_START, BLOQ_DATA_25_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_26_START && address <= BLOQ_DATA_26_END) begin // Data memory space
            if (read) begin
                data_out = memory26[address];
                valid = 1;
            end
            if (write) begin
                memory26[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test26.txt", memory26, BLOQ_DATA_26_START, BLOQ_DATA_26_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_27_START && address <= BLOQ_DATA_27_END) begin // Data memory space
            if (read) begin
                data_out = memory27[address];
                valid = 1;
            end
            if (write) begin
                memory27[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test27.txt", memory27, BLOQ_DATA_27_START, BLOQ_DATA_27_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_28_START && address <= BLOQ_DATA_28_END) begin // Data memory space
            if (read) begin
                data_out = memory28[address];
                valid = 1;
            end
            if (write) begin
                memory28[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test28.txt", memory28, BLOQ_DATA_28_START, BLOQ_DATA_28_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_DATA_29_START && address <= BLOQ_DATA_29_END) begin // Data memory space
            if (read) begin
                data_out = memory29[address];
                valid = 1;
            end
            if (write) begin
                memory29[address] = data_in;
					 $writememb("ImagesTxt/BN_Image_Test29.txt", memory29, BLOQ_DATA_29_START, BLOQ_DATA_29_END);
                valid = 1;
            end
			end
			else if (address >= BLOQ_PROGRAM_START && address <= BLOQ_PROGRAM_END) begin // Data memory space
            if (read) begin
                data_out = memoryProgram[address];
                valid = 1;
            end
			end
    end

    // Optional: Initialize instruction memory
    initial begin
        // Initialize instruction memory
			memory[0] = 64'hE04F000F0000000;
			memory[1] = 64'hE28000020000000;
			memory[2] = 64'hE3A0A0400000000;
			memory[3] = 64'hE04F100F0000000;
			memory[4] = 64'hE15A00010000000;
			memory[5] = 64'hA0000050000000;
			memory[6] = 64'hE28120000000000;
			memory[7] = 64'hE00230000000000;
			memory[8] = 64'hE78130000000000;
			memory[9] = 64'hE59140000000000;
			memory[10] = 64'hE28110010000000;
			memory[11] = 64'hE80000090000000;
			memory[12] = 64'hE28110640000000;

			// Fill remaining instruction memory with zeros or default values
			for (int i = 13; i <= INSTR_END; i++) begin
				memory[i] = 64'h0;
			end
			
//			$readmemb("C:/Users/DELIA/Documents/GitHub/CE4302-P2-2023-S2/ImagesTxt/BN_Image_Test101888.txt", memory, DATA_START, DATA_END);
			// Initialize data memoryv
//			memory[DATA_START] = 64'h1234567800000000; // Example data
//			memory[DATA_START+1] = 64'h9ABCDEF000000000;
//			// ... other data ...
//
//			// Fill remaining data memory with zeros or default values
//			for (int i = DATA_START+2; i < MEM_SIZE; i++) begin
//				memory[i] = 64'h0;
//			end

//			string file_name;
         $readmemb("ImagesTxt/BN_Image_Test0.txt", memory0, BLOQ_DATA_0_START, BLOQ_DATA_0_END);
         $readmemb("ImagesTxt/BN_Image_Test1.txt", memory1, BLOQ_DATA_1_START, BLOQ_DATA_1_END);
			$readmemb("ImagesTxt/BN_Image_Test2.txt", memory2, BLOQ_DATA_2_START, BLOQ_DATA_2_END);
			$readmemb("ImagesTxt/BN_Image_Test3.txt", memory3, BLOQ_DATA_3_START, BLOQ_DATA_3_END);
			$readmemb("ImagesTxt/BN_Image_Test4.txt", memory4, BLOQ_DATA_4_START, BLOQ_DATA_4_END);
			$readmemb("ImagesTxt/BN_Image_Test5.txt", memory5, BLOQ_DATA_5_START, BLOQ_DATA_5_END);
			$readmemb("ImagesTxt/BN_Image_Test6.txt", memory6, BLOQ_DATA_6_START, BLOQ_DATA_6_END);
			$readmemb("ImagesTxt/BN_Image_Test7.txt", memory7, BLOQ_DATA_7_START, BLOQ_DATA_7_END);
			$readmemb("ImagesTxt/BN_Image_Test8.txt", memory8, BLOQ_DATA_8_START, BLOQ_DATA_8_END);
			$readmemb("ImagesTxt/BN_Image_Test9.txt", memory9, BLOQ_DATA_9_START, BLOQ_DATA_9_END);
			$readmemb("ImagesTxt/BN_Image_Test10.txt", memory10, BLOQ_DATA_10_START, BLOQ_DATA_10_END);
			$readmemb("ImagesTxt/BN_Image_Test11.txt", memory11, BLOQ_DATA_11_START, BLOQ_DATA_11_END);
			$readmemb("ImagesTxt/BN_Image_Test12.txt", memory12, BLOQ_DATA_12_START, BLOQ_DATA_12_END);
			$readmemb("ImagesTxt/BN_Image_Test13.txt", memory13, BLOQ_DATA_13_START, BLOQ_DATA_13_END);
			$readmemb("ImagesTxt/BN_Image_Test14.txt", memory14, BLOQ_DATA_14_START, BLOQ_DATA_14_END);
			$readmemb("ImagesTxt/BN_Image_Test15.txt", memory15, BLOQ_DATA_15_START, BLOQ_DATA_15_END);
			$readmemb("ImagesTxt/BN_Image_Test16.txt", memory16, BLOQ_DATA_16_START, BLOQ_DATA_16_END);
			$readmemb("ImagesTxt/BN_Image_Test17.txt", memory17, BLOQ_DATA_17_START, BLOQ_DATA_17_END);
			$readmemb("ImagesTxt/BN_Image_Test18.txt", memory18, BLOQ_DATA_18_START, BLOQ_DATA_18_END);
			$readmemb("ImagesTxt/BN_Image_Test19.txt", memory19, BLOQ_DATA_19_START, BLOQ_DATA_19_END);
			$readmemb("ImagesTxt/BN_Image_Test20.txt", memory20, BLOQ_DATA_20_START, BLOQ_DATA_20_END);
			$readmemb("ImagesTxt/BN_Image_Test21.txt", memory21, BLOQ_DATA_21_START, BLOQ_DATA_21_END);
			$readmemb("ImagesTxt/BN_Image_Test22.txt", memory22, BLOQ_DATA_22_START, BLOQ_DATA_22_END);
			$readmemb("ImagesTxt/BN_Image_Test23.txt", memory23, BLOQ_DATA_23_START, BLOQ_DATA_23_END);
			$readmemb("ImagesTxt/BN_Image_Test24.txt", memory24, BLOQ_DATA_24_START, BLOQ_DATA_24_END);
			$readmemb("ImagesTxt/BN_Image_Test25.txt", memory25, BLOQ_DATA_25_START, BLOQ_DATA_25_END);
			$readmemb("ImagesTxt/BN_Image_Test26.txt", memory26, BLOQ_DATA_26_START, BLOQ_DATA_26_END);
			$readmemb("ImagesTxt/BN_Image_Test27.txt", memory27, BLOQ_DATA_27_START, BLOQ_DATA_27_END);
			$readmemb("ImagesTxt/BN_Image_Test28.txt", memory28, BLOQ_DATA_28_START, BLOQ_DATA_28_END);
			$readmemb("ImagesTxt/BN_Image_Test29.txt", memory29, BLOQ_DATA_29_START, BLOQ_DATA_29_END);
		
//			for (int i = BLOQ_PROGRAM_START; i <= BLOQ_PROGRAM_END; i++) begin
//			for (int i = BLOQ_PROGRAM_START; i <= 5000; i++) begin
//				memoryProgram[i] = 64'h0;
//			end
		end

endmodule

