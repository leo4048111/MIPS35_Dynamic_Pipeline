`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2022 07:20:16 PM
// Design Name: 
// Module Name: tb_top
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


module tb_top;

reg clk = 0;
reg rst = 1;

initial begin
    #11 rst = 0;
end

always #10 clk = ~clk;

top uut(
    .clk(clk),
    .rst(rst)
    );

endmodule
