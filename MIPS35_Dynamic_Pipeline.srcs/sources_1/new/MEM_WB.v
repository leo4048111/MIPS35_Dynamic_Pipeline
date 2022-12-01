`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2022 02:31:18 PM
// Design Name: 
// Module Name: MEM_WB
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

module MEM_WB(
    input clk,
    input rst,
    input [`i5] stall,
    input [`i4] flush,
    input [`i32] mem_wdata, // 来自MEM的回写数据
    input mem_rf_wena, // 来自MEM的寄存器堆写入使能信号
    input [`i5] mem_waddr, // 来自MEM的寄存器堆写入地址
    input mem_is_MULT,
    input mem_is_MULTU,
    input [`i32] mem_hi_out,
    input [`i32] mem_lo_out,
    output reg [`i32] wb_wdata, // 传递到WB的回写数据
    output reg wb_rf_wena, // 传递到WB的写入使能信号
    output reg [`i5] wb_waddr, // 传递到WB的寄存器堆写入地址
    output reg wb_is_MULT,
    output reg wb_is_MULTU,
    output reg [`i32] wb_hi_out,
    output reg [`i32] wb_lo_out
    );

always @ (posedge clk) begin
    if(rst | flush[0]) begin
        wb_wdata <= 0;
        wb_rf_wena <= 0;
        wb_waddr <= 0;
        wb_is_MULT <= 0;
        wb_is_MULTU <= 0;
        wb_hi_out <= 0;
        wb_lo_out <= 0;
    end
    else if(stall[0]) begin
        wb_wdata <= 0;
        wb_rf_wena <= 0;
        wb_waddr <= 0;
        wb_is_MULT <= 0;
        wb_is_MULTU <= 0;
        wb_hi_out <= 0;
        wb_lo_out <= 0;
    end
    else begin
        wb_wdata <= mem_wdata;
        wb_rf_wena <= mem_rf_wena;
        wb_waddr <= mem_waddr;
        wb_is_MULT <= mem_is_MULT;
        wb_is_MULTU <= mem_is_MULTU;
        wb_hi_out <= mem_hi_out;
        wb_lo_out <= mem_lo_out;
    end
end

endmodule
