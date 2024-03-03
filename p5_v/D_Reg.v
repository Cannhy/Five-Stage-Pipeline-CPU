`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:05:16 11/07/2022 
// Design Name: 
// Module Name:    D_Reg 
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
module D_Reg(
    input [31:0] F_Instr,
    input clk,
    input en,
	 input reset,
    input [31:0] F_PC,
    output reg[31:0] D_Instr,
    output reg[31:0] D_PC
    );
    always@(posedge clk)begin
	     if(reset == 1)begin
		      D_Instr <= 32'd0;
				D_PC <= 32'd0;
		  end
		  else if(en == 1)begin
		      D_Instr <= F_Instr;
				D_PC <= F_PC;
		  end
	 end

endmodule
