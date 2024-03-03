`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:05:04 11/14/2022 
// Design Name: 
// Module Name:    mips 
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
    input reset,
    input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3:0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
    );

	 wire [31:0] F_PC, F_Instr;
	 wire F_en;
	 wire lwm;
	 // W
	 wire [3:0] W_RF_WD_type;
	 wire [31:0] W_WD;
	 wire [31:0] W_Instr, W_PC, W_DM_data, W_ALU_result;
	 wire [4:0] W_A3;
	 wire W_RfWr;
	 wire [31:0] W_MDU_out;
	 wire W_CMP_result;
	 wire [31:0] W_V2, W_V1;
	 wire W_ALU_check;
	 
	 // M
	 wire [31:0] M_WD;
	 wire [31:0] DM_data;
	 wire DMWr;
	 wire [4:0] M_A1, M_A2;
	 wire [3:0] M_RF_WD_type;
	 wire [4:0] M_A3;
	 wire M_RfWr;
	 wire [31:0] M_Instr, M_PC, M_ALU_result, M_V2, M_V1;
	 wire [31:0] M_FW_Rt;
	 wire [2:0] store_type, load_type;
	 wire [31:0] M_MDU_out;
	 wire M_CMP_result;
	 wire M_DM_judge;
	 wire M_jap;
	 wire M_ALU_check;
	 
	 // D
	 wire [31:0] D_Instr, D_PC;
	 wire [4:0] D_A1, D_A2;
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
	 wire D_CMP_result;
	 wire delay_clr;
	 wire [31:0] dm;
	 wire [31:0] dm1;
	 // E
	 wire [4:0] E_A3, E_A1, E_A2;
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
	 wire E_CMP_result;
	 wire E_ALU_check;
	 
	 // stall
	 wire stall;

	 // F stage :
    IFU IFU(
	     .clk(clk),
		  .F_en(F_en),
		  .NPC(out_NPC),
		  .reset(reset),
		  .F_PC(F_PC)
	 );
	     assign i_inst_addr = F_PC;
		  assign F_Instr = (delay_clr == 1'd1)? 32'd0 : i_inst_rdata;
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
	     .A1(D_A1),
		  .A2(D_A2),
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
		  .cmp_result(D_CMP_result),
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
		  .b_type(b_type),
		  .D_CMP_result(D_CMP_result),
		  .zero(zero)
	 );
	 CU mips_D_CU(
	     .Instr(D_Instr),
		  .NPCOp(NPCOp),
		  .A1(D_A1),
		  .A2(D_A2),
		  .ExtOp(ExtOp),
		  .b_type(b_type),
		  .delay_clr(delay_clr),
		  .A3(D_A3)
	 );
	        assign D_FW_Rs = (D_A1 == 5'd0)? 32'd0 :
			                   (D_A1 == E_A3)? E_WD : 
			                   (D_A1 == M_A3)? M_WD :
									  D_RF_RD1;
			  assign D_FW_Rt = (D_A2 == 5'd0)? 32'd0 :
			                   (D_A2 == E_A3)? E_WD : 
			                   (D_A2 == M_A3)? M_WD :
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
		  .D_CMP_result(D_CMP_result),
		  .E_CMP_result(E_CMP_rusult),
		  .E_PC(E_PC),
		  .E_imm(E_imm),
		  .E_Instr(E_Instr),
		  .E_A1(E_A1),
		  .E_V1(E_V1),
		  .E_V2(E_V2)
	 );
	 MDU MDU(
	     .clk(clk),
		  .reset(reset),
		  .D1(E_FW_Rs),
		  .D2(E_FW_Rt),
		  .MDUOp(MDUOp),
		  .start(start),
		  .busy(busy),
		  .out(MDU_out)
		  
	 );
	
	 CU mips_E_CU(
	     .Instr(E_Instr),
		  .CMP_result(E_CMP_result),
		  .ALU_check(E_ALU_check),
		  .A1(E_A1),
		  .A2(E_A2),
		  .DM_judge(1'bx),
		  .RF_WD_type(E_RF_WD_type),
		  .RfWr(E_RfWr),
		  .Src_ALU_B(Src_ALU_B),
		  .A3(E_A3),
		  .MDUOp(MDUOp),
		  .ALUOp(E_ALUOp)
	 );
	


	 E_ALU E_ALU(
	     .ALU_A(E_FW_Rs),
		  .ALU_B(ALU_B),
		  .ALUOp(E_ALUOp),
		  .ALU_check(E_ALU_check),
		  .out(E_ALU_result)
	 );
	 
	     assign E_WD = (E_RF_WD_type == 4'b0001)? E_imm :
	                      (E_RF_WD_type == 4'b0011)? E_PC + 8 : 0;
								 
	     assign E_FW_Rs =  (E_A1 == 5'd0) ? 32'd0 :
		                    (E_A1 == M_A3)? M_WD : 
								  (E_A1 == W_A3)? W_WD : E_V1;
								  
		  assign E_FW_Rt =  (E_A2 == 5'd0) ? 32'd0 :
		                    (E_A2 == M_A3)? M_WD : 
								  (E_A2 == W_A3)? W_WD : E_V2;
								  
		  assign ALU_B = (Src_ALU_B == 3'b001)? E_imm : E_FW_Rt;
	 
	// M stage :
	 M_Reg mips_M_Reg(
	     .clk(clk),
		  .reset(reset),
		  .E_Instr(E_Instr),
		  .E_ALU_result(E_ALU_result),
		  .E_MDU_out(MDU_out),
		  .E_PC(E_PC),
		  .E_V2(E_FW_Rt),
		  .E_V1(E_FW_Rs),
		  .E_CMP_result(E_CMP_result),
		  .E_ALU_check(E_ALU_check),
		  .M_ALU_check(M_ALU_check),
		  .M_CMP_result(M_CMP_result),
		  .M_Instr(M_Instr),
		  .M_PC(M_PC),
		  .M_ALU_result(M_ALU_result),
		  .M_MDU_out(M_MDU_out),
		  .M_V2(M_V2),
		  .M_V1(M_V1)
	 );
	 
	 CU mips_M_CU(
	     .Instr(M_Instr),
		  .dm(dm[4:0]),
		  .CMP_result(M_CMP_result),
		  .ALU_check(M_ALU_check),
		  .A1(M_A1),
		  .A2(M_A2),
		  .DM_judge(M_DM_judge),
		  .RF_WD_type(M_RF_WD_type),
		  .store_type(store_type),
		  .load_type(load_type),
		  .RfWr(M_RfWr),
		  .A3(M_A3),
		  .lwm(lwm),
		  .jap(M_jap),
		  .DMWr(DMWr)
	 );
	
	 assign M_WD = (M_RF_WD_type == 4'b0000 )? M_ALU_result :
	               (M_RF_WD_type == 4'b0001 )? M_ALU_result : 
						(M_RF_WD_type == 4'b0100 )? M_MDU_out : 
	               (M_RF_WD_type == 4'b0011 )? M_PC + 8 : 0;
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
			
			assign M_DM_judge = (lwm == 1)? 1:0;
			 
	      assign m_data_addr = (M_jap == 1)? M_V2 : M_ALU_result;
			assign m_inst_addr = M_PC;
			
    BE BE(
        .store_type(store_type),
		  .PC(M_PC),
		  .wdata(M_FW_Rt),
		  .m_data_wdata(m_data_wdata),
        .m_data_addr_byte(m_data_addr[1:0]),
        .byteen(m_data_byteen)		  
			);
	 DE DE(
	     .load_type(load_type),
		  .A(m_data_addr[1:0]),
		  .Din(m_data_rdata),
		  .Dout(DM_data)
	 );
         assign M_FW_Rt = (M_A2 == 5'd0)? 32'd0 :
			                 (M_A2 == W_A3)? W_WD : M_V2;
			assign dm = (DM_data - M_V2);
								  
	 // W stage :
	 W_Reg W_Reg(
	     .clk(clk),
		  .reset(reset),
		  .M_Instr(M_Instr),
		  .M_PC(M_PC),
		  .M_MDU_out(M_MDU_out),
		  .M_ALU_result(M_ALU_result),
		  .M_data(DM_data),
		  .M_CMP_result(M_CMP_result),
		  .M_DM_judge(M_DM_judge),
		  .M_ALU_check(M_ALU_check),
		  .M_V2(M_V2),
		  .M_V1(M_V1),
		  .W_V1(W_V1),
		  .W_V2(W_V2),
		  .W_DM_judge(W_DM_judge),
		  .W_ALU_check(W_ALU_check),
		  .W_CMP_result(W_CMP_result),
		  .W_Instr(W_Instr),
		  .W_PC(W_PC),
		  .W_MDU_out(W_MDU_out),
		  .W_data(W_DM_data),
		  .W_ALU_result(W_ALU_result)
	 );
	
	 CU mips_W_CU(
	     .Instr(W_Instr),
		  .dm(dm1[4:0]),
		  .CMP_result(W_CMP_result),
		  .ALU_check(W_ALU_check),
		  .DM_judge(W_DM_judge),
		  .RF_WD_type(W_RF_WD_type),
		  .A3(W_A3),
		  .RfWr(W_RfWr)
	 );
	 assign dm1 = (W_DM_data - W_V2);
	 
	 assign w_grf_we = W_RfWr;
	 assign w_grf_addr = W_A3;
	 assign w_grf_wdata = W_WD;
	 assign w_inst_addr = W_PC;
	 
	 assign W_WD = (W_RF_WD_type == 4'b0000 || W_RF_WD_type == 4'b0001)? W_ALU_result :
	               (W_RF_WD_type == 4'b0011)? W_PC + 8 : (W_RF_WD_type == 4'b0010)? W_DM_data :
						(W_RF_WD_type == 4'b0100 )? W_MDU_out : 0;

	 Stall SU(
	     .D_Instr(D_Instr),
		  .E_Instr(E_Instr),
		  .M_Instr(M_Instr),
		  .W_Instr(W_Instr),
		  .E_A3(E_A3),
		  .M_A3(M_A3),
		  .busy(busy),
		  .start(start),
		  .stall(stall)
	 );
	 	 assign F_en = !stall;
		 assign D_Reg_en = !stall;
       assign E_reset = stall;
endmodule
