`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2022 06:14:28 PM
// Design Name: 
// Module Name: ID
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
`include "opcodes.v"

module ID(
    input rst,
    input [`i32] id_pc,
    input [`i32] id_inst,
    input [`i32] rf_rdata1, // 从Regfile读出的rdata1
    input [`i32] rf_rdata2, // 从Regfile读出的rdata2
    // 为实现EX和MEM阶段数据前推添加的引脚
    // 来自EX阶段的结果
    input [`i32] ex_out_wdata,
    input ex_out_rf_wena,
    input [`i5] ex_out_waddr,
    // 来自MEM阶段的结果
    input [`i32] mem_out_wdata,
    input mem_out_rf_wena,
    input [`i5] mem_out_waddr,
    // 输出引脚
    output rf_rena1, // 读使能信号1
    output rf_rena2, // 读使能信号2
    output [`i5] raddr1, // 寄存器堆读地址1
    output [`i5] raddr2, // 寄存器堆读地址2
    output [`i5] waddr, // 寄存器堆写地址
    output rf_wena, // 寄存器堆写使能信号
    output [`i4] aluc, // alu操作码
    output [`i32] alu_a, // alu操作数1
    output [`i32] alu_b, // alu操作数2
    output dm_wena,
    output dm_rena,
    output [`i32] dm_wdata,
    output [10:0] dm_addr,
    output is_BEQ,
    output is_BNE,
    output is_Jump,
    output reg[`i32] id_jump_addr
    );

wire [`i6] op, funct;
assign op = id_inst[`op];
assign funct = id_inst[`funct];

// R型指令译码
wire ADD, ADDU, SUB, SUBU, AND, OR, XOR, NOR, SLT, SLTU, SLL, SRL, SRA, SLLV, SRLV, SRAV, JR;
assign ADD = (op == `R_type && funct == `ADD);
assign ADDU = (op == `R_type && funct == `ADDU);
assign SUB = (op == `R_type && funct == `SUB);
assign SUBU = (op == `R_type && funct == `SUBU);
assign AND = (op == `R_type && funct == `AND);
assign OR = (op == `R_type && funct == `OR);
assign XOR = (op == `R_type && funct == `XOR);
assign NOR = (op == `R_type && funct == `NOR);
assign SLT = (op == `R_type && funct == `SLT);
assign SLTU = (op == `R_type && funct == `SLTU);
assign SLL = (op == `R_type && funct == `SLL);
assign SRL = (op == `R_type && funct == `SRL);
assign SRA = (op == `R_type && funct == `SRA);
assign SLLV = (op == `R_type && funct == `SLLV);
assign SRLV = (op == `R_type && funct == `SRLV);
assign SRAV = (op == `R_type && funct == `SRAV);
assign JR = (op == `R_type && funct == `JR);

// I型指令译码
wire ADDI, ADDIU, ANDI, ORI, XORI, LW, SW, BEQ, BNE, SLTI, SLTIU, LUI;
assign ADDI = (op == `ADDI);
assign ADDIU = (op == `ADDIU);
assign ANDI = (op == `ANDI);
assign ORI = (op == `ORI);
assign XORI = (op == `XORI);
assign LW = (op == `LW);
assign SW = (op == `SW);
assign BEQ = (op == `BEQ);
assign BNE = (op == `BNE);
assign SLTI = (op == `SLTI);
assign SLTIU = (op == `SLTIU);
assign LUI = (op == `LUI);

// J型指令译码
wire J,JAL;
assign J = (op == `J);
assign JAL = (op == `JAL);

// 跳转类型
assign is_BNE = rst ? 0 : BNE;
assign is_BEQ = rst ? 0 : BEQ;
assign is_Jump = rst ? 0 : (J | JAL | JR);

// 寄存器堆控制信号
assign rf_rena1 = rst ? 0 : (~(J|JAL|LUI|SLL|SRL|SRA));
assign rf_rena2 = rst ? 0 : (~(J|JAL|LUI|ADDI|ADDIU|ANDI|ORI|XORI|LW|SLTI|SLTIU|LUI));
assign raddr1 = rst ? 0 : id_inst[`rs];
assign raddr2 = rst ? 0 : id_inst[`rt];
assign waddr = rst ? 0 : (JAL ? 31 : (op ? id_inst[`rt] : id_inst[`rd]));
assign rf_wena = rst ? 0 : (~(JR|SW|BEQ|BNE|J));

// ALU控制信号与运算数
wire [`i5] shamt;
assign shamt = id_inst[`shamt];

wire should_sign_ext;
assign should_sign_ext = ADDI | ADDIU | SLTI | SLTIU;

assign aluc[0] = SUBU | SUB | BEQ | BNE | OR | ORI | NOR  | SLT | SLTI | SRL | SRLV;
assign aluc[1] = ADD | ADDI | SUB | BEQ | BNE | XOR | XORI | NOR | SLT | SLTI | SLTU | SLTIU | SLL | SLLV;
assign aluc[2] = AND | ANDI | OR | ORI | XOR | XORI | NOR | SRA | SRAV | SLL | SLLV | SRL | SRLV;
assign aluc[3] = LUI | SLT | SLTI | SLTU | SLTIU | SRA | SRAV | SLL | SLLV | SRL | SRLV;

reg [`i32] reg_alu_a;
reg [`i32] reg_alu_b;
reg [`i32] reg_read_data1;
reg [`i32] reg_read_data2;

// 设置第一个读出数据
always @ (*) begin
    if(rst) begin
        reg_read_data1 <= 0;
    end
    else if(rf_rena1) begin
        if((raddr1 == ex_out_waddr) && ex_out_rf_wena) // ex阶段的结果前推
            reg_read_data1 <= ex_out_wdata;
        else if((raddr1 == mem_out_waddr) && mem_out_rf_wena) // mem阶段的结果前推
            reg_read_data1 <= mem_out_wdata;
        else reg_read_data1 <= rf_rdata1;
    end
end

// 设置第二个读出数据
always @ (*) begin
    if(rst) begin
        reg_read_data2 <= 0;
    end
    else if(rf_rena2) begin
        if((raddr2 == ex_out_waddr) && ex_out_rf_wena) // ex阶段的结果前推
            reg_read_data2 <= ex_out_wdata;
        else if((raddr2 == mem_out_waddr) && mem_out_rf_wena) // mem阶段的结果前推
            reg_read_data2 <= mem_out_wdata;
        else reg_read_data2 <= rf_rdata2;
    end
end

wire [`i32] npc = id_pc + 4;

