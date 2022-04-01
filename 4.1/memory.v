`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2022 10:23:04 PM
// Design Name: 
// Module Name: memory
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


module memory(clk, we, address, data_in, data_out);
    input clk;
    input we;
    input[6:0] address;
    input[7:0] data_in;
    output[7:0] data_out;
    
    reg[7:0] data_out;
    reg[7:0] RAM[0:127];
    
    always @(negedge clk) begin
        if((we == 1))
            RAM[address] <= data_in[7:0];
            
        data_out <= RAM[address];
    end
    
endmodule
