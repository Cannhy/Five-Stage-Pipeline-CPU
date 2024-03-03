`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:24:57 11/15/2022 
// Design Name: 
// Module Name:    p6_BE 
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
module BE(
    input [2:0] store_type,
	 input [1:0] m_data_addr_byte,
	 input [31:0] wdata,
	 input [31:0] PC,
	 output reg [31:0] m_data_wdata,
	 output reg [3:0] byteen
    );
   // assign byteen = (store_type == 3'b000)? 4'b1111 : 
	  //               ((store_type == 3'b001) && (m_data_addr_byte[1] == 0))? 4'b0011 :
		//				  ((store_type == 3'b001) && (m_data_addr_byte[1] == 1))? 4'b1100 :
			//			  ((store_type == 3'b010) && (m_data_addr_byte == 2'b00))? 4'b0001 :
				//		  ((store_type == 3'b010) && (m_data_addr_byte == 2'b01))? 4'b0010 :
					//	  ((store_type == 3'b010) && (m_data_addr_byte == 2'b10))? 4'b0100 : 4'b0000;

	always@(*)begin
	    if(store_type == 3'b000)begin
		     byteen = 4'b1111;
			  m_data_wdata = wdata;
		 end
		 else if((store_type == 3'b001) && (m_data_addr_byte[1] == 0))begin
		     byteen = 4'b0011;
			  m_data_wdata = {16'b0, wdata[15:0]};
		 end
		 else if((store_type == 3'b001) && (m_data_addr_byte[1] == 1))begin
		     byteen = 4'b1100;
			  m_data_wdata = {wdata[15:0],16'b0};
		 end
		 else if((store_type == 3'b010) && (m_data_addr_byte == 2'b00))begin
		     byteen = 4'b0001;
			  m_data_wdata = {24'd0, wdata[7:0]};
		 end
		 else if((store_type == 3'b010) && (m_data_addr_byte == 2'b01))begin
		     byteen = 4'b0010;
			  m_data_wdata = {16'b0, wdata[7:0], 8'b0};
		 end
		 else if((store_type == 3'b010) && (m_data_addr_byte == 2'b10))begin
		     byteen = 4'b0100;
			  m_data_wdata = {8'b0, wdata[7:0], 16'b0};
		 end
		 else if((store_type == 3'b010) && (m_data_addr_byte == 2'b11))begin
		     byteen = 4'b1000;
			  m_data_wdata = {wdata[7:0], 24'b0};
		 end
		 else if(store_type == 3'b011)begin
		     byteen = 4'b1111;
			  m_data_wdata = PC + 32'd8;
		 end
		 else begin
		     byteen = 4'b0000;
			  m_data_wdata = wdata;
		 end
	end

endmodule
