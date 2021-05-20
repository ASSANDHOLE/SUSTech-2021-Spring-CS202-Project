`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 21:43:37
// Design Name: 
// Module Name: switches
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

module switchs(
    input switch_clk,			        //  ʱ���ź�
    input switch_rst,			        //  ��λ�ź�
    input switch_cs,			        //��memorio����switchƬѡ�ź�  !!!!!!!!!!!!!!!!!
    input [1:0] switch_addr, 	    //  ��switchģ��ĵ�ַ�Ͷ�  !!!!!!!!!!!!!!!
    input switch_read,			    //  ���ź�
    input [23:0] switch_i,		    //  �Ӱ��϶���24λ��������
    
    output reg [15:0] switch_rdata	    //  �͵�CPU�Ĳ��뿪��ֵע����������ֻ��16��
);
    // write by teacher
    // reg [23:0] switch_rdata;

    always@(negedge switch_clk or posedge switch_rst) begin
        if(switch_rst) begin
            switch_rdata <= 0;
        end
		else if(switch_cs && switch_read) begin
			if(switch_addr == 2'b00)
				switch_rdata[15:0] <= switch_i[15:0];   // data output,lower 16 bits non-extended
			else if(switch_addr == 2'b10)
				switch_rdata[15:0] <= {8'h00, switch_i[23:16]}; //data output, upper 8 bits extended with zero
			else 
				switch_rdata <= switch_rdata;
        end
		else begin
            switch_rdata <= switch_rdata;
        end
    end
endmodule
