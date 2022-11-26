`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2022 08:11:46 PM
// Design Name: 
// Module Name: CPU
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

module CPU(
    input clk,
    input rst,
    input [`i32] IM_Inst,
    output [`i32] pc,
    output IM_rena
    );

// 流水线暂停控制器实例化
wire id_reqStall;
wire ex_reqStall;
wire mem_reqStall;
wire jump_reqStall;
wire [`i5] stall;
StallCtrl stallCtrl_instance(
    .rst(rst),
    .jump_reqStall(jump_reqStall),
    .mem_reqStall(mem_reqStall),
    .id_reqStall(id_reqStall),
    .ex_reqStall(ex_reqStall),
    .stall(stall)
    );

// PC寄存器实例化
reg [`i32] npc;

PC pc_instance(
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .pc_wena(1'b1),
    .npc(npc),
    .pc(pc),
    .IM_rena(IM_rena)
    );

// IF_ID模块实例化
wire [`i32] id_pc;
wire [`i32] id_inst;

IF_ID if_id_instance(
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .if_pc(pc),
    .if_inst(IM_Inst),
    .id_pc(id_pc),
    .id_inst(id_inst)
    );

// ID模块实例化
wire [`i32] rf_rdata1;
wire [`i32] rf_rdata2;
wire rf_rena1;
wire rf_rena2;
wire [`i5] raddr1;
wire [`i5] raddr2;
wire [`i5] id_waddr;
wire id_rf_wena;
wire [`i4] id_aluc;
wire [`i32] id_alu_a;
wire [`i32] id_alu_b;

wire [`i32] ex_out_wdata;
wire ex_out_rf_wena;
wire [`i5] ex_out_waddr;

wire [`i32] mem_out_wdata;
wire [`i5] mem_out_waddr;
wire mem_out_rf_wena;

wire id_dm_wena;
wire id_dm_rena;
wire [`i32] id_dm_wdata;
wire [10:0] id_dm_addr;

wire is_BEQ;
wire is_BNE;
wire is_Jump;
wire [`i32] id_jump_addr;

//assign npc = pc + 4;
assign jump_reqStall = is_Jump;

ID id_instance(
    .rst(rst),
    .id_pc(id_pc),
    .id_inst(id_inst),
    .rf_rdata1(rf_rdata1),
    .rf_rdata2(rf_rdata2),
    .ex_out_wdata(ex_out_wdata),
    .ex_out_rf_wena(ex_out_rf_wena),
    .ex_out_waddr(ex_out_waddr),
    .mem_out_wdata(mem_out_wdata),
    .mem_out_rf_wena(mem_out_rf_wena),
    .mem_out_waddr(mem_out_waddr),
    .rf_rena1(rf_rena1),
    .rf_rena2(rf_rena2),
    .raddr1(raddr1),
    .raddr2(raddr2),
    .waddr(id_waddr),
    .rf_wena(id_rf_wena),
    .aluc(id_aluc),
    .alu_a(id_alu_a),
    .alu_b(id_alu_b),
    .dm_wena(id_dm_wena),
    .dm_rena(id_dm_rena),
    .dm_wdata(id_dm_wdata),
    .dm_addr(id_dm_addr),
    .is_BEQ(is_BEQ),
    .is_BNE(is_BNE),
    .is_Jump(is_Jump),
    .id_jump_addr(id_jump_addr)
    );

assign id_reqStall = is_BEQ || is_BNE;

// 寄存器堆模块实例化
wire [`i32] wb_wdata;
wire wb_rf_wena;
wire [`i5] wb_waddr;
Regfile rf_instance(
    .clk(clk),
    .rst(rst),
    .waddr(wb_waddr),
    .wdata(wb_wdata),
    .rf_wena(wb_rf_wena),
    .raddr1(raddr1),
    .raddr2(raddr2),
    .rf_rena1(rf_rena1),
    .rf_rena2(rf_rena2),
    .rdata1(rf_rdata1),
    .rdata2(rf_rdata2)
    );

// ID_EX模块实例化
wire [`i5] ex_waddr;
wire ex_rf_wena;
wire [`i4] ex_aluc;
wire [`i32] ex_alu_a;
wire [`i32] ex_alu_b;
wire ex_dm_wena;
wire ex_dm_rena;
wire [`i32] ex_dm_wdata;
wire [10:0] ex_dm_addr;

