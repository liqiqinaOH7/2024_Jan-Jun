`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV-Pipline CPU
// Module Name: BranchDecisionMaking
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: Decide whether to branch 
//////////////////////////////////////////////////////////////////////////////////
`include "Parameters.v"   
module BranchDecisionMaking(
    input wire [2:0] BranchTypeE,
    input wire [31:0] Operand1,Operand2,
    output reg BranchE
    );
    always @(*) begin
      case(BranchTypeE)
         `BEQ: 
            BranchE<=((Operand1==Operand2)?1'b1:1'b0);  //BEQ
         `BNE: 
            BranchE<=((Operand1!=Operand2)?1'b1:1'b0);  //BNE
         `BLT: 
            BranchE<=((Operand1[31]!=Operand2[31])?Operand1[31]:(Operand1<Operand2));  //BLT
         `BLTU: 
            BranchE<=((Operand1<Operand2)?1'b1:1'b0);  //BLTU
         `BGE: 
            BranchE<=((Operand1[31]!=Operand2[31])?Operand2[31]:(Operand1>=Operand2));  //BGE
         `BGEU: 
            BranchE<=((Operand1>=Operand2)?1'b1:1'b0);  //BGEU
         `NOBRANCH:
            BranchE<=1'b0;  //NOBranchE
         default:                            BranchE<=1'b0;  //NOBRANCH
      endcase
    end
endmodule

//功能和接口说明
    //BranchDecisionMaking接受两个操作数，根据BranchTypeE的不同，进行不同的判断，当分支应该taken时，令BranchE=1'b1
    //BranchTypeE的类型定义在Parameters.v中
//推荐格式：
    //case()
    //    `BEQ: ???
    //      .......
    //    default:                            BranchE<=1'b0;  //NOBRANCH
    //endcase
//实验要求  
    //实现BranchDecisionMaking模块