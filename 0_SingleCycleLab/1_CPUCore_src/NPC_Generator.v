`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV CPU
// Module Name: NPC_Generator
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: Choose Next PC value
//////////////////////////////////////////////////////////////////////////////////

module NPC_Generator(
    input wire [31:0] JalrTarget, BranchTarget, JalTarget,     
    input wire Branch, Jal, Jalr,
    input clk, rst,
    output reg [31:0] PC
    );

    always @(posedge clk or posedge rst) begin
        if (rst) 
            PC <= 32'h0;    // Reset PC
        else begin
            if (Branch) 
                PC <= BranchTarget;
            else if (Jal) 
                PC <= JalTarget;
            else if (Jalr) 
                PC <= JalrTarget;
            else 
                PC <= PC+4;
        end
    end
endmodule
//功能说明
    //NPC_Generator是用来生成Next PC值得模块，根据不同的跳转信号选择不同的新PC值
//输入
    //PCF               旧的PC值
    //JalrTarget        jalr指令的对应的跳转目标
    //BranchTarget      branch指令的对应的跳转目标
    //JalTarget         jal指令的对应的跳转目标
    //Branch==1         Branch指令确定跳转
    //Jal==1            Jal指令确定跳转
    //Jalr==1           Jalr指令确定跳转
//输出
    //PC                NPC的值
//实验要求  
    //实现NPC_Generator模块  
