`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2022 11:00:46 AM
// Design Name: 
// Module Name: FlushCtrl
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

module FlushCtrl(
    input rst,
    input flush_all,
    input flush_when_branch_prediction_fails,
    output reg[`i4] flush
    );

always @ (*) begin
    if(rst) flush <= 4'b0;
    else if(flush_all) flush <= 4'b1111;
    else if(flush_when_branch_prediction_fails) flush <= 4'b1100;
    else flush <= 4'b0;
end

endmodule
