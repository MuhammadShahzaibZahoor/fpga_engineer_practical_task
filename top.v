`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2025 04:59:47 AM
// Design Name: 
// Module Name: top
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


module top (
    input clk,
    input rst,
    input start,
    output done
);

wire [2:0] add;
wire wr;
wire [7:0] data;

// Instantiate your controller
controller uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .add(add),
    .wr(wr),
    .data(data),
    .done(done)
);

// Instantiate your RAM
RAM mem (
    .clk(clk),
    .rst(rst),
    .add(add),
    .wr(wr),
    .data(data)
);

endmodule
