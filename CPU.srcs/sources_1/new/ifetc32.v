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
    output [31:0] instruction,
    output [31:0] branch_base_addr,
    output reg [31:0] link_addr,
    input clock, reset,
    input [31:0] addr_result,
    input zero,
    input [31:0] read_data_1,
    input branch,
    input n_branch,
    input jmp,
    input jal,
    input jr,
    input upg_rst_i, // UPG reset (Active High)
    input upg_clk_i, // UPG clock (10MHz)
    input upg_wen_i, // UPG write enable
    input[13:0] upg_adr_i, // UPG write address
    input[31:0] upg_dat_i, // UPG write data
    input upg_done_i // 1 if program finished
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
                pc <= {4'b0000, instruction[25:0], 2'b00};
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
    
    program_rom u_rom(
        .rom_clk_i(clock),
        .instruction_o(instruction),
        .rom_adr_i(pc[15:2]),
        .upg_rst_i(upg_rst_i),
        .upg_clk_i(upg_clk_i),
        .upg_wen_i(upg_wen_i),
        .upg_adr_i(upg_adr_i),
        .upg_dat_i(upg_dat_i),
        .upg_done_i(upg_done_i)
    );
endmodule