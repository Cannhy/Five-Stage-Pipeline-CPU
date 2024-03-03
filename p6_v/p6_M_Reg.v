`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:21:57 11/07/2022 
// Design Name: 
// Module Name:    M_Reg 
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
module M_Reg(
    input [31:0] E_Instr,
	 input clk,
	 input reset,
    input [31:0] E_ALU_result,
    input [31:0] E_PC,
	 input [31:0] E_V1,
    input [31:0] E_V2,
	 input [4:0] E_A3,
	 input [31:0] E_MDU_out,
	 input E_CMP_result,
	 input E_ALU_check,
	 output reg M_ALU_check,
	 output reg M_CMP_result,
    output reg[31:0] M_Instr,
	 output reg[31:0] M_MDU_out,
    output reg[31:0] M_PC,
	 output reg[4:0] M_A3,
    output reg[31:0] M_ALU_result,
    output reg[31:0] M_V2,
	 output reg [31:0] M_V1
    );
    always@(posedge clk)begin
	     if(reset == 1)begin
		      M_Instr <= 0;
				M_PC <= 0;
				M_ALU_result <= 0;
				M_V2 <= 0;
				M_V1 <= 0;
				M_A3 <= 0;
				M_MDU_out <= 0;
				M_CMP_result <=0;
				M_ALU_check <= 0;
		  end
		  else begin
		      M_Instr <= E_Instr;
				M_PC <= E_PC;
				M_ALU_result <= E_ALU_result;
				M_V2 <= E_V2;
				M_A3 <= E_A3;
				M_V1 <= E_V1;
				M_MDU_out <= E_MDU_out;
				M_CMP_result <= E_CMP_result;
				M_ALU_check <= E_ALU_check;
		  end
	 end

endmodule
