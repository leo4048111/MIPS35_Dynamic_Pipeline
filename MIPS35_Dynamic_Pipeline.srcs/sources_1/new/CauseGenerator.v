`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2022 10:11:41 AM
// Design Name: 
// Module Name: CauseGenerator
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

module CauseGenerator(
    input cin1,
    input cin2,
    output [`i5] cause
);

reg [`i5] reg_cause;
always @ *
begin
  case({cin1,cin2})
    2'b00: reg_cause <= 32'b01000;
    2'b01: reg_cause <= 32'b01001;
    2'b10: reg_cause <= 32'b01101;
    2'b11: reg_cause <= 32'b00000;
    default:;
  endcase
end
assign cause = reg_cause;
endmodule
