`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:14:51 11/07/2022 
// Design Name: 
// Module Name:    D_RF 
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
module D_RF(
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
    input clk,
    input reset,
    input WE,
	 input [31:0] WPC,
    output [31:0] RD1,
    output [31:0] RD2
    );
	 integer i;
	 reg [31:0] grf [31:0];
    initial begin
	     for(i=0;i<32;i=i+1)begin
		      grf[i] = 32'd0;
		  end
	 end
    always@(posedge clk)begin
	     if(reset == 1)begin
		      for(i=0;i<32;i=i+1)begin
		          grf[i] <= 32'd0;
		      end
		  end
		  else if(WE == 1 && A3 != 5'b0)begin
		      grf[A3] <= WD;
		  end
	 end
	 assign RD1 = (A1 == 5'd0)? 32'd0 : 
	              (A1 == A3 && WE == 1)? WD : grf[A1];
	 assign RD2 = (A2 == 5'd0)? 32'd0 : 
	              (A2 == A3 && WE == 1)? WD : grf[A2];
endmodule
