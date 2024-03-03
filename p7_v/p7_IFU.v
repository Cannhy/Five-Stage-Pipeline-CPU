`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:40:21 11/07/2022 
// Design Name: 
// Module Name:    p5_IFU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module IFU(
    input clk,
    input F_en,
	 input reset,
    input [31:0] NPC,
	 input D_eret,
	 input [31:0] EPC,
	 input Req,
    output [31:0] F_PC,
	 output F_AdEL
    );

	 integer i;
	 reg [31:0] pc;
	 
    initial begin
	     pc = 32'h0000_3000;
	 end
	 assign F_PC = (D_eret == 1)? EPC : pc;
	 assign F_AdEL = ((F_PC[1:0] != 2'b00) || (F_PC < 32'h0000_3000) || (F_PC > 32'h0000_6ffc) )? 1 : 0;
	 
	 always@(posedge clk)begin
	     if(reset == 1)begin
		      pc <= 32'h0000_3000;
		  end
		  else if(F_en == 1 || Req == 1)begin
		      pc <= NPC;
		  end
	 end
endmodule
