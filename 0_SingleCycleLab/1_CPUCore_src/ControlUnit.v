`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV CPU
// Module Name: ControlUnit
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: RISC-V Instruction Decoder
//////////////////////////////////////////////////////////////////////////////////
`include "Parameters.v"   
`define ControlOut {{Jal,Jalr},{MemToReg},{RegWrite},{MemWrite},{LoadNpc},{RegRead},{BranchType},{AluContrl},{AluSrc1,AluSrc2},{ImmType}}
module ControlUnit(
    input wire [6:0] Op,
    input wire [2:0] Fn3,
    input wire [6:0] Fn7,
    output reg Jal,
    output reg Jalr,
    output reg [2:0] RegWrite,
    output reg MemToReg,
    output reg [3:0] MemWrite,
    output reg LoadNpc,
    output reg [1:0] RegRead,// seems not used
    output reg [2:0] BranchType,
    output reg [3:0] AluContrl,
    output reg [1:0] AluSrc2,
    output reg AluSrc1,
    output reg [2:0] ImmType
    );
    always @(*) begin
        case (Op)
             7'b0110011: //R-type instruction
            begin
                Jal <= 1'b0;
                Jalr <= 1'b0;
                RegWrite <= `LW; // Assuming most R-Type instructions write to registers
                MemToReg <= 1'b0;
                MemWrite <= 4'b0000;
                LoadNpc <= 1'b0;
                RegRead <= 2'b11;
                BranchType <= 3'b000;
                case(Fn3)
                    3'b000: //ADD
                        AluContrl <= Fn7[5]?`SUB:`ADD;
                    3'b001: //SLL
                        AluContrl <= `SLL;
                    3'b010: //SLT
                        AluContrl <= `SLT;
                    3'b011: //SLTU
                        AluContrl <= `SLTU;
                    3'b100: //XOR
                        AluContrl <= `XOR;
                    3'b101: //SRL|SRA
                        AluContrl <= Fn7[5]?`SRA:`SRL;
                    3'b110: //OR
                        AluContrl <= `OR;
                    3'b111: //AND
                        AluContrl <= `AND;
                endcase
                AluSrc2 <= 2'b00;
                AluSrc1 <= 1'b0;
                ImmType <= `RTYPE;
            end 
             7'b0010011: //I-type instruction
            begin
                Jal <= 1'b0;
                Jalr <= 1'b0;
                RegWrite <= `LW; // Assuming most I-Type instructions write to registers
                MemToReg <= 1'b0; 
                MemWrite <= 4'b0000; // Assuming no memory write for I-Type instructions
                LoadNpc <= 1'b0; // Next PC is loaded
                RegRead <= 2'b10; // A1 is used for I-Type instructions
                BranchType <= `NOBRANCH; // Assuming no branching for I-Type instructions
                case(Fn3)
                    3'b000: // ADDI
                        AluContrl <= `ADD;
                    3'b010: // SLTI
                        AluContrl <= `SLT;
                    3'b011: // SLTIU
                        AluContrl <= `SLTU;
                    3'b100: // XORI
                        AluContrl <= `XOR;
                    3'b110: // ORI
                        AluContrl <= `OR;
                    3'b111: // ANDI
                        AluContrl <= `AND;

                    3'b001: // SLLI
                        AluContrl <= `SLL;
                    3'b101: // SRLI/SRAI
                        AluContrl <= Fn7[5]?`SRA:`SRL;
                endcase
                AluSrc2 <= 2'b10;  // The second operand of the ALU is Imm for I-Type instructions
                AluSrc1 <= 1'b0;
                //ImmType <= (Fn3==3'b001||Fn3==3'b101)? `shamtType : `ITYPE; // The immediate type is I-Type
                ImmType <= `ITYPE;
            end 
            7'b0000011: //I-type instruction // load instructions
            begin
                Jal <= 1'b0;
                Jalr <= 1'b0;
                case(Fn3)
                    3'b000: // LB
                        RegWrite <= `LB;
                    3'b001: // LH
                        RegWrite <= `LH;
                    3'b010: // LW
                        RegWrite <= `LW;
                    3'b100: // LBU
                        RegWrite <= `LBU;
                    3'b101: // LHU
                        RegWrite <= `LHU;
                endcase
                MemToReg <= 1'b1; // Load from memory
                MemWrite <= 4'b0000; // No memory write for Load instructions
                LoadNpc <= 1'b0; // Next PC is loaded
                RegRead <= 2'b10; // Read from A1
                BranchType <= `NOBRANCH; // No branching for Load instructions
                AluContrl <= `ADD;
                AluSrc2 <= 2'b10;  // The second operand of the ALU is Imm for Load instructions
                AluSrc1 <= 1'b0;
                ImmType <= `ITYPE; // The immediate type is I-Type
            end
            7'b1100111: //I-type instruction // JALR instruction
            begin
                Jal <= 1'b0; // Not a JAL instruction
                Jalr <= 1'b1; // Indicate JALR instruction
                MemToReg <= 1'b0; // Not using memory read for JALR instruction
                MemWrite <= 4'b0000; // Not writing to memory for JALR instruction
                LoadNpc <= 1'b1; //load the usual PC+4
                RegRead <= 2'b10; // Read from A1 (rs1) register for JALR instruction
                BranchType <= `NOBRANCH; // JALR is a type of jump, not a branch
                AluContrl <= `ADD; // Using addition in ALU for calculating jump offset
                AluSrc1 <= 1'b0; // First operand of ALU is the rs1 register value
                AluSrc2 <= 2'b10; // The second operand of the ALU is the immediate operand
                ImmType <= `ITYPE; // The immediate type is I-Type
                RegWrite <= 4'b1111; // Write result(PC+4) to rd register 
            end

             7'b0100011: //S-type instruction
            begin
                Jal <= 1'b0;
                Jalr <= 1'b0;
                RegWrite <= 4'b0000; // No register write for Store instructions
                MemToReg <= 1'b0; // No memory to register load for Store instructions
                LoadNpc <= 1'b0; // Next PC is loaded
                RegRead <= 2'b11; // Read from A1 and A2
                BranchType <= `NOBRANCH; // No branching for Store instructions
                AluContrl <= `ADD; // Calculate memory address
                AluSrc2 <= 2'b10;  // The second operand of the ALU is Imm for Store instructions
                AluSrc1 <= 1'b0;
                ImmType <= `STYPE; // The immediate type is S-Type
                case(Fn3)
                    3'b000: // SB
                        MemWrite <= 4'b0001;
                    3'b001: // SH
                        MemWrite <= 4'b0011;
                    3'b010: // SW
                        MemWrite <= 4'b1111;
                endcase
            end

            7'b1100011: //B-type instruction
            begin
                Jal <= 1'b0;
                Jalr <= 1'b0;
                RegWrite <= 4'b0000; // No register write for Branch instructions
                MemToReg <= 1'b0; // No memory to register load for Branch instructions
                MemWrite <= 4'b0000; // No memory write for Branch instructions
                LoadNpc <= 1'b0; // Next PC is not usual PC+4 for Branch instructions
                RegRead <= 2'b11; // Read from A1 and A2
                AluSrc2 <= 2'b00;  // The second operand of the ALU is from register for Branch instructions
                AluSrc1 <= 1'b0;
                ImmType <= `BTYPE; // The immediate type is B-Type
                case(Fn3)
                    3'b000: // BEQ
                        BranchType <= `BEQ;
                    3'b001: // BNE
                        BranchType <= `BNE;
                    3'b100: // BLT
                        BranchType <= `BLT;
                    3'b101: // BGE
                        BranchType <= `BGE;
                    3'b110: // BLTU
                        BranchType <= `BLTU;
                    3'b111: // BGEU
                        BranchType <= `BGEU;
                endcase
                AluContrl <= `SUB;
            end
             7'b0110111: //U-type instruction LUI
            begin
                Jal <= 1'b0;
                Jalr <= 1'b0;
                MemToReg <= 1'b0; // No memory to register load for LUI instructions
                MemWrite <= 4'b0000; // No memory write for LUI instructions
                LoadNpc <= 1'b0; // Next PC is usual PC+4
                RegRead <= 2'b00; // No read from A1 and A2 for LUI instruction
                BranchType <= `NOBRANCH; // No branching for LUI instructions
                AluContrl <= `LUI; // Add immediate to 0 for LUI instruction
                AluSrc2 <= 2'b10;  // The second operand of the ALU is Imm for LUI instructions
                AluSrc1 <= 1'b1; // The first operand of the ALU is zero for LUI instruction
                ImmType <= `UTYPE; // The immediate type is U-Type
                RegWrite <= 4'b1111; // Write to rd for LUI instructions
            end
             7'b0010111: //U-type instruction AUIPC
            begin
                Jal <= 1'b0;
                Jalr <= 1'b0;
                MemToReg <= 1'b0; // No memory to register load for AUIPC instructions
                MemWrite <= 4'b0000; // No memory write for AUIPC instructions
                LoadNpc <= 1'b0; //
                RegRead <= 2'b00; // No read from A1 and A2 for AUIPC instruction
                BranchType <= `NOBRANCH; // No branching for AUIPC instructions
                AluContrl <= `ADD; // Add immediate with PC for AUIPC instruction
                AluSrc2 <= 2'b10; // The second operand of the ALU is Imm for AUIPC instructions
                AluSrc1 <= 1'b1; // The first operand of the ALU is PC for AUIPC instruction
                ImmType <= `UTYPE; // The immediate type is U-Type
                RegWrite <= 4'b1111; // Write result to rd for AUIPC instructions
            end
            7'b1101111: //J-type instruction JAL
            begin
                Jal <= 1'b1; // Indicate JAL instruction
                Jalr <= 1'b0; // Not a JALR instruction
                MemToReg <= 1'b0; // Not using memory read for JAL instruction
                MemWrite <= 4'b0000; // Not writing to memory for JAL instruction
                LoadNpc <= 1'b1; // load the usual PC+4
                RegRead <= 2'b00; // Not using any source registers for JAL instruction
                BranchType <= `NOBRANCH; // JAL is a type of jump, not a branch
                AluContrl <= `ADD; // Using addition in ALU for calculating jump offset
                AluSrc1 <= 1'b1; // First operand of ALU is the PC
                AluSrc2 <= 2'b10; // The second operand of the ALU is the immediate operand
                ImmType <= `JTYPE; // The immediate type is J-Type
                RegWrite <= 4'b1111; // Write result(PC+4) to rd register 
            end

            default: // Default case
            begin
                Jal <= 1'b0;
                Jalr <= 1'b0; 
                MemToReg <= 1'b0; // Not using memory read 
                MemWrite <= 4'b0000; // Not writing to memory 
                LoadNpc <= 1'b0; // load the usual PC+4
                RegRead <= 2'b00; // Not using any source registers for JAL instruction
                BranchType <= `NOBRANCH;
                AluContrl <= `ADD; // Using addition in ALU for calculating jump offset
                AluSrc1 <= 1'b1; // First operand of ALU is the PC
                AluSrc2 <= 2'b10; // The second operand of the ALU is the immediate operand
                ImmType <= `RTYPE; 
                RegWrite <= 4'b0000; 
            end
        endcase
    end 

endmodule


//功能说明
    //ControlUnit       是本CPU的指令译码器，组合�?�辑电路
//输入
    // Op               是指令的操作码部�?
    // Fn3              是指令的func3部分
    // Fn7              是指令的func7部分
//输出
    // Jal==1          表示Jal指令信号
    // Jalr==1         表示Jalr指令信号
    // RegWrite        表示 寄存器写入模�? ，所有模式定义在Parameters.v�?
    // MemToReg==1     表示指令�?要将data memory读取的�?�写入寄存器,
    // MemWrite        �?4bit，采用独热码格式，对于data memory�?32bit字按byte进行写入,MemWrite=0001表示只写入最�?1个byte，和xilinx bram的接口类�?
    // LoadNpc==1      表示将NextPC输出到Result
    // RegRead[1]==1   表示A1对应的寄存器值被使用到了，RegRead[0]==1表示A2对应的寄存器值被使用到了
    // BranchType      表示不同的分支类型，�?有类型定义在Parameters.v�?
    // AluContrl       表示不同的ALU计算功能，所有类型定义在Parameters.v�?
    // AluSrc2         表示Alu输入�?2的�?�择
    // AluSrc1         表示Alu输入�?1的�?�择
    // ImmType         表示指令的立即数格式，所有类型定义在Parameters.v�?   
//实验要求  
    //实现ControlUnit模块   
    //ALUContrl[3:0]
//     `define SLL  4'd0
//     `define SRL  4'd1
//     `define SRA  4'd2
//     `define ADD  4'd3
//     `define SUB  4'd4
//     `define XOR  4'd5
//     `define OR  4'd6
//     `define AND  4'd7
//     `define SLT  4'd8
//     `define SLTU  4'd9
//     `define LUI  4'd10
// //BranchType[2:0]
//     `define NOBRANCH  3'd0
//     `define BEQ  3'd1
//     `define BNE  3'd2
//     `define BLT  3'd3
//     `define BLTU  3'd4
//     `define BGE  3'd5
//     `define BGEU  3'd6
// //ImmType[2:0]
//     `define RTYPE  3'd0
//     `define ITYPE  3'd1
//     `define STYPE  3'd2
//     `define BTYPE  3'd3
//     `define UTYPE  3'd4
//     `define JTYPE  3'd5  
// //RegWrite[2:0]  six kind of ways to save values to Register
//     `define NOREGWRITE  3'b0	//	Do not write Register
//     `define LB  3'd1			//	load 8bit from Mem then signed extended to 32bit
//     `define LH  3'd2			//	load 16bit from Mem then signed extended to 32bit
//     `define LW  3'd3			//	write 32bit to Register
//     `define LBU  3'd4			//	load 8bit from Mem then unsigned extended to 32bit
//     `define LHU  3'd5			//	load 16bit from Mem then unsigned extended to 32bit