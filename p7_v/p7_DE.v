`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:26:04 11/16/2022 
// Design Name: 
// Module Name:    p6_DE 
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
module DE(
    input [2:0] load_type,
	 input [1:0] A,
	 input [31:0] Din,
	 input [31:0] addr,
	 input M_DM_ov,
	 output M_AdEL,
	 output [31:0] Dout
    );
    wire [7:0] byte_ ;
	 
	    wire Err_Align = (((load_type == 3'b000) && (A != 2'b00)) ||((load_type == 3'b100) && (A[0] == 1 )));
		 
		 wire Err_OutOfRange = !(((addr >= 32'h0000_0000) && (addr <= 32'h0000_2fff)) || ((addr >= 32'h0000_7f00)&& (addr <= 32'h0000_7f0b)) 
		                       || ((addr >= 32'h0000_7f10) && (addr <= 32'h0000_7f1b)) ||((addr >= 32'h0000_7f20) && (addr <= 32'h0000_7f23)));
									  
	    wire Err_timer = (load_type != 3'b000 && ((addr >= 32'h0000_7f00 && addr <= 32'h0000_7f0b) || (addr >= 32'h0000_7f10 && addr <= 32'h0000_7f1b))&& load_type != 3'b111 );
		 assign M_AdEL = (load_type != 3'b111) && (Err_Align || Err_OutOfRange || Err_timer || M_DM_ov);
	 
	 
	 assign byte_ = (A == 2'b00)? Din[7:0] :
	                (A == 2'b01)? Din[15:8] :
						 (A == 2'b10)? Din[23:16] : Din[31:24];
	 wire [15:0] half_;
	 assign half_ = (A[1] == 0)? Din[15:0] : Din[31:16];
	 assign Dout = (load_type == 3'b000)? Din :
	               (load_type == 3'b100)? {{16{half_[15]}},half_} : 
						(load_type == 3'b010)? {{24{byte_[7]}},byte_} : 32'd0;

endmodule
