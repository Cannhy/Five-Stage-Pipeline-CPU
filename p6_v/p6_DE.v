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
	 output [31:0] Dout
    );
    wire [7:0] byte_ ;
	 assign byte_ = (A == 2'b00)? Din[7:0] :
	                (A == 2'b01)? Din[15:8] :
						 (A == 2'b10)? Din[23:16] : Din[31:24];
	 wire [15:0] half_;
	 assign half_ = (A[1] == 0)? Din[15:0] : Din[31:16];
	 assign Dout = (load_type == 3'b000 || load_type == 3'b011)? Din :
	               (load_type == 3'b100)? {{16{half_[15]}},half_} : 
						(load_type == 3'b010)? {{24{byte_[7]}},byte_} : 32'd0;

endmodule
