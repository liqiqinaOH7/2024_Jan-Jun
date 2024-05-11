`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV-Pipline CPU
// Module Name: ControlUnit
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: RISC-V Instruction Decoder
//////////////////////////////////////////////////////////////////////////////////
`include "Parameters.v"   
`define ControlOut {{JalD,JalrD},{MemToRegD},{RegWriteD},{MemWriteD},{LoadNpcD},{RegReadD},{BranchTypeD},{AluContrlD},{AluSrc1D,AluSrc2D},{ImmType}}
module ControlUnit(
    input wire [6:0] Op,
    input wire [2:0] Fn3,
    input wire [6:0] Fn7,
    output reg JalD,
    output reg JalrD,
    output reg [2:0] RegWriteD,
    output reg MemToRegD,
    output reg [3:0] MemWriteD,
    output reg LoadNpcD,
    output reg [1:0] RegReadD,
    output reg [2:0] BranchTypeD,
    output reg [3:0] AluContrlD,
    output reg [1:0] AluSrc2D,
    output reg AluSrc1D,
    output reg [2:0] ImmType
    );
        always @(*) begin
        case (Op)
             7'b0110011: //R-type instruction
            begin
                JalD <= 1'b0;
                JalrD <= 1'b0;
                RegWriteD <= `LW; // Assuming most R-Type instructions write to registers
                MemToRegD <= 1'b0;
                MemWriteD <= 4'b0000;
                LoadNpcD <= 1'b0;
                RegReadD <= 2'b11;
                BranchTypeD <= 3'b000;
                case(Fn3)
                    3'b000: //ADD
                        AluContrlD <= Fn7[5]?`SUB:`ADD;
                    3'b001: //SLL
                        AluContrlD <= `SLL;
                    3'b010: //SLT
                        AluContrlD <= `SLT;
                    3'b011: //SLTU
                        AluContrlD <= `SLTU;
                    3'b100: //XOR
                        AluContrlD <= `XOR;
                    3'b101: //SRL|SRA
                        AluContrlD <= Fn7[5]?`SRA:`SRL;
                    3'b110: //OR
                        AluContrlD <= `OR;
                    3'b111: //AND
                        AluContrlD <= `AND;
                endcase
                AluSrc2D <= 2'b00;
                AluSrc1D <= 1'b0;
                ImmType <= `RTYPE;
            end 
             7'b0010011: //I-type instruction
            begin
                JalD <= 1'b0;
                JalrD <= 1'b0;
                RegWriteD <= `LW; // Assuming most I-Type instructions write to registers
                MemToRegD <= 1'b0; 
                MemWriteD <= 4'b0000; // Assuming no memory write for I-Type instructions
                LoadNpcD <= 1'b0; // Next PC is loaded
                RegReadD <= 2'b10; // A1 is used for I-Type instructions
                BranchTypeD <= `NOBRANCH; // Assuming no branching for I-Type instructions
                case(Fn3)
                    3'b000: // ADDI
                        AluContrlD <= `ADD;
                    3'b010: // SLTI
                        AluContrlD <= `SLT;
                    3'b011: // SLTIU
                        AluContrlD <= `SLTU;
                    3'b100: // XORI
                        AluContrlD <= `XOR;
                    3'b110: // ORI
                        AluContrlD <= `OR;
                    3'b111: // ANDI
                        AluContrlD <= `AND;

                    3'b001: // SLLI
                        AluContrlD <= `SLL;
                    3'b101: // SRLI/SRAI
                        AluContrlD <= Fn7[5]?`SRA:`SRL;
                endcase
                AluSrc2D <= 2'b10;  // The second operand of the ALU is Imm for I-Type instructions
                AluSrc1D <= 1'b0;
                //ImmType <= (Fn3==3'b001||Fn3==3'b101)? `shamtType : `ITYPE; // The immediate type is I-Type
                ImmType <= `ITYPE;
            end 
            7'b0000011: //I-type instruction // load instructions
            begin
                JalD <= 1'b0;
                JalrD <= 1'b0;
                case(Fn3)
                    3'b000: // LB
                        RegWriteD <= `LB;
                    3'b001: // LH
                        RegWriteD <= `LH;
                    3'b010: // LW
                        RegWriteD <= `LW;
                    3'b100: // LBU
                        RegWriteD <= `LBU;
                    3'b101: // LHU
                        RegWriteD <= `LHU;
                endcase
                MemToRegD <= 1'b1; // Load from memory
                MemWriteD <= 4'b0000; // No memory write for Load instructions
                LoadNpcD <= 1'b0; // Next PC is loaded
                RegReadD <= 2'b10; // Read from A1
                BranchTypeD <= `NOBRANCH; // No branching for Load instructions
                AluContrlD <= `ADD;
                AluSrc2D <= 2'b10;  // The second operand of the ALU is Imm for Load instructions
                AluSrc1D <= 1'b0;
                ImmType <= `ITYPE; // The immediate type is I-Type
            end
            7'b1100111: //I-type instruction // JALR instruction
            begin
                JalD <= 1'b0; // Not a JAL instruction
                JalrD <= 1'b1; // Indicate JALR instruction
                MemToRegD <= 1'b0; // Not using memory read for JALR instruction
                MemWriteD <= 4'b0000; // Not writing to memory for JALR instruction
                LoadNpcD <= 1'b1; //load the usual PC+4
                RegReadD <= 2'b10; // Read from A1 (rs1) register for JALR instruction
                BranchTypeD <= `NOBRANCH; // JALR is a type of jump, not a branch
                AluContrlD <= `ADD; // Using addition in ALU for calculating jump offset
                AluSrc1D <= 1'b0; // First operand of ALU is the rs1 register value
                AluSrc2D <= 2'b10; // The second operand of the ALU is the immediate operand
                ImmType <= `ITYPE; // The immediate type is I-Type
                RegWriteD <= 3'b111; // Write result(PC+4) to rd register 
            end

             7'b0100011: //S-type instruction
            begin
                JalD <= 1'b0;
                JalrD <= 1'b0;
                RegWriteD <= 3'b000; // No register write for Store instructions
                MemToRegD <= 1'b0; // No memory to register load for Store instructions
                LoadNpcD <= 1'b0; // Next PC is loaded
                RegReadD <= 2'b11; // Read from A1 and A2
                BranchTypeD <= `NOBRANCH; // No branching for Store instructions
                AluContrlD <= `ADD; // Calculate memory address
                AluSrc2D <= 2'b10;  // The second operand of the ALU is Imm for Store instructions
                AluSrc1D <= 1'b0;
                ImmType <= `STYPE; // The immediate type is S-Type
                case(Fn3)
                    3'b000: // SB
                        MemWriteD <= 4'b0001;
                    3'b001: // SH
                        MemWriteD <= 4'b0011;
                    3'b010: // SW
                        MemWriteD <= 4'b1111;
                endcase
            end

            7'b1100011: //B-type instruction
            begin
                JalD <= 1'b0;
                JalrD <= 1'b0;
                RegWriteD <= 3'b000; // No register write for Branch instructions
                MemToRegD <= 1'b0; // No memory to register load for Branch instructions
                MemWriteD <= 4'b0000; // No memory write for Branch instructions
                LoadNpcD <= 1'b0; // Next PC is not usual PC+4 for Branch instructions
                RegReadD <= 2'b11; // Read from A1 and A2
                AluSrc2D <= 2'b00;  // The second operand of the ALU is from register for Branch instructions
                AluSrc1D <= 1'b0;
                ImmType <= `BTYPE; // The immediate type is B-Type
                case(Fn3)
                    3'b000: // BEQ
                        BranchTypeD <= `BEQ;
                    3'b001: // BNE
                        BranchTypeD <= `BNE;
                    3'b100: // BLT
                        BranchTypeD <= `BLT;
                    3'b101: // BGE
                        BranchTypeD <= `BGE;
                    3'b110: // BLTU
                        BranchTypeD <= `BLTU;
                    3'b111: // BGEU
                        BranchTypeD <= `BGEU;
                endcase
                AluContrlD <= `SUB;
            end
             7'b0110111: //U-type instruction LUI
            begin
                JalD <= 1'b0;
                JalrD <= 1'b0;
                MemToRegD <= 1'b0; // No memory to register load for LUI instructions
                MemWriteD <= 4'b0000; // No memory write for LUI instructions
                LoadNpcD <= 1'b0; // Next PC is usual PC+4
                RegReadD <= 2'b00; // No read from A1 and A2 for LUI instruction
                BranchTypeD <= `NOBRANCH; // No branching for LUI instructions
                AluContrlD <= `LUI; // Add immediate to 0 for LUI instruction
                AluSrc2D <= 2'b10;  // The second operand of the ALU is Imm for LUI instructions
                AluSrc1D <= 1'b1; // The first operand of the ALU is zero for LUI instruction
                ImmType <= `UTYPE; // The immediate type is U-Type
                RegWriteD <= 3'b111; // Write to rd for LUI instructions
            end
             7'b0010111: //U-type instruction AUIPC
            begin
                JalD <= 1'b0;
                JalrD <= 1'b0;
                MemToRegD <= 1'b0; // No memory to register load for AUIPC instructions
                MemWriteD <= 4'b0000; // No memory write for AUIPC instructions
                LoadNpcD <= 1'b0; //
                RegReadD <= 2'b00; // No read from A1 and A2 for AUIPC instruction
                BranchTypeD <= `NOBRANCH; // No branching for AUIPC instructions
                AluContrlD <= `ADD; // Add immediate with PC for AUIPC instruction
                AluSrc2D <= 2'b10; // The second operand of the ALU is Imm for AUIPC instructions
                AluSrc1D <= 1'b1; // The first operand of the ALU is PC for AUIPC instruction
                ImmType <= `UTYPE; // The immediate type is U-Type
                RegWriteD <= 3'b111; // Write result to rd for AUIPC instructions
            end
            7'b1101111: //J-type instruction JAL
            begin
                JalD <= 1'b1; // Indicate JAL instruction
                JalrD <= 1'b0; // Not a JALR instruction
                MemToRegD <= 1'b0; // Not using memory read for JAL instruction
                MemWriteD <= 4'b0000; // Not writing to memory for JAL instruction
                LoadNpcD <= 1'b1; // load the usual PC+4
                RegReadD <= 2'b00; // Not using any source registers for JAL instruction
                BranchTypeD <= `NOBRANCH; // JAL is a type of jump, not a branch
                AluContrlD <= `ADD; // Using addition in ALU for calculating jump offset
                AluSrc1D <= 1'b1; // First operand of ALU is the PC
                AluSrc2D <= 2'b10; // The second operand of the ALU is the immediate operand
                ImmType <= `JTYPE; // The immediate type is J-Type
                RegWriteD <= 4'b1111; // Write result(PC+4) to rd register 
            end

            default: // Default case
            begin
                JalD <= 1'b0;
                JalrD <= 1'b0; 
                MemToRegD <= 1'b0; // Not using memory read 
                MemWriteD <= 4'b0000; // Not writing to memory 
                LoadNpcD <= 1'b0; // load the usual PC+4
                RegReadD <= 2'b00; // Not using any source registers for JAL instruction
                BranchTypeD <= `NOBRANCH;
                AluContrlD <= `ADD; // Using addition in ALU for calculating jump offset
                AluSrc1D <= 1'b1; // First operand of ALU is the PC
                AluSrc2D <= 2'b10; // The second operand of the ALU is the immediate operand
                ImmType <= `RTYPE; 
                RegWriteD <= 4'b0000; 
            end
        endcase
    end 
endmodule

//功能说明
    //ControlUnit       是本CPU的指令译码器，组合逻辑电路
//输入
    // Op               是指令的操作码部分
    // Fn3              是指令的func3部分
    // Fn7              是指令的func7部分
//输出
    // JalD==1          表示Jal指令到达ID译码阶段
    // JalrD==1         表示Jalr指令到达ID译码阶段
    // RegWriteD        表示ID阶段的指令对应的 寄存器写入模式 ，所有模式定义在Parameters.v中
    // MemToRegD==1     表示ID阶段的指令需要将data memory读取的值写入寄存器,
    // MemWriteD        共4bit，采用独热码格式，对于data memory的32bit字按byte进行写入,MemWriteD=0001表示只写入最低1个byte，和xilinx bram的接口类似
    // LoadNpcD==1      表示将NextPC输出到ResultM
    // RegReadD[1]==1   表示A1对应的寄存器值被使用到了，RegReadD[0]==1表示A2对应的寄存器值被使用到了，用于forward的处理
    // BranchTypeD      表示不同的分支类型，所有类型定义在Parameters.v中
    // AluContrlD       表示不同的ALU计算功能，所有类型定义在Parameters.v中
    // AluSrc2D         表示Alu输入源2的选择
    // AluSrc1D         表示Alu输入源1的选择
    // ImmType          表示指令的立即数格式，所有类型定义在Parameters.v中   
//实验要求  
    //实现ControlUnit模块   