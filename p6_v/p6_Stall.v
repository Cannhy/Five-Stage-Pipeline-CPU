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
	 input busy,
	 input start,
    output  stall 
    );
    wire [1:0] tuse_rs, tuse_rt;
	 wire [1:0] E_tnew, M_tnew;
	 //wire [4:0] E_A3, M_A3;
	 //wire E_RfWr, M_RfWr;
	 wire D_md, D_mt, D_mf;
	 wire E_stall_rs, M_stall_rs, E_stall_rt, M_stall_rt, E_stall_mdu;
	 wire E_tjcc, M_tjcc;
	 wire [4:0] D_A1, D_A2;
	 
	 CU D_CU(
	     .Instr(D_Instr),
		  .tuse_rs(tuse_rs),
		  .tuse_rt(tuse_rt),
		  .A1(D_A1),
		  .A2(D_A2),
		  .md(D_md),
		  .mt(D_mt),
		  .mf(D_mf)
	 );

	 CU E_CU(
	     .Instr(E_Instr),
		  //.A3(E_A3),
	     //.RfWr(E_RfWr),
		  .tjcc(E_tjcc),
		  .E_tnew(E_tnew)
		  );

	 CU M_CU(
	     .Instr(M_Instr),
		  .tjcc(M_tjcc),
		  //.A3(M_A3),
	     //.RfWr(M_RfWr),
        .M_tnew(M_tnew)
	 );
	 
    assign E_stall_mdu = (D_md | D_mt | D_mf) && (busy | start);          // busy and start to write;
	 
	 //assign E_stall_rs = ((D_Instr[25:21] == E_A3) && (tuse_rs < E_tnew) && (D_Instr[25:21] != 5'd0));
	 //assign E_stall_rt = ((D_Instr[20:16] == E_A3) && (tuse_rt < E_tnew) && (D_Instr[20:16] != 5'd0));
	 //assign M_stall_rs = ((D_Instr[25:21] == M_A3) && (tuse_rs < M_tnew) && (D_Instr[25:21] != 5'd0));
	 //assign M_stall_rt = ((D_Instr[20:16] == M_A3) && (tuse_rt < M_tnew) && (D_Instr[20:16] != 5'd0));
	 
	 assign E_stall_rs = (((E_tjcc == 1 )? D_A1:(D_A1 == E_A3))&& (tuse_rs < E_tnew) && (D_A1 != 5'd0) );
	 assign E_stall_rt = (((E_tjcc == 1 )? D_A2 :(D_A2 == E_A3)) && (tuse_rt < E_tnew) && (D_A2 != 5'd0));
	 assign M_stall_rs = (M_tjcc == 1 )? ((D_A1== M_A3) && (tuse_rs < M_tnew) && (D_A1 != 5'd0)) :
	                                     ((D_A1 == M_A3) && (tuse_rs < M_tnew) && (D_A1 != 5'd0));
	 assign M_stall_rt = (M_tjcc == 1 )? ((D_A2== M_A3) && (tuse_rs < M_tnew) && (D_A2 != 5'd0)) :
	                                     ((D_A2 == M_A3) && (tuse_rt < M_tnew) && (D_A2 != 5'd0));
	 
	 assign stall = E_stall_rs | E_stall_rt | M_stall_rs | M_stall_rt | E_stall_mdu;
	 
endmodule
