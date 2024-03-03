`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:20:21 11/07/2022 
// Design Name: 
// Module Name:    Stall 
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
module Stall(
    input [31:0] D_Instr,
    input [31:0] E_Instr,
    input [31:0] M_Instr,
    input [31:0] W_Instr,
	 input [4:0] E_A3,
	 input [4:0] M_A3,
	 //input  E_RfWr,
	 //input  M_RfWr,
    output  stall 
    );
    wire [1:0] tuse_rs, tuse_rt;
	 wire [1:0] E_tnew, M_tnew;
	 //wire [4:0] E_A3;
	 //wire E_RfWr;
	 wire E_lwtt, M_lwtt;
	 CU D_CU(
	     .Instr(D_Instr),
		  .tuse_rs(tuse_rs),
		  .tuse_rt(tuse_rt)
	 );

	 CU E_CU(
	     .Instr(E_Instr),
		  //.A3(E_A3),
		  .lwtt(E_lwtt),
	     //.RfWr(E_RfWr),
		  .E_tnew(E_tnew)
		  );

	 CU M_CU(
	     .Instr(M_Instr),
		  .lwtt(M_lwtt),
        .M_tnew(M_tnew)
	 );
	 
	 wire stall_rs_E, stall_rs_M, stall_rt_E, stall_rt_M;
	 
	 assign stall_rs_E = (((E_lwtt == 1 )? D_Instr[25:21]:(D_Instr[25:21] == E_A3))&& (tuse_rs < E_tnew) && (D_Instr[25:21] != 5'd0) );
	 assign stall_rt_E = (((E_lwtt == 1 )? D_Instr[20:16] :(D_Instr[20:16] == E_A3)) && (tuse_rt < E_tnew) && (D_Instr[20:16] != 5'd0));
	 assign stall_rs_M = (M_lwtt == 1 )? ((D_Instr[25:21]== M_A3) && (tuse_rs < M_tnew) && (D_Instr[25:21] != 5'd0)) :
	                                     ((D_Instr[25:21] == M_A3) && (tuse_rs < M_tnew) && (D_Instr[25:21] != 5'd0));
	 assign stall_rt_M = (M_lwtt == 1 )? ((D_Instr[20:16]== M_A3) && (tuse_rs < M_tnew) && (D_Instr[20:16] != 5'd0)) :
	                                     ((D_Instr[20:16] == M_A3) && (tuse_rt < M_tnew) && (D_Instr[20:16] != 5'd0));
	 
	 assign stall = stall_rs_E | stall_rt_E | stall_rs_M | stall_rt_M ;
	 
endmodule
