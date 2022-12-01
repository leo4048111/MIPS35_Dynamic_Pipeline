`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2022 02:17:02 PM
// Design Name: 
// Module Name: EX_MEM
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

module EX_MEM(
    input clk,
    input rst,
    input [`i5] stall,
    input [`i4] flush,
    input [`i32] ex_wdata, // 来自EX的运算结果
    input ex_rf_wena, // 来自EX的写入使能信号输出
    input [`i5] ex_waddr, // 来自EX的写入地址输出
    input ex_dm_wena,
    input ex_dm_rena,
    input [`i32] ex_dm_wdata,
    input [10:0] ex_dm_addr,
    input ex_is_MULT,
    input ex_is_MULTU,
    input [`i32] ex_hi_out,
    input [`i32] ex_lo_out,
    output reg [`i32] mem_wdata, // 传递到MEM的运算结果
    output reg mem_rf_wena, // 传递到MEM的写入使能信号输出
    output reg [`i5] mem_waddr, // 传递到MEM的写入地址输出
    output reg mem_dm_wena,
    output reg mem_dm_rena,
    output reg [`i32] mem_dm_wdata,
    output reg [10:0] mem_dm_addr,
    output reg mem_is_MULT,
    output reg mem_is_MULTU,
    output reg [`i32] mem_hi_out,
    output reg [`i32] mem_lo_out
    );

always @ (posedge clk) begin
    if(rst | flush[1]) begin
        mem_wdata <= 0;
        mem_rf_wena <= 0;
        mem_waddr <= 0;
        mem_dm_wena <= 0;
        mem_dm_rena <= 0;
        mem_dm_wdata <= 0;
        mem_dm_addr <= 0;
        mem_is_MULT <= 0;
        mem_is_MULTU <= 0;
        mem_hi_out <= 0;
        mem_lo_out <= 0;
    end 
    else if(stall[1] && !stall[0]) begin
        mem_wdata <= 0;
        mem_rf_wena <= 0;
        mem_waddr <= 0;
        mem_dm_wena <= 0;
        mem_dm_rena <= 0;
        mem_dm_wdata <= 0;
        mem_dm_addr <= 0;
        mem_is_MULT <= 0;
        mem_is_MULTU <= 0;
        mem_hi_out <= 0;
        mem_lo_out <= 0;
    end
    else if(stall[1]) begin
        mem_wdata <= mem_wdata;
        mem_rf_wena <= mem_rf_wena;
        mem_waddr <= mem_waddr;
        mem_dm_wena <= mem_dm_wena;
        mem_dm_rena <= mem_dm_rena;
        mem_dm_wdata <= mem_dm_wdata;
        mem_dm_addr <= mem_dm_addr;
        mem_is_MULT <= mem_is_MULT;
        mem_is_MULTU <= mem_is_MULTU;
        mem_hi_out <= mem_hi_out;
        mem_lo_out <= mem_lo_out;
    end
    else begin
        mem_wdata <= ex_wdata;
        mem_rf_wena <= ex_rf_wena;
        mem_waddr <= ex_waddr;
        mem_dm_wena <= ex_dm_wena;
        mem_dm_rena <= ex_dm_rena;
        mem_dm_wdata <= ex_dm_wdata;
        mem_dm_addr <= ex_dm_addr;
        mem_is_MULT <= ex_is_MULT;
        mem_is_MULTU <= ex_is_MULTU;
        mem_hi_out <= ex_hi_out;
        mem_lo_out <= ex_lo_out;
    end
end

endmodule
