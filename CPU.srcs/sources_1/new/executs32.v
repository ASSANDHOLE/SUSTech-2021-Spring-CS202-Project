`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 20:06:37
// Design Name: 
// Module Name: executs32
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


module executs32(
    output zero, // 1 means the alu_reslut is zero, 0 otherwise
    output reg [31:0] alu_result, // the ALU calculation result
    output [31:0] addr_result, // the calculated instruction address
// from decoder
    input [31:0] read_data_1, //the source of Ainput
    input [31:0] read_data_2, //one of the sources of Binput
    input [31:0] imme_extend, //one of the sources of Binput
// from ifetch
    input [5:0] function_opcode, //instructions[5:0]
    input [5:0] opcode, //instruction[31:26]
    input [4:0] shamt, // instruction[10:6], the amount of shift bits
    input [31:0] pc_plus_4, // pc+4
// from controller
    input [1:0] alu_op, //{ (R_format || i_format) , (Branch || nBranch) }
    input alu_src, // 1 means the 2nd operand is an immedite (except beq£¬bne£©
    input i_format, // 1 means I-Type instruction except beq, bne, LW, SW
    input sftmd, // 1 means this is a shift instruction
    input jr // 1 means this is
);

    wire signed [31:0] a_input,b_input; // two operands for calculation
    wire [31:0] a_unsign, b_unsign;
    wire [5:0] exe_code; // use to generate ALU_ctrl. (i_format==0) ? function_opcode : { 3'b000 , Opcode[2:0] };
    wire [2:0] alu_ctl; // the control signals which affact operation in ALU directely
    wire [2:0] sftm; // identify the types of shift instruction, equals to function_opcode[2:0]
    reg [31:0] alu_output_mux; // the result of arithmetic or logic calculation
    reg [31:0] shift_result; // the result of shift operation
    wire [32:0] branch_addr; // the calculated address of the instruction, addr_result is Branch_Addr[31:0]
    
    assign a_input = read_data_1;
    assign b_input = alu_src ? imme_extend : read_data_2;
    assign a_unsign = a_input;
    assign b_unsign = b_input;
	
	assign sftm = function_opcode[2:0];
    
    assign exe_code = i_format ? {3'b000, opcode[2:0]} : function_opcode;
    assign alu_ctl[0] = (exe_code[0] | exe_code[3]) & alu_op[1];
    assign alu_ctl[1] = (!exe_code[2]) | (!alu_op[1]);
    assign alu_ctl[2] = (exe_code[1] & alu_op[1]) | alu_op[0];
    
    always @(alu_ctl or a_input or b_input) begin
        case (alu_ctl)
            3'b000: alu_output_mux = a_input & b_input;
            3'b001: alu_output_mux = a_input | b_input;
            3'b010: alu_output_mux = a_input + b_input;
            3'b011: alu_output_mux = a_unsign + b_unsign;
            3'b100: alu_output_mux = a_input ^ b_input;
            3'b101: alu_output_mux = ~(a_input | b_input);
            3'b110: alu_output_mux = a_input - b_input;
            3'b111: alu_output_mux = a_input - b_input;
            default: alu_output_mux = 0;
        endcase
    end

    always @* begin
        if (sftmd) begin
            case(sftm[2:0])
                3'b000:shift_result = b_unsign << shamt; //Sll rd,rt,shamt 00000
                3'b010:shift_result = b_unsign >> shamt; //Srl rd,rt,shamt 00010
                3'b100:shift_result = b_unsign << a_unsign; //Sllv rd,rt,rs 000100
                3'b110:shift_result = b_unsign >> a_unsign; //Srlv rd,rt,rs 000110
                3'b011:shift_result = $signed(b_input) >>> shamt; //Sra rd,rt,shamt 00011
                3'b111:shift_result = $signed(b_input) >>> a_unsign; //Srav rd,rt,rs 00111
                default:shift_result = b_unsign;
            endcase
        end
        else begin
            shift_result = b_unsign;
        end
    end
    
    always @* begin
        if (((alu_ctl == 3'b111) && (exe_code[3])) || ((alu_ctl[2:1] == 2'b11) && (i_format))) begin
            alu_result = a_input - b_input < 0;
        end
        else if ((alu_ctl == 3'b101) && (i_format)) begin
            alu_result[31:0] = {b_input[15:0], {16{1'b0}}};
        end
        else if (sftmd) begin
            alu_result = shift_result;
        end
        else begin
            alu_result = alu_output_mux[31:0];
        end
    end
    
    assign zero = (alu_output_mux[31:0] == 0);
	assign branch_addr = pc_plus_4[31:2] + $signed(imme_extend);
    assign addr_result = branch_addr[31:0];
    
    // debug
    assign ai = a_input;
    assign bi = b_input;
endmodule
