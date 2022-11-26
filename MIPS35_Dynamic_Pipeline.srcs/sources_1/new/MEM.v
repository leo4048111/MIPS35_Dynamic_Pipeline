`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2022 02:25:11 PM
// Design Name: 
// Module Name: MEM
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

module MEM(
    input rst,
    input [`i32] i_wdata, // 运算结果输入
    input i_rf_wena, // 写入使能信号输入
    input [`i5] i_waddr, // EX的写入地址输入
    input LW,
    input [`i32] DM_RData,
    output [`i32] wdata, // 运算结果输出
    output rf_wena, // 写入使能信号输出
    output [`i5] waddr // MEM的写入地址输出
    );

assign wdata = rst ? 0 : (LW ? DM_RData : i_wdata);
assign rf_wena = rst ? 0 : i_rf_wena;
assign waddr = rst ? 0 : i_waddr; 

endmodule
