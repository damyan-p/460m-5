`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2022 03:59:14 PM
// Design Name: 
// Module Name: clk_div
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


module clk_div(
    input clk,
    input [30:0] offset,
    output slow_clk
    );
    
    assign slow_clk = (COUNT == offset);
    reg [30:0] COUNT;
    
    initial begin
    COUNT <= 0;
    end
            
    always @(posedge clk) begin
    if(COUNT == offset) begin
        COUNT <= 0;
        end
    else COUNT <= COUNT + 1;
    end
    
endmodule