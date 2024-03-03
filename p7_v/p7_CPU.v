`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:17:11 12/03/2022 
// Design Name: 
// Module Name:    p7_CPU 
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
module CPU(
    input clk,
    input reset,
    input [5:0] HWInt,
    input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
	 output Int_response,
	 output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3:0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr,
	 output [31:0] macroscopic_pc
    );
    
    //F
	 wire F_AdEL;
	 wire [31:0] F_PC, F_Instr;
	 wire F_en;
	 wire F_BD;
	 wire [4:0] F_EXCcode;
	 wire [31:0] EBase;
	 
	 // W
	 wire [3:0] W_RF_WD_type;
	 wire [31:0] W_WD;
	 wire [31:0] W_Instr, W_PC, W_DM_data, W_ALU_result;
	 wire [4:0] W_A3;
	 wire W_RfWr;
	 wire [31:0] W_MDU_out;
	 wire [31:0] W_CP0_out;
	 
	 // M
	 wire [31:0] M_WD;
	 wire [31:0] DM_data;
	 wire DMWr;
	 wire [3:0] M_RF_WD_type;
	 wire [4:0] M_A3;
	 wire M_RfWr;
	 wire [31:0] M_Instr, M_PC, M_ALU_result, M_V2;
	 wire [31:0] M_FW_Rt;
	 wire [2:0] store_type, load_type;
	 wire [31:0] M_MDU_out;
	 wire M_BD, M_DM_ov;
	 wire [4:0] M_old_EXCcode, M_EXCcode;
	 wire M_AdES, M_AdEL;
	 wire CP0_WE;
	 wire M_eret;
	 wire [31:0] M_CP0_out;
	 
	 //CP0
	 wire [31:0] EPC_out;
	 wire Req;
	 // D
	 wire [31:0] D_Instr, D_PC, D_old_Instr;
	 wire D_Reg_en;
	 wire [31:0] D_RF_RD1, D_RF_RD2;
	 wire [31:0] Ext_imm;
    wire [31:0] out_NPC;
	 wire zero;
	 wire [2:0] b_type;
	 wire [4:0] D_A3;
	 wire [2:0] NPCOp;
	 wire [1:0] ExtOp;
	 wire [31:0] D_FW_Rs, D_FW_Rt;
	 wire D_eret;
	 wire D_BD, D_syscall;
    wire [4:0]	D_EXCcode, D_old_EXCcode;
	 wire D_branch, D_j_imm, D_j_r, D_RI;
	 
	 // E
	 wire [4:0] E_A3, E_A1;
	 wire [31:0] E_PC, E_Instr,  E_V1, E_V2,  E_imm;
	 wire E_reset;
	 wire [3:0] E_ALUOp;
	 wire [3:0] E_RF_WD_type;
	 wire E_RfWr;
	 wire [2:0] Src_ALU_B;
	 wire [31:0] E_ALU_result;
	 wire [31:0] E_WD;
	 wire [31:0] E_FW_Rs, E_FW_Rt, ALU_B;
	 wire [3:0] MDUOp;
	 wire [31:0] MDU_out;
	 wire start, busy;
	 wire E_BD;
	 wire [4:0] E_old_EXCcode, E_EXCcode;
	 wire ALU_cal_ov, ALU_DM_ov, E_cal_ov, E_DM_ov;
	 
	 // stall
	 wire stall;

	 // F stage :
    IFU IFU(
	     .clk(clk),
		  .F_en(F_en),
		  .NPC(out_NPC),
		  .D_eret(D_eret),
		  .EPC(EPC_out),
		  .Req(Req),
		  .F_AdEL(F_AdEL),
		  .reset(reset),
		  .F_PC(F_PC)
	 );
	     assign i_inst_addr = F_PC;
		  assign F_Instr = (F_AdEL == 1)? 32'd0 : i_inst_rdata;
	     assign F_EXCcode = (F_AdEL == 1)? 5'd4 : 5'd0;
		  assign F_BD = (D_branch | D_j_imm | D_j_r)? 1 : 0;
	
	 // D stage :
	 D_Reg mips_D_Reg(
	     .F_Instr(F_Instr),
		  .clk(clk),
		  .en(D_Reg_en),
		  .reset(reset),
		  .F_PC(F_PC),
		  .Req(Req),
		  .F_EXCcode(F_EXCcode),
		  .F_BD(F_BD),
		  .D_Instr(D_Instr),
		  .D_PC(D_PC),
		  .D_BD(D_BD),
		  .D_EXCcode(D_old_EXCcode)
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
		  .imm(D_Instr[25:0]),
		  .NPCOp(NPCOp),
		  .D_Rs(D_FW_Rs),
		  .D_PC(D_PC),
		  .F_PC(F_PC),
		  .Req(Req),
		  .D_eret(D_eret),
		  .EPC(EPC_out),
		  .EBase(EBase),
		  .out_NPC(out_NPC)
	 );
	 D_CMP D_CMP(
	     .D_Rs(D_FW_Rs),
		  .D_Rt(D_FW_Rt),
		  .b_type(b_type),
		  .zero(zero)
	 );
	 CU mips_D_CU(
	     .Instr(D_Instr),
		  .NPCOp(NPCOp),
		  .ExtOp(ExtOp),
		  .b_type(b_type),
		  .eret(D_eret),
		  .syscall(D_syscall),
		  .branch(D_branch),
		  .j_imm(D_j_imm),
		  .j_r(D_j_r),
		  .RI(D_RI),
		  .A3(D_A3)
	 );
	 
	        //assign D_Instr = (D_RI)? 32'd0 : D_old_Instr;
	 
	        assign D_FW_Rs = (D_Instr[25:21] == 5'd0)? 32'd0 :
			                   ((D_Instr[25:21] == E_A3) && (E_RfWr == 1))? E_WD : 
			                   ((D_Instr[25:21] == M_A3) && (M_RfWr == 1))? M_WD :
									  D_RF_RD1;
			  assign D_FW_Rt = (D_Instr[20:16] == 5'd0)? 32'd0 :
			                   ((D_Instr[20:16] == E_A3) && (E_RfWr == 1))? E_WD : 
			                   ((D_Instr[20:16] == M_A3) && (M_RfWr == 1))? M_WD :
									  D_RF_RD2;
									  
			  assign D_EXCcode = (D_old_EXCcode != 5'd0)? D_old_EXCcode : D_syscall? 5'd8 : D_RI? 5'd10 : 5'd0;
			  
	 // E stage :
	 E_Reg mips_E_Reg(
	     .clk(clk),
		  .reset(reset),
		  .D_Instr(D_Instr),
		  .D_imm(Ext_imm),
		  //.D_A1(D_Instr[25:21]),
		  .D_V1(D_FW_Rs),
		  .D_V2(D_FW_Rt),
		  .D_PC(D_PC),
		  .D_EXCcode(D_EXCcode),
		  .D_BD(D_BD),
		  .Req(Req),
		  .stall(stall),
		  .E_PC(E_PC),
		  .E_imm(E_imm),
		  .E_Instr(E_Instr),
		  //.E_A1(E_A1),
		  .E_V1(E_V1),
		  .E_V2(E_V2),
		  .E_EXCcode(E_old_EXCcode),
		  .E_BD(E_BD)
	 );
	 MDU MDU(
	     .clk(clk),
		  .reset(reset),
		  .D1(E_FW_Rs),
		  .D2(E_FW_Rt),
		  .Req(Req),
		  .MDUOp(MDUOp),
		  .start(start),
		  .busy(busy),
		  .out(MDU_out)
		  
	 );
	
	 CU mips_E_CU(
	     .Instr(E_Instr),
		  .RF_WD_type(E_RF_WD_type),
		  .RfWr(E_RfWr),
		  .Src_ALU_B(Src_ALU_B),
		  .A3(E_A3),
		  .MDUOp(MDUOp),
		  .ALUOp(E_ALUOp),
		  .ALU_cal_ov(ALU_cal_ov),
		  .ALU_DM_ov(ALU_DM_ov)
	 );
	


	 E_ALU E_ALU(
	     .ALU_A(E_FW_Rs),
		  .ALU_B(ALU_B),
		  .ALUOp(E_ALUOp),
		  .out(E_ALU_result),
		  .ALU_cal_ov(ALU_cal_ov),
	     .ALU_DM_ov(ALU_DM_ov),
	     .E_cal_ov(E_cal_ov),
	     .E_DM_ov(E_DM_ov)
	 );
	 
	     assign E_WD = (E_RF_WD_type == 4'b0001)? E_imm :
	                      (E_RF_WD_type == 4'b0011)? E_PC + 8 : 0;
								 
	     assign E_FW_Rs =  (E_Instr[25:21] == 5'd0) ? 32'd0 :
		                    ((E_Instr[25:21] == M_A3) && (M_RfWr == 1))? M_WD : 
								  ((E_Instr[25:21] == W_A3) && (W_RfWr == 1))? W_WD : E_V1;
								  
		  assign E_FW_Rt =  (E_Instr[20:16] == 5'd0) ? 32'd0 :
		                    ((E_Instr[20:16] == M_A3) && (M_RfWr == 1))? M_WD : 
								  ((E_Instr[20:16] == W_A3) && (W_RfWr == 1))? W_WD : E_V2;
								  
		  assign ALU_B = (Src_ALU_B == 3'b001)? E_imm : E_FW_Rt;
		  
		  assign E_EXCcode = (E_old_EXCcode != 5'd0)? E_old_EXCcode : E_cal_ov? 5'd12 : 5'd0;
	 
	// M stage :
	 M_Reg mips_M_Reg(
	     .clk(clk),
		  .reset(reset),
		  .E_Instr(E_Instr),
		  .E_ALU_result(E_ALU_result),
		  .E_MDU_out(MDU_out),
		  .E_PC(E_PC),
		  .E_V2(E_FW_Rt),
		  .E_BD(E_BD),
		  .E_EXCcode(E_EXCcode),
		  .E_DM_ov(E_DM_ov),
		  .Req(Req),
		  .M_BD(M_BD), //*
		  .M_EXCcode(M_old_EXCcode),
		  .M_DM_ov(M_DM_ov),
		  .M_Instr(M_Instr),
		  .M_PC(M_PC),
		  .M_ALU_result(M_ALU_result),
		  .M_MDU_out(M_MDU_out),
		  .M_V2(M_V2)
	 );
	 
	 CU mips_M_CU(
	     .Instr(M_Instr), 
		  .RF_WD_type(M_RF_WD_type),
		  .store_type(store_type),
		  .load_type(load_type),
		  .RfWr(M_RfWr),
		  .A3(M_A3),
		  .eret(M_eret),
		  .CP0_WE(CP0_WE),
		  .DMWr(DMWr)
	 );
	
	 assign M_WD = (M_RF_WD_type == 4'b0000 )? M_ALU_result :
	               (M_RF_WD_type == 4'b0001 )? M_ALU_result : 
						(M_RF_WD_type == 4'b0100 )? M_MDU_out : 
	               (M_RF_WD_type == 4'b0011 )? M_PC + 8 : 0;
						
	 assign M_EXCcode = (M_old_EXCcode != 5'd0)? M_old_EXCcode :
	                    M_AdEL? 5'd4 : M_AdES? 5'd5 : 5'd0;
							  
	 //M_DM M_DM(
	     //.clk(clk),
		  //.reset(reset),
		  //.addr(M_ALU_result),
		  //.data(M_FW_Rt),
		  //.WE(DMWr),
		  //.pc(M_PC),
		//  .outdata(DM_data)
	// );
	      //assign m_data_wdata = M_FW_Rt;
			
			assign macroscopic_pc = M_PC;
	      assign m_data_addr = M_ALU_result;
			assign m_inst_addr = M_PC;
			
    BE BE(
        .store_type(store_type),
		  .wdata(M_FW_Rt),
		  .Req(Req),
		  .m_data_wdata(m_data_wdata),
        .m_data_addr_byte(m_data_addr[1:0]),
		  .addr(m_data_addr),
        .byteen(m_data_byteen),
        .M_DM_ov(M_DM_ov),
        .M_AdES(M_AdES)		  
			);
	 DE DE(
	     .load_type(load_type),
		  .addr(m_data_addr),
		  .A(m_data_addr[1:0]),
		  .Din(m_data_rdata),
		  .Dout(DM_data),
		  .M_DM_ov(M_DM_ov),
		  .M_AdEL(M_AdEL)
	 );
         assign M_FW_Rt = (M_Instr[20:16] == 5'd0)? 32'd0 :
			                 ((M_Instr[20:16] == W_A3) && (W_RfWr == 1))? W_WD : M_V2;
								  
    CP0 CP0(
	     .CP0_add(M_Instr[15:11]),
		  .CP0_in(M_FW_Rt),
		  .VPC(M_PC),
		  .ExcCodeIn(M_EXCcode),
		  .HWInt(HWInt),
		  .en(CP0_WE),
		  .EXLClr(M_eret),
		  .clk(clk),
		  .reset(reset),
		  .BDIn(M_BD),
		  .Req(Req),
		  .EPCout(EPC_out),
		  .EBaseout(EBase),
		  .CP0_out(M_CP0_out)
	 );
								  
	 // W stage :
	 W_Reg W_Reg(
	     .clk(clk),
		  .reset(reset),
		  .Req(Req),
		  .M_Instr(M_Instr),
		  .M_PC(M_PC),
		  .M_MDU_out(M_MDU_out),
		  .M_ALU_result(M_ALU_result),
		  .M_data(DM_data),
		  .M_CP0(M_CP0_out),
		  .W_CP0(W_CP0_out),
		  .W_Instr(W_Instr),
		  .W_PC(W_PC),
		  .W_MDU_out(W_MDU_out),
		  .W_data(W_DM_data),
		  .W_ALU_result(W_ALU_result)
	 );
	
	 CU mips_W_CU(
	     .Instr(W_Instr),
		  .RF_WD_type(W_RF_WD_type),
		  .A3(W_A3),
		  .RfWr(W_RfWr)
	 );
	 
	 assign w_grf_we = W_RfWr;
	 assign w_grf_addr = W_A3;
	 assign w_grf_wdata = W_WD;
	 assign w_inst_addr = W_PC;
	 assign W_WD = (W_RF_WD_type == 4'b0000 || W_RF_WD_type == 4'b0001)? W_ALU_result :
	               (W_RF_WD_type == 4'b0011 )? W_PC + 8 : (W_RF_WD_type == 4'b0010)? W_DM_data :
						(W_RF_WD_type == 4'b0100 )? W_MDU_out : 
						(W_RF_WD_type == 4'b0101 )? W_CP0_out : 32'd0;

	 Stall SU(
	     .D_Instr(D_Instr),
		  .E_Instr(E_Instr),
		  .M_Instr(M_Instr),
		  .W_Instr(W_Instr),
		  .busy(busy),
		  .start(start),
		  .stall(stall)
	 );
	 	 assign F_en = !stall;
		 assign D_Reg_en = !stall;
       assign E_reset = stall;
		 
endmodule
