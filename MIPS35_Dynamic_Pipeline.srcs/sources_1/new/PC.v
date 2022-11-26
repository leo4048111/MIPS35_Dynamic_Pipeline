`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2022 11:08:39 AM
// Design Name: 
// Module Name: PC
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

module PC(
    input clk,
    input rst,
    input [`i5] stall,
    input pc_wena,
    input [`i32] npc,
    output reg [`i32] pc,
    output reg IM_rena
    );

always @ (posedge clk) begin
    if (rst) begin 
        pc <= 32'h00004000;
        IM_rena <= 1;
    end
    else if(stall[4]) begin
        pc <= pc;
        IM_rena <= 0;
    end
    else begin 
        IM_rena <= 1;
        if (pc_wena) pc <= npc;
    end 
end

endmodule
