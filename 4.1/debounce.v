`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2022 02:22:45 AM
// Design Name: 
// Module Name: debounce
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


module debounce(
    input clk,
    input slow_clk,
    input in,
    output out
    );
    
    wire Q1, Q2, Q3;
    assign out = (~Q3) && (Q2);
    
    dflip d0(.clk(slow_clk),.D(in),.Q(Q1));
    dflip d1(.clk(clk),.D(Q1),.Q(Q2));
    dflip d2(.clk(clk),.D(Q2),.Q(Q3));
    
    
    
endmodule

module debounce2(
    input clk,
    input slow_clk,
    input in,
    output out
    );
    
    wire Q1, Q2;
    assign out = (Q2);
    
    dflip d0(.clk(slow_clk),.D(in),.Q(Q1));
    dflip d1(.clk(clk),.D(Q1),.Q(Q2));
    
    
    
endmodule

module dflip(
    input clk,
    input D,
    output reg Q
    );
    initial begin
    Q <= 0;
    end
    
    always @(posedge clk) begin
    Q <= D;
    end
    
endmodule


