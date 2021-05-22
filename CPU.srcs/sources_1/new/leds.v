`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 23:12:19
// Design Name: 
// Module Name: leds
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


module leds(
    input led_clk,    		    // 时钟信号
    input led_rst, 		        // 复位信号
    input led_write,		       	// 写信号
    input led_cs,		      	// 从memorio来的LED片选信号   !!!!!!!!!!!!!!!!!
    input [1:0] led_addr,	        //  到LED模块的地址低端  !!!!!!!!!!!!!!!!!!!!
    input [15:0] led_wdata,	  	//  写到LED模块的数据，注意数据线只有16根
    
    output reg [23:0] led_out		//  向板子上输出的24位LED信号
 ); 
    
//	 write by teacher
//     reg [23:0] led_out;
    
    always @(posedge led_clk or posedge led_rst) begin
        if (led_rst) begin
            led_out <= 24'h000000;
        end
		else if (led_cs && led_write) begin
			if (led_addr == 2'b00) begin
				led_out[23:0] <= {led_out[23], led_out[22:16], led_wdata[15:0]};
		    end
			else if (led_addr == 2'b10) begin
				led_out[23:0] <= {led_out[23], led_wdata[7:0], led_out[15:0]};
			end
			else begin
				led_out <= led_out;
			end
        end
		else begin
            led_out <= led_out;
        end
    end
    
    
endmodule
