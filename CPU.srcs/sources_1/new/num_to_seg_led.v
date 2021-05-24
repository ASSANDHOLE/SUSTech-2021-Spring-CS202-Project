`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/22 17:16:35
// Design Name: 
// Module Name: num_to_seg_led
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


module num_to_seg_led(
    input [4:0] num,
    output reg [7:0] seg_led
);

    always @* begin
        case(num)
            5'h0: seg_led <= 8'b1100_0000; 
            5'h1: seg_led <= 8'b1111_1001;
            5'h2: seg_led <= 8'b1010_0100;
            5'h3: seg_led <= 8'b1011_0000;
            5'h4: seg_led <= 8'b1001_1001;
            5'h5: seg_led <= 8'b1001_0010;
            5'h6: seg_led <= 8'b1000_0010;
            5'h7: seg_led <= 8'b1111_1000;
            5'h8: seg_led <= 8'b1000_0000;
            5'h9: seg_led <= 8'b1001_0000;
            5'hA: seg_led <= 8'b1000_1000;
            5'hB: seg_led <= 8'b1000_0011;
            5'hC: seg_led <= 8'b1100_0110;
            5'hD: seg_led <= 8'b1010_0001;
            5'hE: seg_led <= 8'b1000_0110;
            5'hF: seg_led <= 8'b1000_1110;
            5'h10: seg_led <= 8'b1111_1111;
            default: seg_led <= 8'hFF;
        endcase
    end
endmodule
