`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2022 07:10:27 PM
// Design Name: 
// Module Name: top
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

module top(
    input clk,
    input rst,
    output [7:0] AN,
    output [6:0] led_out
    );

(* DONT_TOUCH = "TRUE" *) wire [`i32] IM_Inst;
(* DONT_TOUCH = "TRUE" *) wire [`i32] pc;
(* DONT_TOUCH = "TRUE" *) wire IM_rena;

reg [10:0] count = 0;
reg divided_clk = 0;
always @ (posedge clk)
begin
    count <= count + 1;
    if(count >= 100) begin
        divided_clk <= ~divided_clk;
        count <= 0;
    end 
end

(* DONT_TOUCH = "TRUE" *) wire [`i32] debug_data;

CPU cpu_instance(
    .clk(divided_clk),
    .rst(rst),
    .IM_Inst(IM_Inst),
    .pc(pc),
    .IM_rena(IM_rena),
    .debug_data(debug_data)
    );

(* DONT_TOUCH = "TRUE" *) wire [10:0] IM_Addr = (pc - 32'h00400000) >> 2;

// (* DONT_TOUCH = "TRUE" *) wire [10:0] IM_Addr = pc > 32'h004000e8 ? 32'h004000ec : (pc - 32'h00400000) >> 2;

IMEM imem_instance(
    .IM_Addr(IM_Addr),
    .IM_rena(IM_rena),
    .IM_Inst(IM_Inst)
    );

// DEBUG LED OUTPUT
LEDDriver lo4_led_driver_instance(
    .clk(clk),
    .rst(rst),
    .displayed_number(debug_data),
    .anode(AN),
    .led_out(led_out)
    );
endmodule
