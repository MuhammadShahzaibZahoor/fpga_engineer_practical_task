`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 09:54:47 PM
// Design Name: 
// Module Name: RAM
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


module RAM(
    input clk,
    input rst,
    input [2:0] add,
    input wr,
   inout [7:0] data
    );
    
reg [7:0] mem [0:7];
always@(posedge clk or posedge rst)
begin
    if(rst) begin
        mem[0] <= 8'd90; mem[1] <= 8'd25; mem[2] <= 8'd60;
        mem[3] <= 8'd15; mem[4] <= 8'd30; mem[5] <= 8'd75;
        mem[6] <= 8'd45; mem[7] <= 8'd10;
    end else if(~wr) begin
        mem[add] <= data;
    end    
end

assign data = (wr) ? mem[add] : 8'dz;
endmodule
