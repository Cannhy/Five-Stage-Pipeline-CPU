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
	 input busy,
	 input start,
    output  stall 
    );
    wire [1:0] tuse_rs, tuse_rt;
	 wire [1:0] E_tnew, M_tnew;
	 wire [4:0] E_A3, M_A3;
	 wire E_RfWr, M_RfWr;
	 wire D_md, D_mt, D_mf;
	 wire E_stall_rs, M_stall_rs, E_stall_rt, M_stall_rt, E_stall_mdu;
	 wire D_eret,E_mtc0, M_mtc0, eret_stall;
	 CU D_CU(
	     .Instr(D_Instr),
		  .tuse_rs(tuse_rs),
		  .tuse_rt(tuse_rt),
		  .md(D_md),
		  .mt(D_mt),
		  .mf(D_mf),
		  .eret(D_eret)
	 );

	 CU E_CU(
	     .Instr(E_Instr),
		  .A3(E_A3),
	     .RfWr(E_RfWr),
		  .E_tnew(E_tnew),
		  .mtc0(E_mtc0)
		  );

	 CU M_CU(
	     .Instr(M_Instr),
		  .A3(M_A3),
	     .RfWr(M_RfWr),
        .M_tnew(M_tnew),
		  .mtc0(M_mtc0)
	 );
	 
    assign E_stall_mdu = (D_md | D_mt | D_mf) && (busy | start);          // busy and start to write;
	 
	 assign E_stall_rs = ((D_Instr[25:21] == E_A3) && (tuse_rs < E_tnew) && (D_Instr[25:21] != 5'd0));
	 assign E_stall_rt = ((D_Instr[20:16] == E_A3) && (tuse_rt < E_tnew) && (D_Instr[20:16] != 5'd0) );
	 assign M_stall_rs = ((D_Instr[25:21] == M_A3) && (tuse_rs < M_tnew) && (D_Instr[25:21] != 5'd0));
	 assign M_stall_rt = ((D_Instr[20:16] == M_A3) && (tuse_rt < M_tnew) && (D_Instr[20:16] != 5'd0));
	 
	 assign eret_stall = D_eret && ((E_mtc0 && (E_Instr[15:11] == 5'd14)) || (M_mtc0 && (M_Instr[15:11] == 5'd14)) );
	 
	 assign stall = eret_stall | E_stall_rs | E_stall_rt | M_stall_rs | M_stall_rt | E_stall_mdu;
	 
endmodule
