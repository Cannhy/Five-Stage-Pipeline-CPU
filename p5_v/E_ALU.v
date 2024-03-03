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
    input [31:0] ALU_A, //rs
    input [31:0] ALU_B, // rt
    output reg [31:0] out,
    input [2:0] ALUOp
    );
	 wire [4:0] s;
	 integer i;
	 reg [31:0] result;
	 wire [32:0] A, B, temp;
	 assign s = ALU_B[4:0];
	 assign A = {ALU_A[31], ALU_A};
	 assign B = {ALU_B[31], ALU_B};
	 assign temp = A + B;

	 
	 always@(*)begin
	     if(ALUOp == 3'b000)begin
		      out = ALU_A + ALU_B;
		  end
		  else if(ALUOp == 3'b001)begin
		      out = ALU_A - ALU_B;
		  end
		  else if(ALUOp == 3'b010)begin
		      out = ALU_A | ALU_B;
		  end
		  else if(ALUOp == 3'b011)begin
		      if(temp[32] == temp[31])begin
				    out = temp[31:0];
				end
				else begin
				    out = ALU_B;
				end
		  end
		  else out = 32'd0;
	 end

endmodule
