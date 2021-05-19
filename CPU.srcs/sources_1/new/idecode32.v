`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 20:08:24
// Design Name: 
// Module Name: idecode32
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


module idecode32(
    output [31:0] read_data_1,
    output [31:0] read_data_2,
    output [31:0] imme_extend,
    
    input [31:0] instruction,
    input [31:0] read_data,
    input [31:0] alu_result,
    input jal,
    input reg_write,
    input mem_to_reg,
    input reg_dst,
    input clock, reset,
    input [31:0] opcplus4
);

    reg [31:0] registers [0:31];
    reg [4:0]  write_register;
    reg [31:0] write_data;

    wire [4:0] read_register_1;
    wire [4:0] read_register_2;
    wire [4:0] rd;
    wire [4:0] rt;
    wire [15:0] imme_ori;
    
    assign read_register_1 = instruction[25:21];
    assign read_register_2 = instruction[20:16];
    assign rd = instruction[15:11];
    assign rt = instruction[20:16];
    assign imme_ori = instruction[15:0];
    assign imme_extend = {{16{imme_ori[15]}}, imme_ori};
    
    assign read_data_1 = registers[read_register_1];
    assign read_data_2 = registers[read_register_2];
    
    always @* begin
        if(reg_write) begin
            if(jal) begin
                write_register = 5'b11111;
            end
            else begin
                write_register = reg_dst ? rd : rt;
            end
        end
    end
    
    always @* begin 
        if (jal) begin
            write_data = opcplus4;
        end
        else if(mem_to_reg) begin
            write_data = read_data;
        end
        else begin
            write_data = alu_result;
        end
    end
    
    integer i;
    always @(posedge clock) begin
        if(reset) begin
            for(i = 0; i < 32; i = i + 1) begin
                registers[i] <= 0;
            end
        end 
        if(reg_write) begin
            registers[write_register] <= write_data;    
        end
    end
endmodule
