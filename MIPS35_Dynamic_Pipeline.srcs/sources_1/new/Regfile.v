`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2022 05:13:46 PM
// Design Name: 
// Module Name: Regfile
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

module Regfile(
    input clk,
    input rst,
    input [`i5] waddr,
    input [`i32] wdata,
    input rf_wena, // 写使能信号
    input [`i5] raddr1, // 读地址1
    input [`i5] raddr2, // 读地址2
    input rf_rena1, // 读使能信号1
    input rf_rena2, // 读使能信号2
    output reg [`i32] rdata1, // 读出数据1
    output reg [`i32] rdata2  // 读出数据2
    );

reg [`i32] registers[31:0];

// 在时钟上升沿写入
always @ (posedge clk) begin
    if(rst) begin
        registers[0] <= 32'b0;
        registers[1] <= 32'b0;
        registers[2] <= 32'b0;
        registers[3] <= 32'b0;
        registers[4] <= 32'b0;
        registers[5] <= 32'b0;
        registers[6] <= 32'b0;
        registers[7] <= 32'b0;
        registers[8] <= 32'b0;
        registers[9] <= 32'b0;
        registers[10] <= 32'b0;
        registers[11] <= 32'b0;
        registers[12] <= 32'b0;
        registers[13] <= 32'b0;
        registers[14] <= 32'b0;
        registers[15] <= 32'b0;
        registers[16] <= 32'b0;
        registers[17] <= 32'b0;
        registers[18] <= 32'b0;
        registers[19] <= 32'b0;
        registers[20] <= 32'b0;
        registers[21] <= 32'b0;
        registers[22] <= 32'b0;
        registers[23] <= 32'b0;
        registers[24] <= 32'b0;
        registers[25] <= 32'b0;
        registers[26] <= 32'b0;
        registers[27] <= 32'b0;
        registers[28] <= 32'b0;
        registers[29] <= 32'b0;
        registers[30] <= 32'b0;
        registers[31] <= 32'b0;
    end
    else begin
        if(rf_wena && (waddr != 5'd0)) begin// 不写0号寄存器 
            registers[waddr] <= wdata;
        end
    end
end

// 读出rdata1
always @ (*) begin
    if(rst) begin
        rdata1 <= 32'd0;
    end 
    else if(!rf_rena1) rdata1 <= 32'd0;
    else if(raddr1 == 5'd0) rdata1 <= 32'd0;
    else if((raddr1 == waddr) && rf_wena) rdata1 <= wdata; // 数据前推
    else rdata1 <= registers[raddr1];
end

// 读出rdata2
always @ (*) begin
    if(rst) begin
        rdata2 <= 32'd0;
    end 
    else if(!rf_rena2) rdata2 <= 32'd0;
    else if(raddr2 == 5'd0) rdata2 <= 32'd0;
    else if((raddr2 == waddr) && rf_wena) rdata2 <= wdata; // 数据前推
    else rdata2 <= registers[raddr2];
end

endmodule
