`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2022 02:42:17 PM
// Design Name: 
// Module Name: RegHiLo
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

module RegHiLo(
    input clk,
    input rst,
    input [`i32] Hi_in,
    input [`i32] Lo_in,
    input [1:0] HL_W,
    input HL_R,
    output [`i32] HL_out
    );

reg [`i32] reg_hi;
reg [`i32] reg_lo;

always @ (posedge clk) begin
    if(rst) begin
        reg_hi <= 32'b0;
        reg_lo <= 32'b0;
    end
    else begin
        if(HL_W[0]) reg_lo <= Lo_in;
        if(HL_W[1]) reg_hi <= Hi_in;
    end
end

assign HL_out = (HL_R) ? reg_hi : reg_lo;

endmodule
