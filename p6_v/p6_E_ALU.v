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
    output reg[31:0] out,
	 output  ALU_check,
    input [3:0] ALUOp
    );
  
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
		  else if(ALUOp == 4'b0110)begin
		      out = (ALU_B - 32'd4);
		  end
	 end
    assign ALU_check = 1'd0;
endmodule
