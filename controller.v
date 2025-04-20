`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2025 10:27:18 PM
// Design Name: 
// Module Name: controller
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


module controller
(
    input clk, 
    input rst,
    input start,
    output reg [2:0] add,
    output wr,
    inout [7:0] data,
    output reg done
);

reg [7:0] A,B;
reg [2:0] i, j;
reg [1:0] counter;

parameter IDLE  = 4'd0;
parameter RFW0   = 4'd13;
parameter RFW   = 4'd1;
parameter RSW   = 4'd2;
parameter RSW0   = 4'd12;
parameter COMP  = 4'd3;
parameter VLT   = 4'd4;
parameter VGT   = 4'd5;
parameter INC_I = 4'd6;
parameter INC_J = 4'd7;
parameter WFW   = 4'd8;
parameter WFW0   = 4'd14;
parameter WSW   = 4'd9;
parameter WSW0   = 4'd15;
parameter RFW2  = 4'd10;
parameter DONE  = 4'd11;

reg [3:0] ps,ns;
always@(posedge clk or posedge rst) begin
    if(rst) begin
        ps <= IDLE;  
    end else begin
        ps <= ns;
    end
end

always@(*) begin
    case(ps)
    IDLE: begin
        if(start) begin
            ns = RFW0;
        end else begin
            ns = ps;
        end 
    end
    RFW0: ns = RFW;
    RFW : begin
        if(counter == 2) begin
            ns = RSW0;  // add = i;
        end else begin
            ns = ps;
        end
    end
    RSW0: ns = RSW;
    
    RSW : begin
        if(counter == 2) begin
            ns = COMP; // add = j;
        end else begin
            ns = ps;
        end
    end

    COMP : begin
        if(A > B) begin
            ns = VGT;
        end else begin
            ns = VLT;
        end
    end

    VGT : begin
        if(j == 7) begin
            if(i == 6) begin
                ns = DONE;
            end
            else begin
                ns = INC_I;
            end
        end
        else begin
            ns = INC_J;
        end
    end

    VLT : begin
        ns = WFW0;
    end
    WFW0 : begin
        ns = WFW;
    end 
    WFW : begin
        if(counter == 2) begin
            ns = WSW0;
        end else begin
            ns = ps;
        end
    end
WSW0 : begin
        ns = WSW;
    end
    WSW : begin
        if(counter == 2) begin
            ns = RFW2;
        end else begin
            ns = ps;
        end
    end

    RFW2 : begin
        if(j == 7) begin
            if(i == 6) begin
                ns = DONE;
            end
            else begin
                if(counter == 2) begin
                    ns = INC_I;
                end else begin
                    ns = ps;
                end
            end
        end 
        else begin
            if(counter == 2) begin
                ns = INC_J;
            end else begin
                ns = ps;
            end
        end
       end

    INC_I : begin
        ns = RFW0;
    end

    INC_J : begin
        ns = RSW0;
    end

    default : begin
        ns = IDLE;
    end 
    endcase
end

always@(posedge clk or posedge rst) begin
    if(rst) begin
        counter <= 0;
    end else begin
        if(counter == 2) begin
            counter <= 0;
        end else if (ps == WFW || ps == WSW) begin
            counter <= counter + 1;
        end else if (ps == RFW || ps == RSW || ps == RFW2) begin
            counter <= counter + 1;
        end else begin
            counter <= counter;
        end
    end
end

always@(posedge clk or posedge rst) begin
    if(rst) begin
        i <= 0; j <= 1;
    end else begin
        if(ps ==IDLE) begin
            i <= 0; j <= 1;
        end else if (ps == INC_I) begin
            i <= i + 1; j <= i + 2;
        end else if(ps == INC_J) begin
            j <= j + 1;
        end else begin
            i <= i; j <= j;
        end
    end
end

always@(posedge clk or posedge rst) begin
    if(rst) begin
        add <= 0;
    end else begin
        if(ps == RFW0 || ps == WFW0 || ps == RFW2) begin
            add <= i;
        end else if (ps == RSW0 || ps == WSW0) begin
            add <= j;
        end
    end
end

//always@(posedge clk or posedge rst) begin
//    if(rst) begin
//        wr <= 1;
//    end else begin
//        if (ps == WFW || ps == WSW || ps == WFW0 || ps == WSW0) begin
//            wr <= 0;
//        end else begin
//            wr <= 1;
//        end
//    end
//end
assign wr = (ps == WFW || ps == WSW) ? 0 : 1;

always@(posedge clk or posedge rst) begin
    if(rst) begin
        A <= 8'd0; B <= 8'd0;
    end else begin
        if(ps == IDLE) begin
            A <= 8'd0; B <= 8'd0;
        end else if(ps == RFW  || ps == RFW2) begin
            A <= data;
        end else if (ps == RSW) begin
            B <= data;
        end else begin
            A <= A; B <= B;
        end
    end
end

always@(posedge clk or posedge rst) begin
    if(rst) begin
        done <= 0;
    end else begin
        if(ps == DONE) begin
            done <= 1; 
        end else begin
            done <= 0;
        end 
    end
end 

assign data = (ps == WFW) ? B : (ps == WSW) ? A : 8'dz;
endmodule
