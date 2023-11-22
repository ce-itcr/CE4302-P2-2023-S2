module ImageRAM(
  input logic clk,
  input logic [17:0] address,
  output logic [31:0] pixel
);

  logic [31:0] RAM [0:45500]; // 300x300 pixels, 8 bits per pixel

  // Read from memory
  always_ff @(posedge clk) begin
    if (address < 45501)
      pixel <= RAM[address];
    else
      pixel <= 0; // Default value if address is out of range
  end

  // Initialize memory contents
  initial begin
    $readmemh("tessia.mif", RAM); // Read memory values from .mif file
  end

endmodule