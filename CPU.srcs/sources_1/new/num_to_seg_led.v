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
        input [3:0] num,
        output reg [7:0] seg_led
    );

    always @(*) begin
        case(num)
            0: seg_led<=8'b11000000; 
            1: seg_led<=8'b11111001;
            2: seg_led<=8'b10100100;
            3: seg_led<=8'b10110000;
            4: seg_led<=8'b10011001;
            5: seg_led<=8'b10010010;
            6: seg_led<=8'b10000010;
            7: seg_led<=8'b11111000;
            8: seg_led<=8'b10000000;
            9: seg_led<=8'b10010000;
        endcase
    end
 
endmodule
