`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 20:54:46
// Design Name: 
// Module Name: control32
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


module control32(
    input [5:0] opcode, // instruction[31..26]
    input [5:0] function_opcode, // instructions[5..0]
    input [21:0] alu_result_high,
    
    output jr, // 1 indicates the instruction is "jr", otherwise it's not "jr" output jmp;
    output jmp, // 1 indicate the instruction is "j", otherwise it's not
    output jal, // 1 indicate the instruction is "jal", otherwise it's not
    output branch, // 1 indicate the instruction is "beq" , otherwise it's not
    output n_branch, // 1 indicate the instruction is "bne", otherwise it's not
    output reg_dst, // 1 indicate destination register is "rd",otherwise it's "rt" 
	output mem_or_io_to_reg, // 1 indicate read data from memory and write it into register
    output reg_write, // 1 indicate write register, otherwise it's not
    output mem_write, // 1 indicate write data memory, otherwise it's not
    output alu_src, // 1 indicate the 2nd data is immidiate (except "beq","bne")
    output sftmd,
    output i_format,
    output[1:0] alu_op,
    output mem_read,
    output io_read,
    output io_write
    );
    wire r_format;
    wire lw;
    wire sw;

    assign jr = (function_opcode == 6'b001000) && (opcode == 6'b000000);
    assign jmp = opcode == 6'b000010;
    assign jal = opcode == 6'b000011;
    assign r_format = opcode == 6'b000000;
    assign lw = opcode == 6'b100011;
    assign sw = opcode == 6'b101011;
    assign mem_write = sw && (alu_result_high[21:0] != 22'b11_1111_1111_1111_1111_1111);
    assign mem_read = lw && (alu_result_high[21:0] != 22'b11_1111_1111_1111_1111_1111);
    assign io_read = lw && (alu_result_high[21:0] == 22'b11_1111_1111_1111_1111_1111);
    assign io_write = sw && (alu_result_high[21:0] == 22'b11_1111_1111_1111_1111_1111);
    assign reg_dst = r_format;
    assign reg_write = (r_format || jal || lw || i_format) && !jr;
    assign i_format = opcode[5:3] == 3'b001;
    assign alu_op = {(r_format || i_format), (branch || n_branch)};
    assign sftmd = (   (function_opcode == 6'b000000) || (function_opcode == 6'b000010)
                    || (function_opcode == 6'b000011) || (function_opcode == 6'b000100)
                    || (function_opcode == 6'b000110) || (function_opcode == 6'b000111))
                    && r_format;
    assign branch = opcode == 6'b000100;
    assign n_branch = opcode == 6'b000101;
    assign mem_or_io_to_reg = io_read || mem_read;
    assign alu_src = i_format || (lw || sw) || mem_write;
endmodule
