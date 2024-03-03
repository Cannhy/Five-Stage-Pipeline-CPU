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
	 output  start,
	 output reg busy,
	 output reg [31:0] hi,
	 output reg [31:0] lo,
	 output [31:0] out
    );
    reg [31:0] tmp_hi, tmp_lo;
	 reg [3:0] cnt;
	 wire mult, multu, div, divu, mfhi, mflo, mthi, mtlo, bds;
	 wire shl;
	 reg tag;
	 wire check;
	 wire [32:0] rs, rt;
	 
	 always@(*)begin
	     if(shl == 1)begin
		      tag = tag + 1'd1;
		  end
		  else tag = tag;
	 end
	 
	 assign mult = (MDUOp == 4'd1);
	 assign multu = (MDUOp == 4'd2);
	 assign div = (MDUOp == 4'd3);
	 assign divu = (MDUOp == 4'd4);
	 assign mfhi = (MDUOp == 4'd5);
	 assign mflo = (MDUOp == 4'd6);
	 assign mthi = (MDUOp == 4'd7);
	 assign mtlo = (MDUOp == 4'd8);
	 assign bds = (MDUOp == 4'd9);
	 
	 assign start = (mult | multu| div | divu | bds);
	 
	 assign rs = {1'b0, D1};
	 assign rt = {1'b0, D2};
	 
	 assign check = (D1 >= D2)? 1'd1 : 1'd0;
	 
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
		  else begin
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
						  tmp_hi <= $signed($signed(D1)%$signed(D2));
						  tmp_lo <= $signed($signed(D1)/$signed(D2));
						  cnt <= 4'd10;
					 end
					 else if(bds == 1 && check == 1)begin
					     busy <= 1;
						  tmp_hi <= (D1 % D2);
						  tmp_lo <= (D1 / D2);
						  cnt <= 4'd10;
					 end
					  else if(bds == 1 && check == 0)begin
					     busy <= 1;
						  tmp_hi <= (D2 % D1);
						  tmp_lo <= (D2 / D1);
						  cnt <= 4'd10;
					 end
					 else if(divu == 1)begin
					     busy <= 1;
						  tmp_hi <= D1%D2;
						  tmp_lo <= D1/D2;
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

//{temp_hi, temp_lo} <= {hi, lo} + $signed($signed(64'd0) + $signed(rs) * $signed(rt));
// Лђеп
//{temp_hi, temp_lo} <= {hi, lo} + $signed({{32{rs[31]}}, rs[31:0]} * $signed({{32{rt[31]}}, rt[31:0]})); 
