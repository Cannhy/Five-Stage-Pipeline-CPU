`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:31:47 11/07/2022 
// Design Name: 
// Module Name:    W_Reg 
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
module W_Reg(
    input [31:0] M_Instr,
    input [31:0] M_PC,
    input [4:0] M_A3,
    input [31:0] M_ALU_result,
	 input [31:0] M_data,
	 input M_jump,
	 input M_judge,
	 input [31:0] M_V2,
    input clk,
    input reset,
	 output reg [31:0] W_V2,
    output reg[31:0] W_Instr,
    output reg[31:0] W_data,
	 output reg[4:0] W_A3,
    output reg[31:0] W_PC,
	 output reg W_judge,
    output reg[31:0] W_ALU_result,
	 output reg W_jump
    );
    always@(posedge clk)begin
	     if(reset == 1)begin
		      W_Instr <= 0;
				W_data <= 0;
				W_PC <= 0;
				W_ALU_result <= 0;
				W_A3 <= 0;
				W_jump <= 0;
				W_V2 <= 0;
				W_judge <= 0;
		  end
		  else begin
		      W_Instr <= M_Instr;
				W_data <= M_data;
				W_PC <= M_PC;
				W_ALU_result <= M_ALU_result;
				W_A3 <= M_A3;
				W_jump <= M_jump;
				W_V2 <= M_V2;
				W_judge <= M_judge;
		  end
	 end

endmodule
