`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:30:54 12/03/2022 
// Design Name: 
// Module Name:    p7_Bridge 
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
module p7_Bridge(
    input [31:0] Pr_addr,
	 input [31:0] Pr_WD,
	 //input [31:0] Pr_WE,
	 input [3:0] Pr_byteen,
	 input [31:0] m_data_rdata,
	 input [31:0] TC0_out,
	 input [31:0] TC1_out,

	 output [31:0] Pr_rdata,
	 output [3:0] m_data_byteen,
	 output [31:0] m_data_addr,
	 output [31:0] m_data_wdata,
	 output [31:0] m_int_addr,
	 output [3:0] m_int_byteen,
	 output  TC0_WE,
	 output  TC1_WE,
	 output [31:0] TC0_addr,
	 output [31:0] TC0_WD,
	 output [31:0] TC1_addr,
	 output [31:0] TC1_WD
    );
    
	 wire DM, TC0, TC1, Pr_WE;
	 assign Pr_WE = (|Pr_byteen);
	 assign DM = (Pr_addr >= 32'h0000_0000 && Pr_addr <= 32'h0000_2fff)? 1 : 0;
	 assign TC0 = (Pr_addr >= 32'h0000_7f00 && Pr_addr <= 32'h0000_7f0b)? 1 : 0;
	 assign TC1 = (Pr_addr >= 32'h0000_7f10 && Pr_addr <= 32'h0000_7f1b)? 1 : 0;
	 
	 assign TC0_WE = ((Pr_addr >= 32'h0000_7f00 && Pr_addr <= 32'h0000_7f07)&& Pr_WE);
	 assign TC1_WE = ((Pr_addr >= 32'h0000_7f10 && Pr_addr <= 32'h0000_7f17) && Pr_WE);
    assign Pr_rdata = DM? m_data_rdata : TC0? TC0_out : TC1? TC1_out : 32'd0;
	 assign TC0_addr = Pr_addr;
	 assign TC1_addr = Pr_addr;
	 assign TC0_WD = Pr_WD;
	 assign TC1_WD = Pr_WD;
	 assign m_data_wdata = Pr_WD;
	 assign m_data_addr = Pr_addr;
	 assign m_data_byteen = DM? Pr_byteen : 4'd0;
	 assign m_int_addr = (Pr_addr >= 32'h0000_7f20 && Pr_addr <= 32'h0000_7f23)? Pr_addr : 32'h0;
	 assign m_int_byteen = ((Pr_addr & 32'hfffffffc) == 32'h0000_7f20 && Pr_byteen != 4'd0)? 4'b1111 : 4'b0000;
	 
endmodule
