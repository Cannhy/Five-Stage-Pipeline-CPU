`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:07:43 11/07/2022 
// Design Name: 
// Module Name:    D_CMP 
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
module D_CMP(
    input [31:0] D_Rs,
    input [31:0] D_Rt,
	 input [2:0] b_type,
	 output D_CMP_result,
    output zero
    );
	 reg [4:0] count ,count1;
	 wire [31:0] mid;
	 assign mid = (D_Rs ^ D_Rt);
	 initial begin
	     count <= 0;
		  count1 <=0;
	 end
    assign zero = ((b_type == 3'd0) && (D_Rs == D_Rt))? 1 : 
	               ((b_type == 3'd1) && (D_Rs != D_Rt))? 1 : 0;
	 integer i,j;
	 always@(*)begin
	     count = 0;
		  count1 = 0;
		  for(i=0; i<32; i= i+1)begin
		      j= 31- i;
            if(D_Rs[j] == 1 )begin
				    if(j>=count)count = j;
				end
				if(D_Rt[j] == 1)begin
				    if(j>=count1)count1 = j;
				end
				
		  end
	 end
	 
	 assign D_CMP_result = (D_Rs == 32'd0 || D_Rt == 32'd0)? 1'b0 : (count == count1)? 1'b1 : 1'b0;
	 
endmodule
