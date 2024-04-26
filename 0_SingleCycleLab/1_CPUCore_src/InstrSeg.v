`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV CPU
// Module Name: InstrSeg
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
//////////////////////////////////////////////////////////////////////////////////
module InstrSeg(
    input wire clk,
    //Instrution Memory Access
    input wire [31:0] A,
    output wire [31:0] RD,
    //Instruction Memory Debug
    input wire [31:0] A2,
    input wire [31:0] WD2,
    input wire [3:0] WE2,
    output wire [31:0] RD2
    //
    );  
    
    wire [31:0] RD_raw;
    InstructionRam InstructionRamInst (
         .clk    (clk),                        //请补全
         .addra  (A[31:2]),                        //请补全
         .douta  ( RD_raw     ),
         .web    ( |WE2       ),
         .addrb  ( A2[31:2]   ),
         .dinb   ( WD2        ),
         .doutb  ( RD2        )
     );
  
    assign RD =  RD_raw;

endmodule


//功能说明
    //InstrSeg同时包含了一个同步读写的Bram
    //（此处你可以调用我们提供的InstructionRam，它将会自动综合为block memory，你也可以替代性的调用xilinx的bram ip核）。
//实验要求  
    //你需要补全上方代码，需补全的片段截取如下
    //InstructionRam InstructionRamInst (
    //     .clk    (???),                        //请补全
    //     .addra  (???),                        //请补全
    //     .douta  ( RD_raw     ),
    //     .web    ( |WE2       ),
    //     .addrb  ( A2[31:2]   ),
    //     .dinb   ( WD2        ),
    //     .doutb  ( RD2        )
    // );
//注意事项
    //输入到DataRam的addra是字地址，一个字32bit