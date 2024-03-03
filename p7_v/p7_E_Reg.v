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

	 input clk,
	 input reset,
    input [31:0] D_Instr,
    input [31:0] D_imm,
    input [31:0] D_V1,
	 input [31:0] D_V2,
	 input [31:0] D_PC,
	 input [31:0] D_Ext_lui,
	 input [4:0] D_EXCcode,
	 input D_BD,
	 input Req,
	 input stall,
	 input D_cmp_result,
	 output reg E_BD,
	 output reg [4:0] E_EXCcode,
	 output reg E_cmp_result,
	 output reg[4:0] E_A3,
	 output reg[31:0] E_PC,
	 output reg[31:0] E_V2,
    output reg[31:0] E_Instr,
    output reg[31:0] E_imm,
    output reg[31:0] E_V1
    );
    always@(posedge clk)begin
	     if(reset == 1 || Req == 1 || stall == 1)begin
		
				E_Instr <= 0;
				E_V1 <= 0;
				E_PC <= Req? 32'h0000_4180 : (stall? D_PC : 32'd0);
				//E_PC <= stall? D_PC : (Req? 32'h0000_4180 : 32'd0);
				E_V2 <= 0;
				E_imm <= 0;
				E_EXCcode <= 0;
				E_BD <= reset? 0 : Req? 0 : stall ? D_BD : 0;
				E_cmp_result <= 0;
				
		  end
		  else begin
				E_V2 <= D_V2;
				E_Instr <= D_Instr;
				E_V1 <= D_V1;
				E_PC <= D_PC;
				E_imm <= D_imm;
				E_EXCcode <= D_EXCcode;
				E_BD <= D_BD;
				E_cmp_result <= D_cmp_result;
		  end
	 end

endmodule
