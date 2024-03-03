`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:19:08 11/07/2022 
// Design Name: 
// Module Name:    E_Reg 
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
module E_Reg(
    input [4:0] D_A3,
	 input clk,
	 input reset,
    input [31:0] D_Instr,
    input [31:0] D_imm,
    input [4:0] D_A1,
    input [31:0] D_V1,
	 input [31:0] D_V2,
	 input [31:0] D_PC,
	 input [31:0] D_Ext_lui,
	 input D_CMP_result,
	 output reg E_CMP_result,
	 output reg[4:0] E_A3,
	 output reg[31:0] E_PC,
	 output reg[31:0] E_V2,
    output reg[31:0] E_Instr,
    output reg[31:0] E_imm,
    output reg[4:0] E_A1,
    output reg[31:0] E_V1
    );
    always@(posedge clk)begin
	     if(reset == 1)begin
		      E_A3 <= 0;
				E_Instr <= 0;
				E_A1 <= 0;
				E_V1 <= 0;
				E_PC <= 0;
				E_V2 <= 0;
				E_imm <= 0;
				E_CMP_result <= 0;
		  end
		  else begin
		      E_A3 <= D_A3;
				E_V2 <= D_V2;
				E_Instr <= D_Instr;
				E_A1 <= D_A1;
				E_V1 <= D_V1;
				E_PC <= D_PC;
				E_imm <= D_imm;
				E_CMP_result <= D_CMP_result;
		  end
	 end

endmodule
