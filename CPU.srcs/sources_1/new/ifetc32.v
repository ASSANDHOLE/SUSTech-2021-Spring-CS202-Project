`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 20:07:24
// Design Name: 
// Module Name: ifetc32
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


module ifetc32(
    output [31:0] branch_base_addr,
    output reg [31:0] link_addr,
    output [31:0] pco,
    input [31:0] instruction_i,
    input clock, reset,
    input [31:0] addr_result,
    input zero,
    input [31:0] read_data_1,
    input branch,
    input n_branch,
    input jmp,
    input jal,
    input jr
);

    reg [31:0] pc, next_pc;
    
    always @* begin
        if ((branch && zero) || (n_branch && ~zero)) begin
            next_pc = addr_result << 2;
        end
        else if(jr) begin
            next_pc = read_data_1 << 2;
        end
        else begin
            next_pc = pc + 4;
        end
    end
    
    always @(negedge clock) begin
        if (reset) begin
            pc <= 0;
        end
        else begin
            if (jmp || jal) begin
                pc <= {4'b0000, instruction_i[25:0], 2'b00};
            end
            else begin
                pc <= next_pc;
            end
        end
    end
    
    always @(posedge jmp, posedge jal) begin
        if (jmp || jal) begin
            link_addr <= (pc + 4) >> 2;
        end
    end
    
    assign branch_base_addr = pc + 4;
    
    assign pco = pc;
endmodule