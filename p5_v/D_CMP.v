`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:07:43 11/07/2022 
// Design Name: 
// Module Name:    D_CMP 
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
module D_CMP(
    input [31:0] D_Rs,
    input [31:0] D_Rt,
	 output jump,
    output zero
    );
	 integer i;
	 wire [32:0] A, B, temp;
	 reg flag;
	 initial begin
	     flag = 1;
	 end
    assign zero = (D_Rs == D_Rt)? 1 : 0;
	 
	 assign A = {D_Rs[31], D_Rs};
	 assign B = {D_Rt[31], D_Rt};
	 assign temp = A + B;
	 
	 always@(*)begin
	         flag = 1;
	     for(i=0;i<16; i=i+1)begin
		      if(D_Rs[i] != D_Rs[31-i])begin
				    flag = 0;
				end
		  end
	 end
    assign jump = (temp[32] != temp[31])? 1'd1 : 1'd0;
	 
endmodule