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
    input [31:0] M_ALU_result,
	 input [31:0] M_data,
	 input [31:0] M_MDU_out,
    input clk,
    input reset,
	 input Req,
	 input [31:0]M_CP0,
    output reg[31:0] W_Instr,
	 output reg [31:0] W_CP0,
    output reg[31:0] W_data,
	 output reg [31:0] W_MDU_out,
    output reg[31:0] W_PC,
    output reg[31:0] W_ALU_result
    );
    always@(posedge clk)begin
	     if(reset == 1 || Req)begin
		      W_Instr <= 0;
				W_data <= 0;
				W_PC <= Req? 32'h0000_4180 : 0;
				W_ALU_result <= 0;
				W_CP0 <= 0;
				W_MDU_out <= 0;
				end
		   else begin
		      W_Instr <= M_Instr;
				W_data <= M_data;
				W_PC <= M_PC;
				W_ALU_result <= M_ALU_result;
				W_CP0 <= M_CP0;
				W_MDU_out <= M_MDU_out;
		  end
	 end

endmodule