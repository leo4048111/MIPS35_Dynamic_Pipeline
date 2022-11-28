`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2022 09:36:42 AM
// Design Name: 
// Module Name: CP0
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "defines.v"

module CP0(
    input clk,
    input rst,
    input mfc0,             //输入指令为mfc0
    input mtc0,             //输入指令为mtc0
    input [`i32] pc,
    input [`i5] Rd,         //读取的CP0寄存器(只用到12,13或者14)
    input [`i32] wdata,     //写入数据
    input exception,
    input eret,             //eret指令
    input [`i5] cause,
    //input intr,
    output [`i32] rdata,    //输出寄存器数据
    output [`i32] status,
    //output reg timer_int,
    output [`i32] exc_addr  //中断执行地址
    );
wire status_ena, cause_ena, epc_ena; 
wire [`i32] status_in, cause_in, epc_in; 
wire [`i32] status_out, cause_out, epc_out; 
reg [`i32] reg_status, reg_cause, reg_epc;

always @ (posedge clk) begin
    if(rst) begin
        reg_status <= 32'hFFFF_FFFF;  //允许所有中断
        reg_cause <= 0;
        reg_epc <= 0;
    end
    else begin
        if(status_ena)
            reg_status <= status_in;
        if(cause_ena)
            reg_cause <= cause_in;
        if(epc_ena)
            reg_epc <= epc_in;
    end
end

assign status_out = reg_status;
assign cause_out = reg_cause;
assign epc_out = reg_epc;

wire IE, IM_SYSCALL, IM_BREAK, IM_TEQ;   
assign IE = status[0];
assign IM_SYSCALL = IE & status[8];
assign IM_BREAK = IE & status[9];
assign IM_TEQ = IE & status[10];

wire SYSCALL, BREAK, TEQ;               
assign SYSCALL = cause == 5'b01000;
assign BREAK = cause == 5'b01001;
assign TEQ = cause == 5'b01101;

wire is_status, is_cause, is_epc;       
assign is_status = Rd == 5'd12;
assign is_cause = Rd == 5'd13;
assign is_epc = Rd == 5'd14;

assign status_ena = (mtc0 & is_status) || eret || (exception & IE & ((IM_SYSCALL & SYSCALL) || (IM_BREAK & BREAK) || (IM_TEQ & TEQ)));
assign cause_ena = (mtc0 & is_cause) || (exception & IE & ((IM_SYSCALL & SYSCALL) || (IM_BREAK & BREAK) || (IM_TEQ & TEQ))) ;
assign epc_ena = (mtc0 & is_epc) || (exception & IE & ((IM_SYSCALL & SYSCALL) || (IM_BREAK & BREAK) || (IM_TEQ & TEQ)));

assign status_in = mtc0 ? wdata : (eret ? {5'b0, status_out[31:5]} : {status_out[26:0], 5'b0});
assign cause_in = mtc0 ? wdata : {25'b0, cause, 2'b0};
assign epc_in = mtc0 ? wdata : pc;

//outputs
assign rdata = mfc0 ? (is_status ? status_out : (is_cause ? cause_out : (is_epc ? epc_out : 32'bz))) : 32'bz;
assign status = status_out;
assign exc_addr = eret ? epc_out : (((IM_SYSCALL & SYSCALL) || (IM_BREAK & BREAK) || (IM_TEQ & TEQ)) ? 32'h00000004 : pc + 4);

endmodule