wire ex_is_BNE;
wire ex_is_BEQ;
wire [`i32] ex_jump_addr;

ID_EX id_ex_instance(
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .id_waddr(id_waddr),
    .id_rf_wena(id_rf_wena),
    .id_aluc(id_aluc),
    .id_alu_a(id_alu_a),
    .id_alu_b(id_alu_b),
    .id_dm_wena(id_dm_wena),
    .id_dm_rena(id_dm_rena),
    .id_dm_wdata(id_dm_wdata),
    .id_dm_addr(id_dm_addr),
    .id_is_BNE(is_BNE),
    .id_is_BEQ(is_BEQ),
    .id_jump_addr(id_jump_addr),
    .ex_waddr(ex_waddr),
    .ex_rf_wena(ex_rf_wena),
    .ex_aluc(ex_aluc),
    .ex_alu_a(ex_alu_a),
    .ex_alu_b(ex_alu_b),
    .ex_dm_wena(ex_dm_wena),
    .ex_dm_rena(ex_dm_rena),
    .ex_dm_wdata(ex_dm_wdata),
    .ex_dm_addr(ex_dm_addr),
    .ex_is_BNE(ex_is_BNE),
    .ex_is_BEQ(ex_is_BEQ),
    .ex_jump_addr(ex_jump_addr)
    );

// EX模块实例化
wire CF;
wire OF;
wire SF;
wire ZF;
EX ex_instance(
    .rst(rst),
    .aluc(ex_aluc),
    .alu_a(ex_alu_a),
    .alu_b(ex_alu_b),
    .i_rf_wena(ex_rf_wena),
    .i_waddr(ex_waddr),
    .wdata(ex_out_wdata),
    .rf_wena(ex_out_rf_wena),
    .waddr(ex_out_waddr),
    .CF(CF),
    .OF(OF),
    .SF(SF),
    .ZF(ZF)
    );

always @ (*) begin
    if(is_Jump) npc <= id_jump_addr;
    else if(ex_is_BEQ || ex_is_BNE) begin
        if((ex_is_BEQ && ZF) || (ex_is_BNE && !ZF)) npc <= ex_jump_addr;
        else npc <= pc;
    end
    else npc <= pc + 4;
end

// EX_MEM模块实例化
wire [`i32] mem_wdata;
wire [`i5] mem_waddr;
wire mem_rf_wena;
wire mem_dm_wena;
wire mem_dm_rena;
wire [`i32] mem_dm_wdata;
wire [10:0] mem_dm_addr;

EX_MEM ex_mem_instance(
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .ex_wdata(ex_out_wdata),
    .ex_rf_wena(ex_out_rf_wena),
    .ex_waddr(ex_out_waddr),
    .ex_dm_wena(ex_dm_wena),
    .ex_dm_rena(ex_dm_rena),
    .ex_dm_wdata(ex_dm_wdata),
    .ex_dm_addr(ex_dm_addr),
    .mem_wdata(mem_wdata),
    .mem_rf_wena(mem_rf_wena),
    .mem_waddr(mem_waddr),
    .mem_dm_wena(mem_dm_wena),
    .mem_dm_rena(mem_dm_rena),
    .mem_dm_wdata(mem_dm_wdata),
    .mem_dm_addr(mem_dm_addr)
    );

// MEM模块实例化
wire [`i32] DM_RData;
MEM mem_instance(
    .rst(rst),
    .i_wdata(mem_wdata),
    .i_rf_wena(mem_rf_wena),
    .i_waddr(mem_waddr),
    .LW(mem_dm_rena),
    .DM_RData(DM_RData),
    .wdata(mem_out_wdata),
    .rf_wena(mem_out_rf_wena),
    .waddr(mem_out_waddr)
    );

// DMEM模块实例化
DMEM dmem_instance(
    .clk(clk),
    .rst(rst),
    .DM_Addr(mem_dm_addr),
    .DM_WData(mem_dm_wdata),
    .DM_W(mem_dm_wena),
    .DM_R(mem_dm_rena),
    .DM_RData(DM_RData)
    );

// MEM_WB模块实例化
MEM_WB mem_wb_instance(
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .mem_wdata(mem_out_wdata),
    .mem_rf_wena(mem_out_rf_wena),
    .mem_waddr(mem_out_waddr),
    .wb_wdata(wb_wdata),
    .wb_rf_wena(wb_rf_wena),
    .wb_waddr(wb_waddr)
    );

assign ex_reqStall = (rf_rena1 && ex_dm_rena && (ex_out_waddr == raddr1)) || (rf_rena2 && ex_dm_rena && (ex_out_waddr == raddr2));
assign mem_reqStall = (rf_rena1 && mem_dm_rena && (mem_out_waddr == raddr1)) || (rf_rena2 && mem_dm_rena && (mem_out_waddr == raddr2));

endmodule
