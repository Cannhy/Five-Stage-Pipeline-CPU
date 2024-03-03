`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:35:46 11/07/2022 
// Design Name: 
// Module Name:    CU 
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
	 input jump,
	 input judge,
	 input [4:0] dm,
    output RfWr,
    output [1:0]ExtOp,
    output DMWr,
    output [2:0] ALUOp,
    output [2:0] Src_ALU_B,
    output [2:0] NPCOp,
	 output [4:0]A1,
	 output [4:0]A2,
	 output [4:0]A3,
	 output b_clr,
	 output [1:0] RF_WD_type,
	 output [1:0] tuse_rs,
	 output [1:0] tuse_rt,
	 output [1:0] E_tnew,
	 output lwtt,
	 output [1:0] M_tnew,
	 output [2:0] load_type,
	 output [2:0] store_type
    );
	
	 `define ALU_result 2'b00
	 `define imm 2'b01
	 `define DM_out 2'b10
	 `define PC 2'b11
	 
	 `define add 3'b000
	 `define jianfa 3'b001
	 `define huo 3'b010
	 wire add,sub,andd,ori,lw,sw,beq,lui,jal,jr,nop,addei,bioal,ltb;
	 wire R_type;
	 wire [5:0] opcode,funct;
	 
	 assign opcode = Instr[31:26];
	 assign funct = Instr[5:0];
	 assign R_type = (opcode == 6'b000000)? 1 : 0;
	 assign add = (funct == 6'b100000 && R_type == 1)? 1 : 0;
	 assign sub = (funct == 6'b100010 && R_type == 1)? 1 : 0;
    assign ori = (opcode == 6'b001101 )? 1 : 0;
	 assign lw = (opcode == 6'b100011 )? 1 : 0;
	 assign sw = (opcode == 6'b101011 )? 1 : 0;
	 assign beq = (opcode == 6'b000100 )? 1 : 0;
	 assign lui = (opcode == 6'b001111)? 1 : 0;
	 assign jal = (opcode == 6'b000011)? 1 : 0;
	 assign jr = (R_type == 1  && funct == 6'b001000)? 1 : 0 ;
	 assign nop = (Instr == 32'd0)? 1 : 0;
	 assign addei = (opcode == 6'b110011)? 1 : 0;//////
	 assign bioal = (opcode == 6'b101101)? 1 : 0;
	 assign lwie = (opcode == 6'b111001)? 1 :0;
	 assign RfWr = (add || sub || ori || lw || lui || jal || addei || (bioal == 1&& jump === 1'd1) || lwie)? 1 : 0;

	 assign ExtOp = addei? 2'b11 : (lui == 1)? 2'b10 : (lw || sw || lwie) ? 2'b01 : 2'b00;
	 
	 assign DMWr = (sw == 1)? 1: 0;
	 
	 assign ALUOp = (beq || sub)? `jianfa : 
	                 ori? `huo : 
						  addei? 3'b011 : `add;
	 
	 assign Src_ALU_B = (ori || lw || sw || lui || lwie || addei)? 3'b001 : 3'b000;

	 assign NPCOp = (beq == 1)? 3'b001 :
	                (jal == 1)? 3'b010 :
						 (jr == 1) ? 3'b011 : 
						 (bioal == 1)? 3'b100 : 3'b000;
						 
	 assign A1 = Instr[25:21];
	 assign A2 = Instr [20:16];
	 assign A3 = (add || sub )? Instr[15:11] : 
	             (ori || lui || lw || addei)? Instr[20:16] :
					 (jal | ((bioal == 1)&& (jump == 1)))? 5'd31 : 
                (lwie == 1 && judge === 1'd1)? Instr[20:16] :
                (lwie == 1 && judge === 1'd0)? 5'd31 :					 
					 5'd0;
					 
	 assign RF_WD_type = (lw == 1 || lwie)? `DM_out : 
	                     (lui == 1)? `imm :
								(jal == 1 | bioal == 1)? `PC : `ALU_result;
								
    assign tuse_rs = (sub | add | ori | lw | sw | addei | lwie)? 2'b01 :
	                  (beq | jr | bioal)? 2'b00 : 2'b11;
							
	 assign tuse_rt = (beq | bioal)? 2'b00 : 
	                  (add | sub )? 2'b01 : (sw)? 2'b10 : 2'b11;
							
    assign E_tnew = ( add | sub | ori | addei)? 2'b01 :
	                   (lw| lwie)? 2'b10 : 2'b00;
							 
	 assign M_tnew = (lw | lwie)? 2'b01 : 2'b00;
	 
	 assign b_clr = 1'b0;
	 
	 assign load_type = (lwie == 1)? 3'd1 : 3'd0;
	 
	 assign store_type = 3'd0;
	 
	 assign lwtt = (lwie == 1);
	 
endmodule
