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
    input led_clk,    		    // ʱ���ź�
    input led_rst, 		        // ��λ�ź�
    input led_write,		       	// д�ź�
    input led_cs,		      	// ��memorio����LEDƬѡ�ź�   !!!!!!!!!!!!!!!!!
    input [1:0] led_addr,	        //  ��LEDģ��ĵ�ַ�Ͷ�  !!!!!!!!!!!!!!!!!!!!
    input [15:0] led_wdata,	  	//  д��LEDģ������ݣ�ע��������ֻ��16��
    
    output reg [23:0] led_out		//  ������������24λLED�ź�
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
