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
    output reg[31:0] F_PC
    );
	 wire [31:0]pc;
	 assign pc = F_PC - 32'h0000_3000;
	 integer i;
    
	 always@(posedge clk)begin
	     if(reset == 1)begin
		      F_PC <= 32'h0000_3000;
		  end
		  else if(F_en == 1)begin
		      F_PC <= NPC;
		  end
	 end
endmodule
