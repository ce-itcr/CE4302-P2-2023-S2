module VGAX(
	input logic clk_50,
	input logic imageSelector,
	input logic enable,
	output logic [7:0] VGA_R,           // VGA Red
	output logic [7:0] VGA_G,           // VGA Green
	output logic [7:0] VGA_B,           // VGA Blue
	output logic VGA_CLK,               // VGA Clock
	output logic VGA_SYNC_N,            // VGA Sync signal
	output logic VGA_BLANK_N,           // VGA Blank signal
	output logic VGA_VS,                // VGA virtical sync signal
	output logic VGA_HS                 // VGA horizontal sync signal
);
	logic [9:0] x, y;
	logic video_on;
	logic enable_v_counter;
	

	logic [17:0] address;
	logic [31:0] pixel;

	// Instance of the horizontal counter
	horizontal_counter HC(
        .clk_25(VGA_CLK),
		.enable_v_counter(enable_v_counter), 
		.h_counter(x)
    );

	// Instance of the vertical counter					 
	vertical_counter VC(
        .clk_25(VGA_CLK),
		.enable_v_counter(enable_v_counter), 
		.v_counter(y)
    );

	// Instance of the clk_divider
	vga_clk clk_divider(
        .inclk0(clk_50), 
        .c0(VGA_CLK)
    );
	
	// Instance for the VGAController
	VGAController VGA(
		.rst(1'b1),
		.h_counter(x),
		.v_counter(y),
		.VGA_HS(VGA_HS), 
		.VGA_VS(VGA_VS),      
		.VGA_CLK(VGA_CLK),     
		.VGA_BLANK_N(VGA_BLANK_N), 
		.VGA_SYNC_N(VGA_SYNC_N),
		.video_on(video_on)
    );

	// Instance of the ImageRam
	ImageRAM mem(
		.clk(VGA_CLK),
		.address(address),
		.pixel(pixel)
	);

	// Instance of the PixelFetcher
	PixelFetcher pixelfetcher(
		.clk(VGA_CLK),
		.imageSelector(imageSelector),
		.enable(enable),
		.v_counter(y),
		.h_counter(x),
		.video_on(video_on),
		.pixel(pixel),
		.address(address),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B)
	);
														
endmodule
