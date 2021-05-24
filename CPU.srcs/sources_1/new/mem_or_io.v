`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 20:40:03
// Design Name: 
// Module Name: mem_or_io
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


module mem_or_io(
    input m_read, // read memory, from control32
    input m_write, // write memory, from control32
    input io_read, // read IO, from control32
    input io_write, // write IO, from control32
    input [31:0] addr_in, // from alu_result in executs32
    input [31:0] m_rdata, // data read from memory
    input [15:0] io_rdata, // data read from io,16 bits
    input [31:0] r_rdata, // data read from idecode32(register file)
    
    output [31:0] r_wdata, // data to idecode32(register file)
    output [31:0] addr_out, // address to memory
    output reg [31:0] write_data, // data to memory or I/O£¨m_wdata, io_wdata£©
    output led_ctrl, // LED Chip Select
    output seg_ctrl, // seg_led cs
    output switch_ctrl // Switch
);
    wire led_or_seg = addr_in == 32'hFFFFFC80; // 1 -> seg : 0 -> led
    assign addr_out = addr_in;
    assign r_wdata = io_read ? {16'h0000, io_rdata} : m_rdata;
    assign led_ctrl = io_write && !led_or_seg;
    assign seg_ctrl = io_write && led_or_seg;
    assign switch_ctrl = io_read;
    
    always @* begin
        if (m_write || io_write) begin
            write_data = r_rdata;
        end
        else begin
            write_data = 32'hZZZZZZZZ;
        end
    end
endmodule
