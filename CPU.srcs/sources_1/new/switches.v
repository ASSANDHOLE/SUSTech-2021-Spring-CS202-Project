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
    input switch_clk,			        //  时钟信号
    input switch_rst,			        //  复位信号
    input switch_cs,			        //从memorio来的switch片选信号  !!!!!!!!!!!!!!!!!
    input [1:0] switch_addr, 	    //  到switch模块的地址低端  !!!!!!!!!!!!!!!
    input switch_read,			    //  读信号
    input [23:0] switch_i,		    //  从板上读的24位开关数据
    
    output reg [15:0] switch_rdata	    //  送到CPU的拨码开关值注意数据总线只有16根
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
