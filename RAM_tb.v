`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 10:02:34 PM
// Design Name: 
// Module Name: RAM_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module RAM_tb;

  reg clk;
  reg rst;
  reg [2:0] add;
  reg wr;
  wire [7:0] data;

  reg [7:0] data_out;
  wire [7:0] data_in;

  assign data = (wr == 0) ? data_out : 8'bz; // drive data only when writing
  assign data_in = data; // read from data bus

  // Instantiate the RAM
  RAM uut (
    .clk(clk),
    .rst(rst),
    .add(add),
    .wr(wr),
    .data(data)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10 ns clock period
  end

  initial begin
    // Initialize
    rst = 1;
    wr = 1;
    data_out = 8'd0;
    add = 3'd0;

    #10 rst = 0;

    // Write data 123 to address 2
    #10 wr = 0; add = 3'd2; data_out = 8'd123;
    #10 wr = 1; // release bus

    // Read from address 2
    #10 add = 3'd2;
    #10;

    $display("Read data from address 2 = %d", data_in); // should be 123
    #10;

    // Read from address 0 (preloaded = 90)
    add = 3'd0;
    #10;
    $display("Read data from address 0 = %d", data_in); // should be 90

    #20;
    $stop;
  end

endmodule

