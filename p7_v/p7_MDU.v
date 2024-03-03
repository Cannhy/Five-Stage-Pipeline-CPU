`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:03:06 11/15/2022 
// Design Name: 
// Module Name:    p6_MDU 
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
module MDU(
    input clk,
	 input reset,
    input [31:0] D1,
	 input [31:0] D2,
	 input [3:0] MDUOp,
	 input Req,
	 output  start,
	 output reg busy,
	 output reg [31:0] hi,
	 output reg [31:0] lo,
	 output [31:0] out
    );
    reg [31:0] tmp_hi, tmp_lo;
	 reg [3:0] cnt;
	 wire mult, multu, div, divu, mfhi, mflo, mthi, mtlo;
	 
	 assign mult = (MDUOp == 4'd1);
	 assign multu = (MDUOp == 4'd2);
	 assign div = (MDUOp == 4'd3);
	 assign divu = (MDUOp == 4'd4);
	 assign mfhi = (MDUOp == 4'd5);
	 assign mflo = (MDUOp == 4'd6);
	 assign mthi = (MDUOp == 4'd7);
	 assign mtlo = (MDUOp == 4'd8);
	 
	 assign start = Req? 0 : (mult | multu| div | divu);
	 
	 initial begin
	     cnt <= 4'd0;
		  tmp_hi <= 32'd0;
		  hi <= 32'd0;
		  lo <= 32'd0;
		  tmp_lo <= 32'd0;
		  busy <= 0;
	 end
	 always@(posedge clk)begin
	     if(reset == 1)begin
		      cnt <= 4'd0;
				tmp_hi <= 32'd0;
				tmp_lo <= 32'd0;
				busy <= 0 ;
		  end
		  else if (Req != 1)begin
		      if(cnt == 4'd0)begin
				    if(mult == 1)begin
					     busy <= 1;
						  {tmp_hi,tmp_lo} <= $signed(D1)*$signed(D2);
						  cnt <= 4'd5;
					 end
					 else if(multu == 1)begin
					     busy <= 1;
						  {tmp_hi,tmp_lo} <= D1*D2;
						  cnt <= 4'd5;
					 end
					 else if(div == 1)begin
					     busy <= 1;
						  tmp_hi <= D2? $signed($signed(D1)%$signed(D2)) : hi;
						  tmp_lo <= D2? $signed($signed(D1)/$signed(D2)): lo;
						  cnt <= 4'd10;
					 end
					 else if(divu == 1)begin
					     busy <= 1;
						  tmp_hi <= D2? D1%D2 : hi;
						  tmp_lo <= D2? D1/D2 : lo;
						  cnt <= 4'd10;
					 end
					 else if(mthi == 1)begin
					     hi <= D1;
						  cnt <= 4'd0;
					 end
					 else if(mtlo == 1)begin
					     lo <= D1;
						  cnt <= 4'd0;
					 end
				end
		      else if(cnt == 4'd1)begin
				    busy <= 0;
					 cnt <= 0;
					 hi <= tmp_hi;
					 lo <= tmp_lo;
				end
				else begin
				    cnt <= cnt - 1;
				end
	 end
	 end
	 assign out = (mfhi == 1)? hi : (mflo == 1)? lo : 32'd0;
endmodule
