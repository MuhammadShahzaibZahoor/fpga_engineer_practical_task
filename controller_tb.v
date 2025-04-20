`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 11:57:15 PM
// Design Name: 
// Module Name: controller_tb
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

module controller_tb();

    reg clk;
    reg rst;
    reg start;
//    wire [2:0] add;
//    wire wr;
    wire done;
//    wire [7:0] data;

top uut(
    .clk(clk),
    .rst(rst),
    .start(start),
    .done(done)
);
//    // Instantiate your controller
//    controller uut (
//        .clk(clk),
//        .rst(rst),
//        .start(start),
//        .add(add),
//        .wr(wr),
//        .data(data),
//        .done(done)
//    );

//    // Instantiate your RAM
//    RAM mem (
//        .clk(clk),
//        .rst(rst),
//        .add(add),
//        .wr(wr),
//        .data(data)
//    );

    // Clock Generation
    always #5 clk = ~clk; // 100 MHz clock

    initial begin
        clk = 0;
        rst = 1;
        start = 0;

        // Reset the system
        #20;
        rst = 0;

        // Start sorting
        #20;
        start = 1;
        #10;
        start = 0;

        // Wait until sorting is done
        wait (done);

        #50;

        $display("Sorted Data in Descending Order:");
        $finish;
    end
endmodule

