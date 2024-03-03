`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:30:33 11/14/2022 
// Design Name: 
// Module Name:    p6_CU 
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
module CU(
    input [31:0] Instr,
	 input CMP_result,
	 input DM_judge,
	 input ALU_check,
	 input [4:0] dm,
    output RfWr,
    output [1:0]ExtOp,
    output DMWr,
    output [3:0] ALUOp,
	 output [2:0] Src_ALU_A,
    output [2:0] Src_ALU_B,
    output [2:0] NPCOp,
	 output [4:0]A1,
	 output [4:0]A2,
	 output [4:0]A3,
	 output [3:0] RF_WD_type,
	 output [1:0] tuse_rs,
	 output [1:0] tuse_rt,
	 output [1:0] E_tnew,
	 output [1:0] M_tnew,
	 output [3:0] MDUOp,
	 output load,
	 output store,
	 output branch,
	 output cal_r,
	 output cal_i,
	 output lui_type,
	 output shifts,
	 output shiftv,
	 output setlt,
	 output j_imm,
	 output j_r,
	 output md,
	 output mt,
	 output mf,
	 output lwm,
	 output [2:0] store_type,
	 output [2:0] load_type,
	 output [2:0] b_type,
	 output tjcc,
	 output jap,
	 output delay_clr
    );
	 
	 `define ALU_result 4'b0000
	 `define imm 4'b0001
	 `define DM_out 4'b0010
	 `define PC 4'b0011
	 `define MDU_out 4'b0100
	 
	 `define add 4'b0000
	 `define jianfa 4'b0001
	 `define huo 4'b0010
	 `define yu 4'b0011
	 `define st 4'b0100
	 `define stu 4'b0101
	 `define mult 4'd1
	 `define multu 4'd2
	 `define div 4'd3
	 `define divu 4'd4
	 `define mfhi 4'd5
	 `define mflo 4'd6
	 `define mthi 4'd7
	 `define mtlo 4'd8
	 
	 wire add, sub, andd, orr, slt, sltu, lui;
	 wire addi, andi, ori;
	 wire lb, lh, lw, sb, sh, sw;
	 wire mult, multu, div, divu, mfhi, mflo, mthi, mtlo;
	 wire beq, bne, jal, jr;
	 wire R_type;
	 wire [5:0] opcode,funct;
	 wire bds;
	 
	 assign opcode = Instr[31:26];
	 assign funct = Instr[5:0];
	 assign R_type = (opcode == 6'b000000)? 1 : 0;
	 
	 // Instruction
	 
	 assign add = (funct == 6'b100000 && R_type == 1)? 1 : 0;
	 assign sub = (funct == 6'b100010 && R_type == 1)? 1 : 0;
	 assign andd = (R_type == 1 && funct == 6'b100100)? 1 : 0;
	 assign orr = (R_type == 1 && funct == 6'b100101)? 1 : 0;
	 assign slt = (R_type == 1 && funct == 6'b101010)? 1 : 0;
	 assign sltu = (R_type == 1 && funct == 6'b101011)? 1 : 0;
	 assign lui = (opcode == 6'b001111)? 1 : 0;
	 assign addi = (opcode == 6'b001000)? 1 : 0;
	 assign andi =(opcode == 6'b001100)? 1 : 0;
    assign ori = (opcode == 6'b001101 )? 1 : 0;
	 assign lb = (opcode == 6'b100000 )? 1 : 0;
	 assign lh = (opcode == 6'b100001 )? 1 : 0;
	 assign lw = (opcode == 6'b100011 )? 1 : 0;
	 assign sb = (opcode == 6'b101000 )? 1 : 0;
	 assign sh = (opcode == 6'b101001 )? 1 : 0;
	 assign sw = (opcode == 6'b101011 )? 1 : 0;
	 assign mult = (R_type == 1 && funct == 6'b011000)? 1 : 0;
	 assign multu = (R_type == 1 && funct == 6'b011001)? 1 : 0;
	 assign div = (R_type == 1 && funct == 6'b011010)? 1 : 0;
	 assign divu = (R_type == 1 && funct == 6'b011011)? 1 : 0;
	 assign mfhi = (R_type == 1 && funct == 6'b010000)? 1 : 0;
	 assign mflo = (R_type == 1 && funct == 6'b010010)? 1 : 0;
	 assign mthi = (R_type == 1 && funct == 6'b010001)? 1 : 0;
	 assign mtlo = (R_type == 1 && funct == 6'b010011)? 1 : 0;
	 assign beq = (opcode == 6'b000100 )? 1 : 0;
	 assign bne = (opcode == 6'b000101)? 1 : 0;
	 assign jal = (opcode == 6'b000011)? 1 : 0;
	 assign jr = (R_type == 1  && funct == 6'b001000)? 1 : 0 ;
	 assign nop = (Instr == 32'd0)? 1 : 0;
	 assign jap = (opcode == 6'b110110)? 1 : 0;
	 assign bds = (R_type == 1 && funct == 6'b001010)? 1 : 0;
	 wire btheq;
	 assign btheq = (opcode == 6'b101111)? 1:0;
	 assign lwm = (opcode == 6'b101100)?1 :0;
	 
	 // control
	 
	 assign RfWr = (cal_r | cal_i | lui_type | load | mf | j_imm | setlt | jap | lwm)? 1 : 0;

	 assign ExtOp = (lui == 1)? 2'b10 : (andi | ori) ? 2'b01 : 2'b00;
	 
	 assign DMWr = (store == 1 || jap == 1)? 1: 0;
	 
	 assign ALUOp = (branch | sub )? `jianfa : 
	                (ori | orr )? `huo : 
						 (andd | andi)? `yu : 
						 (slt == 1)? `st : 
						 (sltu == 1)? `stu : 
						 (jap == 1)? 4'b0110 : 
						 `add;
	 
	 assign Src_ALU_A = (jap)? 3'b001 : 3'b000;
	 
	 assign Src_ALU_B = (cal_i | load | store | lui | lwm)? 3'b001 : 3'b000;

	 assign NPCOp = (beq == 1)? 3'b001 :
	                (jal == 1)? 3'b010 :
						 (jr == 1) ? 3'b011 : 
						 (bne == 1)? 3'b100 : 
						 (jap == 1)? 3'b101 : 
						 (btheq == 1)? 3'b110 : 3'b000;
						 
	 assign A1 = (jap == 1)? 5'd0 : Instr[25:21];
	 assign A2 = (jap == 1)? 5'd29 : Instr [20:16];
	 assign A3 = (add | sub | andd | orr | setlt | mf)? Instr[15:11] : 
	             (cal_i | load | lui_type)? Instr[20:16] :
					 (lwm == 1 && DM_judge === 1 )? dm :
					 jal? 5'd31 : 
					 jap? 5'd29 :  
					 5'd0;
					 
					 //(lwie == 1 && judge === 1'd1)? Instr[20:16] :
                //(lwie == 1 && judge === 1'd0)? 5'd31 :
					 
	 assign RF_WD_type = (load == 1 || lwm == 1)? `DM_out : //0010
	                     (lui == 1)? `imm :    //0001
								(jal == 1)? `PC :    //0011
								(mf == 1)? `MDU_out : //0100
								`ALU_result;  //0000
								           
    assign tuse_rs = (cal_r | load | store | cal_i | md | mt |bds | lwm)? 2'b01 :
	                  (branch | jr | btheq)? 2'b00 : 2'b11;
							
	 assign tuse_rt = (branch | btheq)? 2'b00 : 
	                  (md | cal_r | jap |bds)? 2'b01 : (store)? 2'b10 : 2'b11;
							
    assign E_tnew = ( cal_r | cal_i | mf | jap)? 2'b01 :
	                   (load | lwm)? 2'b10 : 2'b00;
							 
	 assign M_tnew = (load | lwm)? 2'b01 : 2'b00;
	 
	 assign load = (lb | lh | lw);
	 
	 assign store = (sb| sh | sw);
	 
	 assign setlt = (slt | sltu);
	 
	 assign branch = beq | bne;
	 
	 assign cal_r = (add | sub | andd | orr | slt | sltu );
	 
	 assign cal_i = (addi | andi | ori );
	 
	 assign lui_type = lui;
	 
	 assign md = mult | multu | div | divu;
	 
	 assign mt = (mthi | mtlo);
	 
	 assign mf = (mfhi | mflo);
	 
	 assign j_imm = jal;
	 
	 assign j_r = jr;
	 
	 assign store_type = sw? 3'b000 : sh? 3'b001 : sb? 3'b010 : jap? 3'b011 : 3'b111 ;
	 
	 assign load_type = lw? 3'b000 : lh? 3'b100 : lb? 3'b010 : lwm? 3'b011 : 3'b111;
	 
	 assign b_type = beq? 3'd0 : 
	                 bne? 3'd1 : 3'd7;
	 
	 assign MDUOp = mult? `mult : 
	                multu? `multu :
						 div? `div :
						 divu? `divu : 
						 mfhi? `mfhi :
						 mflo? `mflo :
						 mthi? `mthi :
						 mtlo? `mtlo : 
						 bds? 4'd9 : 
						 4'd0;
						 
    assign tjcc = (lwm == 1)? 1 : 0;
	 

	 
	 assign delay_clr = 1'd0;           // clear the branch delay

endmodule
