`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:34:48 11/07/2022 
// Design Name: 
// Module Name:    D_EXT 
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
module D_EXT(
    input [15:0] imm,
    input [1:0] EXTOp,
    output [31:0] Ext_imm
    );
    assign Ext_imm = (EXTOp == 2'b10)? {imm[15:0],{16{1'b0}}}:
	                  (EXTOp == 2'b01)? {{16{imm[15]}},imm[15:0]} : 
							(EXTOp == 2'b11)? {{16{1'd1}}, imm[15:0]} : {{16{1'b0}},imm[15:0]};

endmodule
