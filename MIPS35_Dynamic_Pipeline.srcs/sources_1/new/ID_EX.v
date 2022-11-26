`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2022 10:40:58 AM
// Design Name: 
// Module Name: ID_EX
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

module ID_EX(
    input clk,
    input rst,
    input [`i5] stall,

    // 来自ID的信息
    input [`i5] id_waddr, // 寄存器堆写地址
    input id_rf_wena, // 寄存器堆写使能信号
    input [`i4] id_aluc, // alu操作码
    input [`i32] id_alu_a, // alu操作数1
    input [`i32] id_alu_b, // alu操作数2
    input id_dm_wena,
    input id_dm_rena,
    input [`i32] id_dm_wdata,
    input [10:0] id_dm_addr,
    input id_is_BNE,
    input id_is_BEQ,
    input [`i32] id_jump_addr,

    // 传递到EX的信息
    output reg [`i5] ex_waddr, // 寄存器堆写地址
    output reg ex_rf_wena, // 寄存器堆写使能信号
    output reg [`i4] ex_aluc, // alu操作码
    output reg [`i32] ex_alu_a, // alu操作数1
    output reg [`i32] ex_alu_b, // alu操作数2
    output reg ex_dm_wena,
    output reg ex_dm_rena,
    output reg [`i32] ex_dm_wdata,
    output reg [10:0] ex_dm_addr,
    output reg ex_is_BNE,
    output reg ex_is_BEQ,
    output reg [`i32] ex_jump_addr
    );

always @ (posedge clk) begin
    if(rst) begin
        ex_waddr <= 0;
        ex_rf_wena <= 0;
        ex_aluc <= 0;
        ex_alu_a <= 0;
        ex_alu_b <= 0;
        ex_dm_wena <= 0;
        ex_dm_rena <= 0;
        ex_dm_wdata <= 0;
        ex_dm_addr <= 0;
        ex_is_BNE <= 0;
        ex_is_BEQ <= 0;
        ex_jump_addr <= 0;
    end
    else if(stall[2] && !stall[1]) begin
        ex_waddr <= 0;
        ex_rf_wena <= 0;
        ex_aluc <= 0;
        ex_alu_a <= 0;
        ex_alu_b <= 0;
        ex_dm_wena <= 0;
        ex_dm_rena <= 0;
        ex_dm_wdata <= 0;
        ex_dm_addr <= 0;
        ex_is_BNE <= 0;
        ex_is_BEQ <= 0;
        ex_jump_addr <= 0;
    end
    else if(stall[2]) begin
        ex_waddr <= ex_waddr;
        ex_rf_wena <= ex_rf_wena;
        ex_aluc <= ex_aluc;
        ex_alu_a <= ex_alu_a;
        ex_alu_b <= ex_alu_b;
        ex_dm_wena <= ex_dm_wena;
        ex_dm_rena <= ex_dm_rena;
        ex_dm_wdata <= ex_dm_wdata;
        ex_dm_addr <= ex_dm_addr;
        ex_is_BNE <= ex_is_BNE;
        ex_is_BEQ <= ex_is_BEQ;
        ex_jump_addr <= ex_jump_addr;
    end
    else begin
        ex_waddr <= id_waddr;
        ex_rf_wena <= id_rf_wena;
        ex_aluc <= id_aluc;
        ex_alu_a <= id_alu_a;
        ex_alu_b <= id_alu_b;
        ex_dm_wena <= id_dm_wena;
        ex_dm_rena <= id_dm_rena;
        ex_dm_wdata <= id_dm_wdata;
        ex_dm_addr <= id_dm_addr;
        ex_is_BNE <= id_is_BNE;
        ex_is_BEQ <= id_is_BEQ;
        ex_jump_addr <= id_jump_addr;
    end
end

endmodule