// 设置跳转地址
always @ (*)
begin
    if(rst) begin
        id_jump_addr <= 0;
    end
    else if(JR) id_jump_addr <= reg_read_data1;
    else if(J | JAL) id_jump_addr <= {npc[31:28], id_inst[25:0], 2'b0}; 
    else if(BEQ || BNE) id_jump_addr <= npc + {{14{id_inst[15]}}, id_inst[15:0], 2'b0};
    else id_jump_addr <= npc;
end

// 数据存储器控制信号
assign dm_wena = SW;
assign dm_rena = LW;
assign dm_wdata = reg_read_data2;
assign dm_addr = (reg_read_data1 + {{16{id_inst[15]}}, id_inst[15:0]} - 32'h10010000)/4;

// 设置第一个ALU操作数
always @ (*) begin
    if(rst) begin
        reg_alu_a <= 0;
    end
    else if(SLL|SRL|SRA) //这三条指令不读Rs
        reg_alu_a <= {23'b0, shamt};
    else if(rf_rena1) begin
        reg_alu_a <= reg_read_data1;
    end
end

// 设置第二个ALU操作数
always @ (*) begin
    if(rst) begin
        reg_alu_b <= 0;
    end
    else if(op && !BEQ && !BNE) begin
        if(should_sign_ext) reg_alu_b <= {{16{id_inst[15]}}, id_inst[15:0]};
        else reg_alu_b <= {16'b0, id_inst[15:0]};
    end
    else if(rf_rena2) begin
        reg_alu_b <= reg_read_data2;
    end
end

assign alu_a = reg_alu_a;
assign alu_b = reg_alu_b;

endmodule
