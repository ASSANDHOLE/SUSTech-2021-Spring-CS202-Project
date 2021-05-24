`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/22 18:12:51
// Design Name: 
// Module Name: val17_to_seg_led
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


module val_to_seg_led(
    input fpga_clk, // fpga clock: 100 Mhz
    input reset, // active high
    input [31:0] val, // 17-bit input value(unsigned int, )
    input seg_cs,
    output reg [7:0] seg_en, // seven-seg-led enabling signal
    output reg [7:0] seg_out // seven-seg-led output signal
    );

    reg [4:0] nums [7:0];
    wire [7:0] leds [7:0];
    
    wire clk_1ms;

    integer i, m;
    reg has_first_digit;
    // reg [3:0] temp_nums [7:0];
    always @(val, reset) begin
        if(reset) begin
            for (i = 0; i < 8; i = i + 1) begin
                nums[i] = 5'h10;
            end
        end
        else if(seg_cs) begin
//            has_first_digit <= 0; // to drop zeros before the first real digit. i.e. "0034503" -> "__34503" where '_' represent print nothing
//            temp_nums[0] <= val[3:0];
//            temp_nums[1] <= val[7:4];
//            temp_nums[2] <= val[11:8];
//            temp_nums[3] <= val[16:12];
//            temp_nums[4] <= val[19:16];
//            temp_nums[5] <= val[23:20];
//            temp_nums[6] <= val[27:24];
//            temp_nums[7] <= val[31:28];
//            for (i = 7; i > 0; i = i - 1) begin
//                if (!has_first_digit) begin
//                    has_first_digit = temp_nums[i] != 4'b0;
//                    nums[i] = (temp_nums[i] == 4'b0) ? 5'b10000 : {1'b0, temp_nums[i]};
//                end
//                else begin
//                    nums[i] = {1'b0, temp_nums[i]};
//                end
//            end
//            nums[0] = {1'b0, temp_nums[0]};
            m = val[31:0];
            for (i = 0; i < 8; i = i + 1) begin
                nums[i] = m % 16;
                m = m / 16;
            end
        end
        else begin 
            for (i = 0; i < 8; i = i + 1) begin
                nums[i] = nums[i];
            end
        end
    end

    genvar	gi;								
    generate for(gi = 0; gi < 8; gi = gi + 1)		
	   begin : gfor						
	       num_to_seg_led num_to_seg_inst(
	           .num(nums[gi]),
		       .seg_led(leds[gi])
	       );
	   end
    endgenerate

    freq_div div(
        .raw_clk(fpga_clk),
        .rst_n(~reset),
        .clk_out(clk_t)
    );

    reg [3:0] count;
    
    always @ (posedge clk_t, posedge reset)begin
        if (reset) begin
            count <= 0;
        end
        else if (count == 7) begin
            count <= 0;
        end
        else begin
            count <= count + 1;
        end
    end
    
    always @(count) begin
        if (reset) begin
            seg_out <= 8'hff;
            seg_en <= 8'hff;
        end 
        else begin 
            case (count)
                3'b000: begin
                    seg_out <= leds[7];
                    seg_en <= 8'b0111_1111;
                end
                3'b001: begin
                    seg_out <= leds[6];
                    seg_en <= 8'b1011_1111;
                end
                3'b010: begin
                    seg_out <= leds[5];
                    seg_en <= 8'b1101_1111;
                end
                3'b011: begin
                    seg_out <= leds[4];
                    seg_en <= 8'b1110_1111;
                end
                3'b100: begin
                    seg_out <= leds[3];
                    seg_en <= 8'b1111_0111;
                end
                3'b101: begin
                    seg_out <= leds[2];
                    seg_en <= 8'b1111_1011;      
                end 
                3'b110: begin
                    seg_out <= leds[1];
                    seg_en <= 8'b1111_1101;      
                end 
                3'b111: begin
                    seg_out <= leds[0];
                    seg_en <= 8'b1111_1110;      
                end             
            endcase 
        end   
    end 
endmodule

module freq_div(
    input raw_clk,
    input rst_n,
    output reg clk_out
);

    parameter n = 100000; // 1ms
    
    reg [26:0] cnt;
    always @(posedge raw_clk, negedge rst_n) begin
        if (~rst_n) begin
            cnt <= 0;
            clk_out <= 0;
        end
        else begin
            if(cnt == ((n >> 1) - 1)) begin
                clk_out <= ~clk_out;
                cnt <= 0;
            end
            else begin
                cnt <= cnt+1;
            end
        end
    end

endmodule
