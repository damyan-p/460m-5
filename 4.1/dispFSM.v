`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2022 11:02:16 PM
// Design Name: 
// Module Name: dispFSM
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


module dispFSM(input clk, output[3:0] an, output[6:0] segs, input[7:0] out);

reg[6:0] segs_reg;
reg[3:0] an_reg;

wire[6:0] in0, in1;
assign segs = segs_reg;
assign an = an_reg;

hex_to_sseg h0(.x(out[7:4]),.r(in0));
hex_to_sseg h1(.x(out[3:0]),.r(in1));

reg state;
reg next_state;

initial begin
segs_reg <= 0;
an_reg <= 0;
state <= 0;
next_state <= 0;
end

always @(*) begin
    an_reg[3:2] <= 1;
    case(state)
    0: begin
        an_reg[1:0] <= 10;
        segs_reg <= in0;
        next_state <= 1;
    end
    1: begin
        an_reg[1:0] <= 01;
        segs_reg <= in1;
        next_state <= 0;
    end
    endcase
end

always @(posedge clk) begin
state <= next_state;
end

endmodule
