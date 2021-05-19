`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 20:06:59
// Design Name: 
// Module Name: dmemory32
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


module dmemory32(
    input ram_clk_i, // from CPU top
    input ram_wen_i, // from controller
    input [13:0] ram_adr_i, // from alu_result of ALU
    input [31:0] ram_dat_i, // from read_data_2 of decoder
    output [31:0] ram_dat_o, // the data read from ram
    // UART Programmer Pinouts
    input upg_rst_i, // UPG reset (Active High)
    input upg_clk_i, // UPG ram_clk_i (10MHz)
    input upg_wen_i, // UPG write enable
    input [13:0] upg_adr_i, // UPG write address
    input [31:0] upg_dat_i, // UPG write data
    input upg_done_i // 1 if programming is finished
);

    wire ram_clk = !ram_clk_i;
    // CPU work on normal mode when kickOff is 1. //CPU work on Uart communicate mode when kickOff is 0. 
    wire kicked_off = upg_rst_i | (~upg_rst_i & upg_done_i);
    ram u_ram(
        .clka(kicked_off ? ram_clk : upg_clk_i),
        .wea(kicked_off ? ram_wen_i : upg_wen_i),
        .addra(kicked_off ? ram_adr_i : upg_adr_i),
        .dina(kicked_off ? ram_dat_i : upg_dat_i),
        .douta(ram_dat_o)
);
endmodule
