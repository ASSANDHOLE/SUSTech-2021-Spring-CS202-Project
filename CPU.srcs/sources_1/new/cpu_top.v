`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 20:05:16
// Design Name: 
// Module Name: cpu_top
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

module cpu_top(
    input clock,
    input reset,
    input upg_rst_i, // UPG reset (Active High)
    input upg_wen_i, // UPG write enable
    input[13:0] upg_adr_i, // UPG write address
    input[31:0] upg_dat_i, // UPG write data
    input upg_done_i // 1 if program finished
);
    // unknown source
    ////////////////////////////////////////////////////////////////////
    wire led_ctrl; // from mem_or_io (output)
    wire switch_ctrl; // from mem_to_io (output)
    wire [15:0] io_rdata; // from mem_or_io (input)
    ////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////
    //// current issues: 
    ////    control32: line 71-72
    ////    cpu_top: something that i'm not sure about (look for comments)
    ////////////////////////////////////////////////////////////////////
    
    wire cpu_clk;
    wire upg_clk;
    wire [31:0] instruction;
    wire [31:0] branch_base_addr;
    wire [31:0] link_addr;
    wire [31:0] addr_result;
    wire zero;
    wire branch;
    wire n_branch;
    wire jmp;
    wire jal;
    wire [31:0] alu_result;
// from decoder
    wire [31:0] read_data_1;
    wire [31:0] read_data_2;
    wire [31:0] imme_extend;
// from controller
    wire [1:0] alu_op;
    wire alu_src;
    wire i_format;
    wire sftmd;
    wire jr;
    
    wire reg_dst;
	wire mem_or_io_to_reg;
    wire reg_write;
    wire mem_write;
    wire mem_read;
    wire io_read;
    wire io_write;
    wire ram_dat_o;
    wire r_wdata;
    wire [31:0] write_data_mio;
    wire [31:0] addr_out_mio;
    
    cpuclk u_clk(
        .clk_in1(clock),
        .clk_out1(cpu_clk),
        .clk_out2(upg_clk)
    );
    
    ifetc32 u_ifetch(
        .instruction(instruction),
        .branch_base_addr(branch_base_addr),
        .link_addr(link_addr),
        .clock(cpu_clk),
        .reset(reset),
        .addr_result(addr_result),
        .zero(zero),
        .read_data_1(read_data_1),
        .branch(branch),
        .n_branch(n_branch),
        .jmp(jmp),
        .jal(jal),
        .jr(jr),
        .upg_rst_i(upg_rst_i),
        .upg_clk_i(upg_clk),
        .upg_wen_i(upg_wen_i),
        .upg_adr_i(upg_adr_i),
        .upg_dat_i(upg_dat_i),
        .upg_done_i(upg_done_i)
    );
    
    control32 u_control(
        .opcode(instruction[31:26]),
        .function_opcode(instruction[5:0]),
        .alu_result_high(alu_result[31:10]),
        .jr(jr),
        .jmp(jmp),
        .jal(jal),
        .branch(branch),
        .n_branch(n_branch),
        .reg_dst(reg_dst),
        .mem_or_io_to_reg(mem_or_io_to_reg),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .sftmd(sftmd),
        .i_format(i_format),
        .alu_op(alu_op),
        .mem_read(mem_read),
        .io_read(io_read),
        .io_write(io_write)
    );
    
    executs32 u_alu(
        .zero(zero),
        .alu_result(alu_result),
        .addr_result(addr_result),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .imme_extend(imme_extend),
        .function_opcode(instruction[5:0]),
        .opcode(instruction[31:26]),
        .shamt(instruction[10:6]),
        .pc_plus_4(branch_base_addr),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .i_format(i_format),
        .sftmd(sftmd),
        .jr(jr)
    );
    
    mem_or_io u_chooser(
        .m_read(mem_read),
        .m_write(mem_write),
        .io_read(io_read),
        .io_write(io_write),
        .addr_in(alu_result),
        .m_rdata(ram_dat_o),
        .io_rdata(io_rdata),
        .r_rdata(read_data_2), // not sure about this
        .r_wdata(r_wdata),
        .addr_out(addr_out_mio),
        .write_data(write_data_mio),
        .led_ctrl(led_ctrl),
        .switch_ctrl(switch_ctrl)
    );
    
    idecode32 u_decode(
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .imme_extend(imme_extend),
        .instruction(instruction),
        .read_data(r_wdata),
        .alu_result(alu_result),
        .jal(jal),
        .reg_write(reg_write),
        .mem_to_reg(mem_or_io_to_reg),
        .reg_dst(reg_dst),
        .clock(cpu_clk),
        .reset(reset),
        .opcplus4(branche_base_addr)
    );
    
    dmemory32 u_mem(
        .ram_clk(cpu_clk),
        .ram_wen_i(mem_write),
        .ram_adr_i(addr_out_mio[13:0]),
        .ram_dat_i(write_data_mio),
        .ram_dat_o(ram_dat_o),
        .upg_rst_i(upg_rst_i),
        .upg_clk_i(upg_clk),
        .upg_wen_i(upg_wen_i),
        .upg_adr_i(upg_adr_i),
        .upg_dat_i(upg_dat_i),
        .upg_done_i(upg_done_i)
    );
endmodule
