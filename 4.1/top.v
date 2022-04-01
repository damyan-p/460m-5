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
    
    reg[6:0] SPR, DAR;
    reg[7:0] DVR;
    reg[4:0] state;
    reg[4:0] next_state;
    reg[7:0] out;
    
    assign leds[7] = (SPR == 7'h7F);
    assign leds[6] = DAR[6];
    assign leds[5] = DAR[5];
    assign leds[4] = DAR[4];
    assign leds[3] = DAR[3];
    assign leds[2] = DAR[2];
    assign leds[1] = DAR[1];
    assign leds[0] = DAR[0];
    

    reg we;
    reg[6:0] addr;
    reg[7:0] data_out_mem;
    reg[7:0] data_out_ctrl;
    reg[7:0] data_bus;
    reg[7:0] val;
    
    reg[7:0] RAM[0:127];

    //controller ctr1(clk, we, DAR, data_bus, data_out_ctrl, btns, swtchs, leds, segs, an);    
    always @(negedge clk) begin
        if((we == 1))
            RAM[DAR] <= data_bus[7:0];
            
        DVR <= RAM[DAR];
    end
    
    wire disp_clk;
    clk_div_b clk1(.clk(clk),.offset(31'd17),.slow_clk(disp_clk));
    dispFSM display(.clk(disp_clk),.an(an),.segs(segs),.out(out));  
      
    initial begin
    SPR <= 7'h7F;
    DAR <= 0;
    DVR <= 0;
    state <= 3;
    next_state <= 0;
    out <= 0;
    we <= 0;
    addr <= 0;
    data_out_mem <= 0;
    data_out_ctrl <= 0;
    data_bus <= 0;
    val <= 0;
    end
    
    always @(state,btns[1],btns[0]) begin
    case(state)
        5'd0: 
        begin
        data_bus = data_out_mem;
        out = data_bus;
        if(btns[1] || btns[0]) begin
            next_state = btns;
            end else
        next_state = 0;
        end
        5'd1: 
        begin
        we = 0;
        SPR = SPR - 1;
        DAR = SPR + 1;
        next_state = 3;
        data_bus = 0;
        end
        5'd2: 
        begin
        we = 0;
        next_state = 11;
        end
        5'd5: 
        begin
        we = 0;
        next_state = 7;
        end
        5'd6: 
        begin
        we = 0;
        next_state = 8;
        end
        5'd9: 
        begin
        we = 0;
        DAR = SPR + 1;
        next_state = 11;
        end
        5'd10: 
        begin
        we = 0;
        SPR = 7'h7F;
        DAR = 0;
        next_state = 0;
        end
        5'd17: 
        begin
        DAR = DAR - 1;
        we = 0;
        next_state = 11;
        end
        5'd18: 
        begin
        DAR = DAR + 1;
        we = 0;
        next_state = 11;
        end
        5'd3: 
        begin
        we = 1;
        read_data = 0;
        read_val = 0;
        read_in = 1;
        next_state = 20;
        end
        5'd4: 
        begin
        SPR = SPR + 1;
        DAR = SPR + 1;
        we = 0;
        next_state = 11;
        end
        5'd7: 
        begin
        val = DVR;
        SPR = SPR + 1;
        DAR = SPR;
        we = 0;
        next_state = 12;
        end
        5'd8: 
        begin
        val = DVR;
        SPR = SPR + 1;
        DAR = SPR;
        we = 0;
        next_state = 13;
        end
        5'd11: 
        begin
        next_state = 0;
        end
        5'd12: 
        begin
        we = 0;
        next_state = 14;
        end
        5'd13: 
        begin
        we = 0;
        next_state = 14;
        end
        5'd14: 
        begin
        we = 0;
        val = val + val;
        next_state = 16;
        end
        5'd15: 
        begin
        we = 0;
        val = DVR - val;
        next_state = 16;
        end
        5'd16: 
        begin
        data_bus = val;
        we = 1;
        next_state = 0;
        end
        endcase
    end
    
    always @(posedge clk) begin
    state <= next_state;
    end

endmodule
