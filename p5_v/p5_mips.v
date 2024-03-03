`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:09:50 11/07/2022 
// Design Name: 
// Module Name:    p5_mips 
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
module mips(
    input clk,
    input reset
    );
	 // F
	 wire [31:0] F_PC, F_Instr;
	 wire F_en;
	 
	 // W
	 wire [1:0] W_RF_WD_type;
	 wire [31:0] W_WD;
	 wire [31:0] W_Instr, W_PC, W_DM_data, W_ALU_result;
	 wire [4:0] W_A3;
	 wire [31:0] W_V2;
	 wire W_RfWr;
	 wire W_jump;
	 wire W_judge;
	 
	 // M
	 wire judge;
	 wire [31:0] M_WD;
	 wire [31:0] DM_data;
	 wire DMWr;
	 wire M_jump;
	 wire [1:0] M_RF_WD_type;
	 wire [4:0] M_A3;
	 wire M_RfWr;
	 wire [31:0] M_Instr, M_PC, M_ALU_result, M_V2;
	 wire [31:0] M_FW_Rt;
	 wire [2:0] load_type;
	 wire [2:0] store_type;
	 
	 // D
	 wire [31:0] D_Instr, D_PC;
	 wire D_Reg_en;
	 wire [31:0] D_RF_RD1, D_RF_RD2;
	 wire [31:0] Ext_imm;
    wire [31:0] out_NPC;
	 wire zero;
	 wire jump;
	 wire b_clr;
	 wire [4:0] D_A3;
	 wire [2:0] NPCOp;
	 wire [1:0] ExtOp;
	 wire [31:0] D_FW_Rs, D_FW_Rt;
	 
	 // E
	 wire [4:0] E_A3, E_A1;
	 wire [31:0] E_PC, E_Instr,  E_V1, E_V2,  E_imm;
	 wire E_reset;
	 wire [2:0] E_ALUOp;
	 wire [1:0] E_RF_WD_type;
	 wire E_RfWr;
	 wire E_jump;
	 wire [2:0] Src_ALU_B;
	 wire [31:0] E_ALU_result;
	 wire [31:0] E_WD;
	 wire [31:0] E_FW_Rs, E_FW_Rt, ALU_B;
	 
	 // stall
	 wire stall;

	 // F stage :
    IFU IFU(
	     .clk(clk),
		  .F_en(F_en),
		  .NPC(out_NPC),
		  .reset(reset),
		  .F_PC(F_PC),
		  .clear((b_clr && !jump)),
		  .F_Instr(F_Instr)
	 );
	 // D stage :
	 D_Reg mips_D_Reg(
	     .F_Instr(F_Instr),
		  .clk(clk),
		  .en(D_Reg_en),
		  .reset(reset),
		  .F_PC(F_PC),
		  .D_Instr(D_Instr),
		  .D_PC(D_PC)
	 );
	 D_RF D_RF(
	     .A1(D_Instr[25:21]),
		  .A2(D_Instr[20:16]),
		  .A3(W_A3),
		  .WD(W_WD),
		  .clk(clk),
		  .reset(reset),
		  .WE(W_RfWr),
		  .WPC(W_PC),
		  .RD1(D_RF_RD1),
		  .RD2(D_RF_RD2)
	 );
    D_EXT D_EXT(
	     .imm(D_Instr[15:0]),
		  .EXTOp(ExtOp),
		  .Ext_imm(Ext_imm)
	 );
	 D_NPC D_NPC(
	     .zero(zero),
		  .jump(jump),
		  .imm(D_Instr[25:0]),
		  .NPCOp(NPCOp),
		  .D_Rs(D_FW_Rs),
		  .D_PC(D_PC),
		  .F_PC(F_PC),
		  .out_NPC(out_NPC)
	 );
	 D_CMP D_CMP(
	     .D_Rs(D_FW_Rs),
		  .D_Rt(D_FW_Rt),
		  .jump(jump),
		  .zero(zero)
	 );
	 CU mips_D_CU(
	     .Instr(D_Instr),
		  .NPCOp(NPCOp),
		  .ExtOp(ExtOp),
		//.jump(jump),
		  .b_clr(b_clr)
	 );
	        assign D_FW_Rs = (D_Instr[25:21] == 5'd0)? 32'd0 :
			                   (D_Instr[25:21] == E_A3)? E_WD : 
			                   (D_Instr[25:21] == M_A3)? M_WD :
									  D_RF_RD1;
			  assign D_FW_Rt = (D_Instr[20:16] == 5'd0)? 32'd0 :
			                   (D_Instr[20:16] == E_A3)? E_WD : 
			                   (D_Instr[20:16] == M_A3)? M_WD :
									  D_RF_RD2;
	 // E stage :
	 E_Reg mips_E_Reg(
	     .clk(clk),
		  .reset(reset || E_reset),
		  .D_Instr(D_Instr),
		  .D_imm(Ext_imm),
		  .D_A1(D_Instr[25:21]),
		  .D_V1(D_FW_Rs),
		  .D_V2(D_FW_Rt),
		  .D_PC(D_PC),
		  .D_jump(jump),
		  .E_jump(E_jump),
		  .E_PC(E_PC),
		  .E_imm(E_imm),
		  .E_Instr(E_Instr),
		  .E_A1(E_A1),
		  .E_V1(E_V1),
		  .E_V2(E_V2)
	 );
	 	  
	
	 CU mips_E_CU(
	     .Instr(E_Instr),
		  .RF_WD_type(E_RF_WD_type),
		  .jump(E_jump),
		  .RfWr(E_RfWr),
		  .Src_ALU_B(Src_ALU_B),
		  .A3(E_A3),
		  .judge(1'bx),
		  .ALUOp(E_ALUOp)
	 );
	


	 E_ALU E_ALU(
	     .ALU_A(E_FW_Rs),
		  .ALU_B(ALU_B),
		  .ALUOp(E_ALUOp),
		  .out(E_ALU_result)
	 );
	 
	     assign E_WD = (E_RF_WD_type == 2'b01)? E_imm :
	                      (E_RF_WD_type == 2'b11)? E_PC + 8 : 0;
								 
	     assign E_FW_Rs =  (E_Instr[25:21] == 5'd0)? 32'd0 :
		                    (E_Instr[25:21] == M_A3)? M_WD : 
								  (E_Instr[25:21] == W_A3)? W_WD : E_V1;
								  
		  assign E_FW_Rt =  (E_Instr[20:16] == 5'd0) ? 32'd0 :
		                    ((E_Instr[20:16] == M_A3))? M_WD : 
								  ((E_Instr[20:16] == W_A3))? W_WD : E_V2;
								  
		  assign ALU_B = (Src_ALU_B == 3'b001)? E_imm : E_FW_Rt;
	 
	// M stage :
	 M_Reg mips_M_Reg(
	     .clk(clk),
		  .reset(reset),
		  .E_Instr(E_Instr),
		  .E_ALU_result(E_ALU_result),
		  .E_PC(E_PC),
		  .E_V2(E_FW_Rt),
		  .E_jump(E_jump),
		  .M_jump(M_jump),
		  .M_Instr(M_Instr),
		  .M_PC(M_PC),
		  .M_ALU_result(M_ALU_result),
		  .M_V2(M_V2)
	 );
	 
	 CU mips_M_CU(
	     .Instr(M_Instr),
		  .RF_WD_type(M_RF_WD_type),
		  .RfWr(M_RfWr),
		  .jump(M_jump),
		  .A3(M_A3),
		  .judge(judge),
		  .dm(DM_data[31:27]),
		  .load_type(load_type),
		  .store_type(store_type),
		  .DMWr(DMWr)
	 );
	
	 assign M_WD = (M_RF_WD_type == 2'b00 )? M_ALU_result :
	               (M_RF_WD_type == 2'b01 )? M_ALU_result : 
	               (M_RF_WD_type == 2'b11 )? M_PC + 8 : 0;
	 M_DM M_DM(
	     .clk(clk),
		  .reset(reset),
		  .addr(M_ALU_result),
		  .data(M_FW_Rt),
		  .WE(DMWr),
		  .pc(M_PC),
		  .Instr(M_Instr),
		  .load_type(load_type),
		  .store_type(store_type),
		  .judge(judge),
		  .outdata(DM_data)
	 );
         assign M_FW_Rt = (M_Instr[20:16] == 5'd0)? 32'd0 :
			                 (M_Instr[20:16] == W_A3)? W_WD : M_V2;
	 // W stage :
	 W_Reg W_Reg(
	     .clk(clk),
		  .reset(reset),
		  .M_Instr(M_Instr),
		  .M_PC(M_PC),
		  .M_ALU_result(M_ALU_result),
		  .M_data(DM_data),
		  .M_jump(M_jump),
		  .M_judge(judge),
		  .M_V2(M_V2),
		  .W_V2(W_V2),
		  .W_jump(W_jump),
		  .W_judge(W_judge),
		  .W_Instr(W_Instr),
		  .W_PC(W_PC),
		  .W_data(W_DM_data),
		  .W_ALU_result(W_ALU_result)
	 );
	
	 CU mips_W_CU(
	     .Instr(W_Instr),
		  .RF_WD_type(W_RF_WD_type),
		  .A3(W_A3),
		  .dm(W_DM_data[31:27]),
		  .jump(W_jump),
        .judge(W_judge),
		  .RfWr(W_RfWr)
	 );
	 

	 
	 assign W_WD = (W_RF_WD_type == 2'b00 || W_RF_WD_type == 2'b01)? W_ALU_result :
	               (W_RF_WD_type == 2'b11)? W_PC + 8 : (W_RF_WD_type == 2'b10)? W_DM_data : 0;

	 Stall SU(
	     .D_Instr(D_Instr),
		  .E_Instr(E_Instr),
		  .M_Instr(M_Instr),
		  .W_Instr(W_Instr),
		  .M_A3(M_A3),
		  .E_A3(E_A3),
		  .stall(stall)
	 );
	 	 assign F_en = !stall;
		 assign D_Reg_en = !stall;
       assign E_reset = stall;
endmodule
