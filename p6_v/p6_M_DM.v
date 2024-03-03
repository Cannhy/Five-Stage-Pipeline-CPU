`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:25:51 11/07/2022 
// Design Name: 
// Module Name:    M_DM 
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
module M_DM(
    input clk,
    input reset,
    input [31:0] addr,
    input [31:0] data,
    input WE,
    input [31:0] pc,
    output [31:0] outdata
    );
    integer i;
    reg [31:0] DM [3071:0];
	 initial begin
	     for(i=0; i < 3072; i = i+1)begin
		      DM[i] = 32'd0;
		  end
	 end
	 always@(posedge clk)begin
	     if(reset == 1)begin
		      for(i=0; i < 3072; i = i+1)begin
				DM[i] <= 32'd0;
		      end
		  end
		  else begin
		      if(WE == 1)begin
				    DM[addr[13:2]] <= data;
					 $display("%d@%h: *%h <= %h", $time, pc, addr, data);
				end
		  end
	 end
    assign outdata = DM[addr[13:2]];
endmodule
