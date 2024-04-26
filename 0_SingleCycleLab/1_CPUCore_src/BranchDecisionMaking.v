`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV CPU
// Module Name: BranchDecisionMaking
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: Decide whether to branch 
//////////////////////////////////////////////////////////////////////////////////
`include "Parameters.v"   
module BranchDecisionMaking(
    input wire [2:0] BranchType,
    input wire [31:0] Operand1,Operand2,
    output reg Branch
    );
    always @(*) begin
      case(BranchType)
         `BEQ: 
            Branch<=((Operand1==Operand2)?1'b1:1'b0);  //BEQ
         `BNE: 
            Branch<=((Operand1!=Operand2)?1'b1:1'b0);  //BNE
         `BLT: 
            Branch<=((Operand1[31]!=Operand2[31])?Operand1[31]:(Operand1<Operand2));  //BLT
         `BLTU: 
            Branch<=((Operand1<Operand2)?1'b1:1'b0);  //BLTU
         `BGE: 
            Branch<=((Operand1[31]!=Operand2[31])?Operand2[31]:(Operand1>=Operand2));  //BGE
         `BGEU: 
            Branch<=((Operand1>=Operand2)?1'b1:1'b0);  //BGEU
         `NOBRANCH:
            Branch<=1'b0;  //NOBRANCH
         default:                            Branch<=1'b0;  //NOBRANCH
      endcase
    end
endmodule

//功能和接口说明
    //BranchDecisionMaking接受两个操作数，根据BranchType的不同，进行不同的判断，当分支应该taken时，令Branch=1'b1
    //BranchTypeE的类型定义在Parameters.v中
//推荐格式：
    //case()
    //    `BEQ: ???
    //      .......
    //    default:                            Branch<=1'b0;  //NOBRANCH
    //endcase
//实验要求  
    //实现BranchDecisionMaking模块
    // //BranchType[2:0]
    // `define NOBRANCH  3'd0
    // `define BEQ  3'd1
    // `define BNE  3'd2
    // `define BLT  3'd3
    // `define BLTU  3'd4
    // `define BGE  3'd5
    // `define BGEU  3'd6