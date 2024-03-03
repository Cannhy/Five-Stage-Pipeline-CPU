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
    input [31:0] E_V2,
	 input [31:0] E_MDU_out,
	 input E_cmp_result,
	 input [4:0] E_EXCcode,
	 input E_BD,
	 input E_DM_ov,
	 input Req,
	 output reg M_cmp_result,
	 output reg [4:0] M_EXCcode,
	 output reg M_BD,
	 output reg M_DM_ov,
    output reg[31:0] M_Instr,
	 output reg[31:0] M_MDU_out,
    output reg[31:0] M_PC,
    output reg[31:0] M_ALU_result,
    output reg[31:0] M_V2
    );
    always@(posedge clk)begin
	     if(reset == 1 || Req == 1)begin
		      M_Instr <= 0;
				M_PC <= Req? 32'h0000_4180 : 0;
				M_ALU_result <= 0;
				M_V2 <= 0;
				M_MDU_out <= 0;
				M_cmp_result <= 0;
				M_BD <= 0;
				M_DM_ov <= 0;
				M_EXCcode <= 0;
		  end
		  else begin
		      M_Instr <= E_Instr;
				M_PC <= E_PC;
				M_ALU_result <= E_ALU_result;
				M_V2 <= E_V2;
				M_MDU_out <= E_MDU_out;
				M_cmp_result <= E_cmp_result;
				M_BD <= E_BD;
				M_DM_ov <= E_DM_ov;
				M_EXCcode <= E_EXCcode;
		  end
	 end

endmodule
