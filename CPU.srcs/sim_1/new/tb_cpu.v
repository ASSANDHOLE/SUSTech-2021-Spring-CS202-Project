`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/22 21:36:00
// Design Name: 
// Module Name: tb_cpu
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


module tb_cpu;
    reg clock;
    reg fpga_reset;
    reg start_pg;
    reg rx;
    wire tx;
    
    reg [23:0] switch_in;
    wire [23:0] led_out;
   
    wire lc, lr, lw, lcs;
    wire [1:0] la;
    wire [15:0] lw15;
    
    cpu_top ct(
        .clock(clock),
        .fpga_reset(fpga_reset),
        .start_pg(start_pg),
        .rx(rx),
        .tx(tx),
        .switch_in(switch_in),
        .led_out(led_out),
        
        .lc(lc),
        .lr(lr),
        .lw(lw),
        .lcs(lcs),
        .la(la),
        .lw15(lw15)
    );
    
    initial begin
        clock = 0;
        fpga_reset = 0;
        start_pg = 0;
        rx = 0;
        switch_in = 0;
        # 2000 fpga_reset = 1;
        # 20 fpga_reset = 0;
        # 100 switch_in = 23'b1;
        # 100 switch_in = 23'b1101;
        # 100 switch_in = 23'b1110111101111111111111;
        # 100 $finish;
    end
    
    always begin
        # 1 clock = ~clock;
    end
endmodule
