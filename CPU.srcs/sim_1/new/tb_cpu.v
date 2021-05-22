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
    wire [3:0] m_rw_io_rw;
    wire [31:0] instruction;
    wire [31:0] alu_res;
    wire [31:0] rd1, imt;
    
    cpu_top u_cpu(
        .clock(clock),
        .fpga_reset(fpga_reset),
        .start_pg(start_pg),
        .rx(rx),
        .tx(tx),
        .switch_in(switch_in),
        .led_out(led_out),
        .m_rw_io_rw(m_rw_io_rw),
        .instruction_o(instruction),
        .alu_res(alu_res),
        .rd1(rd1),
        .imt(imt)
    );
    
    initial begin
        clock = 0;
        fpga_reset = 0;
        start_pg = 0;
        rx = 0;
        switch_in = 23'b0;
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
