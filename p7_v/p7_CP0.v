`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:42:35 12/01/2022 
// Design Name: 
// Module Name:    p6_CP0 
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
module CP0(
    input [4:0] CP0_add,
    //input [4:0] A2,
    input [31:0] CP0_in,
    input [31:0] VPC,
    input [6:2] ExcCodeIn,//
    input [5:0] HWInt,//
    input en,
    input EXLClr,
    input clk,
    input reset,
    input BDIn,
    output Req,
    output [31:0] EPCout,
	 output [31:0] EBaseout,
    output [31:0] CP0_out
    );
	 
    reg [31:0] SR, Cause, EPC, EBase;
	 
	 assign CP0_out = (CP0_add == 5'd12)? SR : 
	                  (CP0_add == 5'd13)? Cause :
							(CP0_add == 5'd14)? EPC : 
							(CP0_add == 5'd15)? EBase : 32'd0;
							
	 wire IE, EXL;
	 wire [7:2] IM;
	 wire IntReq, ExcReq;
	 
	 assign IE = SR[0];
	 assign EXL = SR[1];
	 assign IM = SR[15:10];
	 assign IntReq = (|(HWInt && IM)) & IE & !EXL;
	 assign ExcReq = (|ExcCodeIn) & !EXL;

	assign Req = IntReq | ExcReq;
    //assign Int_response = (HWInt[2] && IE && !EXL && SR[12]);
	 
	 assign EPCout = (Req && BDIn)? VPC-4 : (Req && !BDIn)? VPC : EPC;
	 
	 assign EBaseout = EBase;
	 
	 always@(posedge clk)begin
	     if(reset == 1)begin
		      SR <= 0;
				Cause <= 0;
				EPC <= 0;
				EBase <= 32'h4180;
		  end
		  else begin
		      Cause[15:10] <= HWInt;
		      if(EXLClr == 1) SR[1] <= 1'b0;
		      if(Req == 1)begin
		          SR[1] <= 1'b1;
				    Cause[31] <= BDIn;
				    EPC <= EPCout;
				    Cause[6:2] <= IntReq? 5'd0 : ExcCodeIn;
				end
		      else if(en == 1)begin
		          if(CP0_add == 5'd12) SR <= CP0_in;
					 else if(CP0_add == 5'd14) EPC <= CP0_in;
					 else if(CP0_add == 5'd15) EBase <= CP0_in;
				end
		  end
	 end
	 

endmodule