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
    input fpga_reset,
    input start_pg,
    input rx,
    output tx,
    input [23:0] switch_in,
    output [23:0] led_out,    
    output [7:0] seg_en,
    output [7:0] seg_out
);
    
    wire reset;
    wire upg_clk;
    reg upg_rst; // wire upg_rst_i; // UPG reset (Active High)
    wire upg_wen_o; // UPG write enable
    wire [14:0] upg_adr_o; // UPG write address
    wire [31:0] upg_dat_o; // UPG write data
    wire upg_done_o; // 1 if program finished
    wire upg_clk_o;
    wire spg_bufg;
    BUFG u_bufg(
        .I(start_pg),
        .O(spg_bufg)
    );    
    
    always @(posedge clock) begin
        if (spg_bufg) begin
            upg_rst = 0;
        end
        if (fpga_reset) begin
            upg_rst = 1;
        end
    end    
    assign reset = fpga_reset | !upg_rst;
    
    wire alu_src;
    wire branch;
    wire cpu_clk;
    wire i_format;
    wire io_read;
    wire io_write;
    wire jal;
    wire jmp;
    wire jr;
    wire led_ctrl;
    wire mem_or_io_to_reg;
    wire mem_read;
    wire mem_write;
    wire n_branch;
    wire reg_dst;
    wire reg_write;
    wire seg_ctrl;
    wire sftmd;
    wire switch_ctrl;
    
    wire zero;

    wire [1:0] alu_op;
    
    wire [15:0] io_rdata;
    
    wire [31:0] addr_out_mio;
    wire [31:0] addr_result;
    wire [31:0] alu_result;
    wire [31:0] branch_base_addr;
    wire [31:0] imme_extend;
    wire [31:0] instruction;
    wire [31:0] link_addr;
    wire [31:0] pco;
    wire [31:0] ram_dat_o;
    wire [31:0] read_data_1;
    wire [31:0] read_data_2;
    wire [31:0] r_wdata;
    wire [31:0] write_data_mio;

    leds u_leds(
        .led_clk(cpu_clk),
        .led_rst(reset),
        .led_write(io_write),
        .led_cs(led_ctrl),
        .led_addr(addr_out_mio[1:0]),
        .led_wdata(write_data_mio[15:0]),
        .led_out(led_out)
    );
    
    switchs u_switches(
        .switch_clk(cpu_clk),
        .switch_rst(reset),
        .switch_cs(switch_ctrl),
        .switch_addr(addr_out_mio[1:0]),
        .switch_read(io_read),
        .switch_i(switch_in),
        .switch_rdata(io_rdata)
    );
    
    val_to_seg_led u_seg_led(
        .fpga_clk(clock),
        .reset(reset),
        .val(write_data_mio),
        .seg_cs(seg_ctrl),
        .seg_en(seg_en),
        .seg_out(seg_out)
    );
    
    cpuclk u_clk(
        .clk_in1(clock),
        .clk_out1(cpu_clk),
        .clk_out2(upg_clk)
    );
    
    ifetc32 u_ifetch(
        .instruction_i(instruction),
        .branch_base_addr(branch_base_addr),
        .link_addr(link_addr),
        .pco(pco),
        .clock(cpu_clk),
        .reset(reset),
        .addr_result(addr_result),
        .zero(zero),
        .read_data_1(read_data_1),
        .branch(branch),
        .n_branch(n_branch),
        .jmp(jmp),
        .jal(jal),
        .jr(jr)
    );
    
    program_rom u_rom(
        .rom_clk_i(cpu_clk),
        .instruction_o(instruction),
        .rom_adr_i(pco[15:2]),
        .upg_rst_i(upg_rst),
        .upg_clk_i(upg_clk_o),
        .upg_wen_i(upg_wen_o & (!upg_adr_o[14])),
        .upg_adr_i(upg_adr_o[13:0]),
        .upg_dat_i(upg_dat_o),
        .upg_done_i(upg_done_o)
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
        .r_rdata(read_data_2),
        .r_wdata(r_wdata),
        .addr_out(addr_out_mio),
        .write_data(write_data_mio),
        .led_ctrl(led_ctrl),
        .seg_ctrl(seg_ctrl),
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
        .opcplus4(link_addr)
    );
    
    dmemory32 u_mem(
        .ram_clk_i(cpu_clk),
        .ram_wen_i(mem_write),
        .ram_adr_i(addr_out_mio[13:0]),
        .ram_dat_i(write_data_mio),
        .ram_dat_o(ram_dat_o),

        .upg_rst_i(upg_rst),
        .upg_clk_i(upg_clk_o),
        .upg_wen_i(upg_wen_o & upg_adr_o[14]),
        .upg_adr_i(upg_adr_o[13:0]),
        .upg_dat_i(upg_dat_o),
        .upg_done_i(upg_done_o)
    );
    
    
    
    uart_bmpg_0 u_upg(
        .upg_clk_i(upg_clk),
        .upg_rst_i(upg_rst),
        .upg_rx_i(rx),

        .upg_clk_o(upg_clk_o),
        .upg_wen_o(upg_wen_o),
        .upg_adr_o(upg_adr_o),
        .upg_dat_o(upg_dat_o),
        .upg_done_o(upg_done_o),
        .upg_tx_o(tx)
    );
    
   
 
endmodule