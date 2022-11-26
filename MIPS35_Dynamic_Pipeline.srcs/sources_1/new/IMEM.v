`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2022 11:19:38 AM
// Design Name: 
// Module Name: IMEM
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

module IMEM(
    input [7:0] IM_Addr,
    input IM_rena,
    output [`i32] IM_Inst
    );

wire [`i32] inst;

dist_mem_gen_0 dmg_inst_0(
.a(IM_Addr),
.spo(inst)
);

assign IM_Inst = IM_rena ? inst : 32'b0; 

endmodule

