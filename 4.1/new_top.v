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


module new_top(clk,btns,swtchs,leds,segs,an);
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
    wire[7:0] data_bus;
    reg[7:0] val;
    
    reg read_data;
    reg read_val;
    reg read_in;
    assign data_bus = read_data ? data_out_mem : 'bz;
    assign data_bus = read_val ? val : 'bz;
    assign data_bus = read_in ? swtchs : 'bz;

    //controller ctr1(clk, we, DAR, data_bus, data_out_ctrl, btns, swtchs, leds, segs, an); 
    //memory m1(clk, we, DAR, data_bus, DVR);
    reg[7:0] RAM[0:127];
    
    always @(negedge clk) begin
        if((we == 1))
            RAM[DAR] <= data_bus[7:0];
            
        DVR <= RAM[DAR];
    end
    
    wire n_clk;
    wire disp_clk;
    wire b[3:0];
    
    debounce d0(.clk(clk),.slow_clk(n_clk),.in(btns[0]),.out(b[0]));
    debounce d1(.clk(clk),.slow_clk(n_clk),.in(btns[1]),.out(b[1]));
    debounce2 d2(.clk(clk),.slow_clk(n_clk),.in(btns[2]),.out(b[2]));
    debounce2 d3(.clk(clk),.slow_clk(n_clk),.in(btns[3]),.out(b[3]));
    
    //  SIM clocks
    //clk_div_b clk1(.clk(clk),.offset(31'd17),.slow_clk(disp_clk));
    //clk_div clk2(.clk(clk),.offset(31'd2),.slow_clk(n_clk));
    
    //  FPGA clocks
    clk_div_b clk1(.clk(clk),.offset(31'd17),.slow_clk(disp_clk));
    clk_div clk2(.clk(clk),.offset(31'd5000000),.slow_clk(n_clk));
    
    dispFSM display(.clk(disp_clk),.an(an),.segs(segs),.out(out));  
      
    initial begin
    read_data <= 0;
    read_val <= 0;
    read_in <= 0;
    SPR <= 7'h7F;
    DAR <= 0;
    state <= 11;
    next_state <= 0;
    out <= 0;
    we <= 0;
    addr <= 0;
    data_out_mem <= 0;
    data_out_ctrl <= 0;
    val <= 0;
    end
    
    always @(state,b[1],b[0]) begin
    case(state)
        5'd0: 
        begin
        we = 0;
        if(b[1] || b[0]) begin
            next_state[4] = 0;
            next_state[3] = b[3];
            next_state[2] = b[2];
            next_state[1] = b[1];
            next_state[0] = b[0];
            end else
            next_state = 0;
        end
        5'd1: 
        begin
        read_data = 0;
        read_val = 0;
        read_in = 0;
        we = 0;
        
        SPR = SPR - 1;
        DAR = SPR + 1;
        next_state = 3;
        end
        5'd2: 
        begin
        read_data = 0;
        read_val = 0;
        read_in = 0;
        we = 0;
        next_state = 11;
        end
        5'd5: 
        begin
        read_data = 0;
        read_val = 0;
        read_in = 0;
        we = 0;
        next_state = 7;
        end
        5'd6: 
        begin
        read_data = 0;
        read_val = 0;
        read_in = 0;
        we = 0;
        next_state = 8;
        end
        5'd9: 
        begin
        read_data = 0;
        read_val = 0;
        read_in = 0;
        we = 0;
        DAR = SPR + 1;
        next_state = 11;
        end
        5'd10: 
        begin
        read_data = 0;
        read_val = 0;
        read_in = 0;
        we = 0;
        SPR = 7'h7F;
        DAR = 0;
        next_state = 0;
        end
        5'd17: 
        begin
        read_data = 0;
        read_val = 0;
        read_in = 0;
        DAR = DAR - 1;
        we = 0;
        next_state = 11;
        end
        5'd18: 
        begin
        read_data = 0;
        read_val = 0;
        read_in = 0;
        DAR = DAR + 1;
        we = 0;
        next_state = 11;
        end
        5'd3: 
        begin
        read_data = 0;
        read_val = 0;
        read_in = 1;
        we = 1;
        next_state = 20;
        end
        5'd4: 
        begin
        read_data = 0;
        read_val = 0;
        read_in = 0;
        SPR = SPR + 1;
        DAR = SPR + 1;
        we = 0;
        next_state = 11;
        end
        5'd7: 
        begin
        read_data = 1;
        read_val = 0;
        read_in = 0;
        val = data_bus;
        SPR = SPR + 1;
        DAR = SPR;
        we = 0;
        next_state = 12;
        end
        5'd8: 
        begin
        read_data = 1;
        read_val = 0;
        read_in = 0;
        val = data_bus;
        SPR = SPR + 1;
        DAR = SPR;
        we = 0;
        next_state = 13;
        end
        5'd11: 
        begin
        read_data = 1;
        read_val = 0;
        read_in = 0;
        we = 0;
        next_state = 20;
        val = data_bus;
        end
        5'd12: 
        begin
        read_data = 0;
        read_val = 0;
        read_in = 0;
        we = 0;
        next_state = 14;
        end
        5'd13: 
        begin
        read_data = 0;
        read_val = 0;
        read_in = 0;
        we = 0;
        next_state = 14;
        end
        5'd14: 
        begin
        read_data = 1;
        read_val = 0;
        read_in = 0;
        we = 0;
        val = data_bus + val;
        next_state = 16;
        end
        5'd15: 
        begin
        read_data = 1;
        read_val = 0;
        read_in = 0;
        we = 0;
        val = data_bus - val;
        next_state = 16;
        end
        5'd16: 
        begin
        read_data = 0;
        read_val = 1;
        read_in = 0;
        we = 1;
        next_state = 19;
        end
        5'd19:
        begin
        read_val = 1;
        read_data = 0;
        read_in = 0;
        out = data_bus;
        next_state = 0;
        we = 0;
        end
        5'd20:
        begin
        read_data = 1;
        read_val = 0;
        read_in = 0;
        we = 0;
        out = data_bus;
        next_state = 0;
        end
        endcase
    end
    
    always @(posedge clk) begin
    state <= next_state;
    end

endmodule
