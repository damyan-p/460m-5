`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2022 10:19:58 PM
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


module top(clk,btns,swtchs,leds,segs,an);
    input clk;
    input[3:0] btns;
    input[7:0] swtchs;
    output[7:0] leds;
    output[6:0] segs;
    output[3:0] an;
    
    assign leds[7] = (SPR == 7'h7F);
    assign leds[6] = DAR[6];
    assign leds[5] = DAR[5];
    assign leds[4] = DAR[4];
    assign leds[3] = DAR[3];
    assign leds[2] = DAR[2];
    assign leds[1] = DAR[1];
    assign leds[0] = DAR[0];
    

    wire we;
    wire[6:0] addr;
    wire[7:0] data_out_mem;
    wire[7:0] data_out_ctrl;
    wire[7:0] data_bus;

    controller ctr1(clk, we, DAR, data_bus, data_out_ctrl, btns, swtchs, leds, segs, an, sel);
    
    memory mem(clk, we, DAR, data_bus, DVR);
    
    wire disp_clk;
    clk_div_b clk1(.clk(clk),.offset(30'd17),.slow_clk(disp_clk));
    dispFSM display(.clk(disp_clk),.an(an),.segs(segs),.out(out));
    
    reg[6:0] SPR, DAR;
    reg[7:0] DVR;
    reg[4:0] state;
    reg[4:0] next_state;
    reg[7:0] out;  
      
    initial begin
    SPR <= 7'h7F;
    DAR <= 0;
    DVR <= 0;
    state <= 3;
    next_state <= 0;
    out <= 0;
    end
    
    always @(state,btns[1],btns[0]) begin
    case(state)
        default: data_bus = 0;
        'd0: begin
        data_bus = data_out_mem;
        out = data_bus;
        if(btns[1] || btns[0]) begin
        next_state = btns;
        end else
        next_state = 0;
        end
        'd1: begin
        we = 0;
        SPR = SPR - 1;
        DAR = SPR;
        next_state = 3;
        end
        'd2: begin
        we = 0;
        next_state = 11;
        end
        'd5: begin
        we = 0;
        next_state = 7;
        end
        'd6: begin
        we = 1;
        next_state = 8;
        end
        'd9: begin
        we = 0;
        DAR = SPR + 1;
        next_state = 11;
        end
        'd10: begin
        we = 0;
        SPR = 7'h7F;
        DAR = 0;
        DVR = 0;
        next_state = 0;
        end
        'd17: begin
        DAR = DAR - 1;
        we = 0;
        next_state = 11;
        end
        'd18: begin
        DAR = DAR + 1;
        we = 0;
        next_state = 11;
        'd3: begin
        we = 0;
        next_state = 11;
        end
        'd4: begin
        SPR = SPR + 1;
        DAR = SPR;
        
        end
        'd
    endcase
    end
    
    always @(posedge clk) begin
    state <= next_state;
    end

endmodule
