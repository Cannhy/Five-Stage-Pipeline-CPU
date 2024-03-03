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
	 input [31:0] M_MDU_out,
    input clk,
    input reset,
	 input M_CMP_result,
	 input M_DM_judge,
	 input [31:0]M_V2,
	 input [31:0]M_V1,
	 input M_ALU_check,
	 output reg W_ALU_check,
	 output reg [31:0] W_V1,
	 output reg [31:0]W_V2,
	 output reg W_DM_judge,
	 output reg W_CMP_result,
    output reg[31:0] W_Instr,
    output reg[31:0] W_data,
	 output reg[4:0] W_A3,
	 output reg [31:0] W_MDU_out,
    output reg[31:0] W_PC,
    output reg[31:0] W_ALU_result
    );
    always@(posedge clk)begin
	     if(reset == 1)begin
		      W_Instr <= 0;
				W_data <= 0;
				W_PC <= 0;
				W_ALU_result <= 0;
				W_A3 <= 0;
				W_MDU_out <= 0;
				W_CMP_result <= 0;
				W_DM_judge <= 0;
				W_V2 <= 0;
				W_V1 <= 0;
				W_ALU_check <= 0;
		  end
		  else begin
		      W_Instr <= M_Instr;
				W_data <= M_data;
				W_PC <= M_PC;
				W_ALU_result <= M_ALU_result;
				W_A3 <= M_A3;
				W_MDU_out <= M_MDU_out;
				W_CMP_result <= M_CMP_result;
				W_DM_judge <= M_DM_judge;
				W_V2 <= M_V2;
				W_V1 <= M_V1;
				W_ALU_check <= M_ALU_check;
		  end
	 end

endmodule
