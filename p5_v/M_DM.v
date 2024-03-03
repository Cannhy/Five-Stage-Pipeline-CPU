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
	 input [2:0] load_type,
	 input [2:0] store_type,
	 input [31:0] Instr,
    output [31:0] outdata,
	 output  judge
    );
    integer i;
    reg [31:0] DM [3071:0];
	 wire [1:0] byt;
	 wire [7:0] loadbyte;
	 wire [15:0] loadhalf;
	 wire [31:0] pad;
	 initial begin
	     for(i=0; i < 3072; i = i+1)begin
		      DM[i] = 32'd0;
		  end
	 end
	 
	 assign pad = {addr[31:2], 2'b00};
	 assign byt = addr[1:0];
	 
	 assign loadbyte = (byt == 2'b00)? DM[addr[13:2]][7:0] :
	                   (byt == 2'b01)? DM[addr[13:2]][15:8] :
							 (byt == 2'b10)? DM[addr[13:2]][23:16] :
							 (byt == 2'b11)? DM[addr[13:2]][31:24] : 8'd0;
	 
	 assign loadhalf = (byt[1] == 1'b1)? DM[addr[13:2]][31:16] : DM[addr[13:2]][15:0];
	 
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
    assign outdata = (load_type == 3'd1)? DM[pad[13:2]] : DM[addr[13:2]];
	 assign judge =(outdata[0] == 1'b0)? 1 : 0;
	 
endmodule