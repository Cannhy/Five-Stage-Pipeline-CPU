`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:57 11/07/2022 
// Design Name: 
// Module Name:    D_NPC 
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
module D_NPC(
    input zero,
	 input cmp_result,
    input [25:0] imm,
    input branch,
    input j,
    input [31:0] D_Rs,
    input [31:0] D_PC,
	 input [2:0] NPCOp,
    input [31:0] F_PC,
    input jr,
    output reg[31:0] out_NPC
    );
	 always@(*)begin
        if(NPCOp==3'b001 && zero == 1) begin
		      out_NPC = D_PC + 32'd4 + {{14{imm[15]}},imm[15:0],2'b00};
		  end
		  else if(NPCOp == 3'b010) begin
		      out_NPC = {D_PC[31:28],imm,2'b00};
		  end
		  else if (NPCOp == 3'b011) begin
		      out_NPC = D_Rs;
		  end
		  else if(NPCOp == 3'b100 && zero == 1)begin
		      out_NPC = D_PC + 32'd4 + {{14{imm[15]}},imm[15:0],2'b00};
		  end
		  else if(NPCOp == 3'b101)begin
		      out_NPC = {D_PC[31:28],imm,2'b00};
		  end
		  else if(NPCOp == 3'b110 && cmp_result == 1)begin
		      out_NPC = D_PC + 32'd4 + {{14{imm[15]}},imm[15:0],2'b00};
		  end
		  else 
		      out_NPC = F_PC +4;
	 end	

endmodule
