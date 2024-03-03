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
	 input [2:0] b_type,
    output zero
    );
    assign zero = ((b_type == 3'd0) && (D_Rs == D_Rt))? 1 : 
	               ((b_type == 3'd1) && (D_Rs != D_Rt))? 1 : 0;
	 
endmodule
