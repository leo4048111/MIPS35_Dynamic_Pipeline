`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2022 01:28:08 PM
// Design Name: 
// Module Name: EX
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

module EX(
    input rst,
    input [`i4] aluc, 
    input [`i32] alu_a,
    input [`i32] alu_b,
    input i_rf_wena, // 写入使能信号输入
    input [`i5] i_waddr, // 写入地址输入
    output [`i32] wdata, // 运算结果
    output rf_wena, // 写入使能信号输出
    output [`i5] waddr, // 写入地址输出
    output reg CF,
    output reg OF,
    output reg SF,
    output reg ZF
    );

assign rf_wena = i_rf_wena;
assign waddr = i_waddr;

reg [`i32] ALU_Result;

always@(*)  //采用组合逻辑设计ALU
begin
casex (aluc)
    4'b0000:  //ADDU ADDIU
        {CF,ALU_Result} = {1'b0,alu_a} + {1'b0,alu_b};   //单符号位加法    
    4'b0010: //ADD ADDI
        //使用双符号位运算，符号位不同即溢出
        begin
        {OF, ALU_Result} = {alu_a[31], alu_a} + {alu_b[31], alu_b};
        OF = OF ^ ALU_Result[31];
        end
    4'b0001: //SUBU
        begin
        {CF, ALU_Result} = {1'b0, alu_a} - {1'b0, alu_b};
        end
    4'b0011://SUB BEQ BEN
        begin
        {OF, ALU_Result} = {alu_a[31], alu_a} - {alu_b[31], alu_b};
        OF = OF ^ ALU_Result[31];
        end
    4'b0100://AND ANDI
        ALU_Result = alu_a & alu_b;
    4'b0101://OR ORI
        ALU_Result = alu_a | alu_b;
    4'b0110://XOR XORI
        ALU_Result = alu_a ^ alu_b;  
    4'b0111://NOR
        ALU_Result = ~(alu_a | alu_b);
    4'b100x://LUI置高位立即数
        ALU_Result = {alu_b[15:0], 16'b0};
    4'b1011://SLT SLTI 
        begin
        ALU_Result = alu_a - alu_b;//-  + = +；+  - = -

        if(alu_a[31] ^ alu_b[31])begin //正数一定大于负数，负数一定小于正数
            SF = alu_a[31];
        end else begin
            SF = ALU_Result[31]; 
        end 
        ALU_Result = SF;
        end
    4'b1010://SLTU SLTIU
        begin
        {CF, ALU_Result}={1'b0,alu_a} - {1'b0,alu_b};
    
        ALU_Result = CF;
        end
    4'b1100://SRA SRAV
        {ALU_Result, CF} = alu_b[31] ? ~(~{alu_b,1'b0} >> alu_a): {alu_b,1'b0}>>alu_a;
    4'b111x://SLL SLLV
        {CF, ALU_Result} = {1'b0, alu_b} << alu_a;
    4'b1101://SRL SRLV
        {ALU_Result, CF} = {alu_b ,1'b0} >> alu_a;
    default:
        ;
endcase

    if(ALU_Result == 32'b0)
        ZF = 1;
    else 
        ZF = 0;
            
    if(aluc != 4'b101x)
        SF = ALU_Result[31];
    else;
end

assign wdata = rst ? 0 : ALU_Result;

endmodule
