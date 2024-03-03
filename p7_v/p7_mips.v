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
    input clk,                    // 时钟信号
    input reset,                  // 同步复位信号
    input interrupt,              // 外部中断信号
    output [31:0] macroscopic_pc, // 宏观 PC

    output [31:0] i_inst_addr,    // IM 读取地址（取指 PC）
    input  [31:0] i_inst_rdata,   // IM 读取数据

    output [31:0] m_data_addr,    // DM 读写地址
    input  [31:0] m_data_rdata,   // DM 读取数据
    output [31:0] m_data_wdata,   // DM 待写入数据
    output [3 :0] m_data_byteen,  // DM 字节使能信号

    output [31:0] m_int_addr,     // 中断发生器待写入地址
    output [3 :0] m_int_byteen,   // 中断发生器字节使能信号

    output [31:0] m_inst_addr,    // M 级 PC

    output w_grf_we,              // GRF 写使能信号
    output [4 :0] w_grf_addr,     // GRF 待写入寄存器编号
    output [31:0] w_grf_wdata,    // GRF 待写入数据

    output [31:0] w_inst_addr     // W 级 PC
);
    
	 wire Int_response, TC0_WE, TC1_WE, TC0_IRQ,TC1_IRQ;

	 
	 wire [31:0] TC0_addr, TC1_addr, TC0_WD, TC1_WD, TC0_out, TC1_out;
	 
	 wire [31:0] Pr_addr, Pr_WD, Pr_rdata;
	 //wire Pr_WE;
	 wire [3:0] Pr_byteen;
	 wire [5:0] HWInt;
	 
	         assign HWInt = {3'b000, interrupt, TC1_IRQ, TC0_IRQ};
	 
	 CPU CPU (
    .clk(clk), //
    .reset(reset), //
    .HWInt(HWInt), 
    .i_inst_rdata(i_inst_rdata), //
    .m_data_rdata(Pr_rdata), //////
    //.Int_response(Int_response), //
    .i_inst_addr(i_inst_addr), //
    .m_data_addr(Pr_addr), //
    .m_data_wdata(Pr_WD), //
    .m_data_byteen(Pr_byteen), //
    .m_inst_addr(m_inst_addr), //
    .w_grf_we(w_grf_we), //
    .w_grf_addr(w_grf_addr), //
    .w_grf_wdata(w_grf_wdata), //
    .w_inst_addr(w_inst_addr), //
    .macroscopic_pc(macroscopic_pc)//
    );
	 
	 TC TC0 (
    .clk(clk), //
    .reset(reset),// 
    .Addr(TC0_addr[31:2]),// 
    .WE(TC0_WE), //
    .Din(TC0_WD), //
    .Dout(TC0_out), //
    .IRQ(TC0_IRQ)//
    );
	 
	 TC TC1 (
    .clk(clk), //
    .reset(reset), //
    .Addr(TC1_addr[31:2]),// 
    .WE(TC1_WE), //
    .Din(TC1_WD), //
    .Dout(TC1_out), //
    .IRQ(TC1_IRQ)//
    );
	 
	 p7_Bridge Bridge (
    .Pr_addr(Pr_addr), //
    .Pr_WD(Pr_WD), //
    //.Pr_WE(Pr_WE), 
    .Pr_byteen(Pr_byteen),// 
    .m_data_rdata(m_data_rdata), //
    .TC0_out(TC0_out), //
    .TC1_out(TC1_out), //
    //.Int_response(Int_response), //// 
    .Pr_rdata(Pr_rdata), //
    .m_data_byteen(m_data_byteen), //
    .m_data_addr(m_data_addr), //
    .m_data_wdata(m_data_wdata), //
	 .m_int_addr(m_int_addr),//
	 .m_int_byteen(m_int_byteen),//
    .TC0_WE(TC0_WE), //
    .TC1_WE(TC1_WE), //
    .TC0_addr(TC0_addr), //
    .TC0_WD(TC0_WD), //
    .TC1_addr(TC1_addr), //
    .TC1_WD(TC1_WD)//
    );

endmodule
