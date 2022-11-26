`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2022 04:10:14 PM
// Design Name: 
// Module Name: IF_ID
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

module IF_ID(
    input clk,
    input rst,
    input [`i5] stall,
    input [`i32] if_pc, // 取指阶段pc
    input [`i32] if_inst, // 取值阶段指令
    output reg [`i32] id_pc, // 译码阶段pc
    output reg [`i32] id_inst // 译码阶段指令
    );

always @ (posedge clk) begin
    if(rst) begin
        id_pc <= 32'h0;
        id_inst <= 32'h0;
    end 
    else if(stall[3] && !stall[2]) begin
        id_pc <= 0;
        id_inst <= 0;
    end
    else if(stall[3]) begin
        id_pc <= id_pc;
        id_inst <= id_inst;
    end
    else begin
        id_pc <= if_pc;
        id_inst <= if_inst;
    end
end

endmodule
