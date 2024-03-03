`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:11:42 11/07/2022 
// Design Name: 
// Module Name:    E_ALU 
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
module E_ALU(
    input [31:0] ALU_A,
    input [31:0] ALU_B,
	 input ALU_cal_ov,
	 input ALU_DM_ov,
	 output  E_cal_ov,
	 output  E_DM_ov,
    output reg[31:0] out,
    input [3:0] ALUOp
    );
    wire [32:0] exA, exB;
	 wire [32:0] add, sub;
	 always @(*)begin
	     if(ALUOp == 4'b0000) begin
		      out = (ALU_A + ALU_B);
		  end
		  else if(ALUOp == 4'b0001) begin
		      out = (ALU_A - ALU_B);
		  end
		  else if(ALUOp == 4'b0010) begin
		      out = ALU_A | ALU_B;
		  end
		  else if(ALUOp == 4'b0011) begin
		      out = ALU_A & ALU_B;
		  end
		  else if(ALUOp == 4'b0100) begin
		      out = ($signed(ALU_A)<$signed(ALU_B))? 32'd1 : 32'd0;
		  end
		  else if(ALUOp == 4'b0101) begin
		      out = (ALU_A<ALU_B)? 32'd1 : 32'd0;
		  end
	 end
    assign exA = {ALU_A[31],ALU_A};
	 assign exB = {ALU_B[31],ALU_B};
	 assign add = exA + exB;
	 assign sub = exA - exB;
	 assign E_cal_ov = (ALU_cal_ov == 1) && (((ALUOp == 4'b000) && (add[32] != add[31])) || ((ALUOp == 4'b0001) && (sub[32] != sub[31])));
	 assign E_DM_ov = (ALU_DM_ov == 1) && (((ALUOp == 4'b000) && (add[32] != add[31])) || ((ALUOp == 4'b0001) && (sub[32] != sub[31])));
endmodule
