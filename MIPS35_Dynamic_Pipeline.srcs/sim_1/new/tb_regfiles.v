`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2022 05:49:29 PM
// Design Name: 
// Module Name: tb_regfiles
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


module tb_regfiles;

reg clk = 0;
reg rst = 0;

reg [31:0] wdata;
reg [4:0] waddr;
reg rf_wena;
reg [4:0] raddr1;
reg [4:0] raddr2;
reg rf_rena1 = 0;
reg rf_rena2 = 0;

initial begin
#5;
wdata = 123;
waddr = 1;
rf_wena = 1;
#20;
wdata =246;
waddr = 1;
rf_wena = 1;
raddr1 = 1;
rf_rena1 = 1;
end

wire [31:0] rdata1;
wire [31:0] rdata2;

Regfile uut(
    clk, rst, waddr, wdata, rf_wena, raddr1, raddr2, rf_rena1, rf_rena2, rdata1, rdata2
);



always #10 clk = ~clk;

endmodule
