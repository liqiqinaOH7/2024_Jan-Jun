`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: RISCV-Pipline CPU
// Module Name: MEMSegReg
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: EX-MEM Segment Register
//////////////////////////////////////////////////////////////////////////////////
module MWSegReg(
    input wire clk,
    input wire en,
    input wire clear,
    //Data Signals
    input wire [31:0] AluOutE,
    output reg [31:0] AluOutMW, 
    input wire [31:0] ForwardData2,
    input wire [4:0] RdE,
    output reg [4:0] RdMW,
    input wire [31:0] PCE,
    output reg [31:0] PCMW,
    output wire [31:0] RD,
    //Data Memory Debug
    input wire [31:0] A2,
    input wire [31:0] WD2,
    input wire [3:0] WE2,
    output wire [31:0] RD2,
    //Control Signals
    input wire [3:0] MemWriteE,
    input wire [2:0] RegWriteE,
    output reg [2:0] RegWriteMW,
    input wire MemToRegE,
    output reg MemToRegMW,
    input wire LoadNpcE,
    output reg LoadNpcMW
    );
    reg [3:0] wea;
    reg [31:0] dina;
    reg [31:0] addra;
    DataRam DataRamInst (
        .clk    ( clk            ),                      //请补全
        .wea    ( wea            ),                      //请补全
        .addra  ( addra          ),                      //请补全
        .dina   ( dina           ),                      //请补全
        .douta  ( RD             ),
        .web    ( WE2            ),
        .addrb  ( A2[31:2]       ),
        .dinb   ( WD2            ),
        .doutb  ( RD2            )
    );   
    initial begin
        AluOutMW <= 32'b0;  
        RdMW <= 5'b0;
        PCMW <= 32'b0;
        RegWriteMW <= 3'b0;
        MemToRegMW <= 1'b0;
        LoadNpcMW <= 1'b0;
    end
    always@(posedge clk) begin
        if(en)
            if(clear) 
                begin
                    AluOutMW <= 32'b0;
                    RdMW <= 5'b0;
                    PCMW <= 32'b0;
                    RegWriteMW <= 3'b0;
                    MemToRegMW <= 1'b0;
                    LoadNpcMW <= 1'b0;
                    wea <= 4'b0;
                    dina <= 32'b0;
                    addra <= 32'b0;
                end 
            else begin
                    AluOutMW <= AluOutE;
                    RdMW <= RdE;
                    PCMW <= PCE;
                    RegWriteMW <= RegWriteE;
                    MemToRegMW <= ((RdE)?MemToRegE:0);
                    LoadNpcMW <= LoadNpcE;
                    wea <= MemWriteE<<AluOutE[1:0];
                    dina <= ForwardData2<<(AluOutE[1:0]*8);
                    addra <= AluOutE[31:2];
                end
    end
        
endmodule
//功能说明
    //MWSegReg是第四段寄存器
    //类似于IDSegReg.V中对Bram的调用和拓展，它同时包含了一个同步读写的Bram
    //（此处你可以调用我们提供的举例：DataRam，它将会自动综合为block memory，你也可以替代性的调用xilinx的bram ip核）。
    //举例：DataRam DataRamInst (
    //    .clk    (),                      //请补全
    //    .wea    (),                      //请补全
    //    .addra  (),                      //请补全
    //    .dina   (),                      //请补全
    //    .douta  ( RD_raw         ),
    //    .web    ( WE2            ),
    //    .addrb  ( A2[31:2]       ),
    //    .dinb   ( WD2            ),
    //    .doutb  ( RD2            )
    //    );  

//实验要求  
    //实现MWSegReg模块

//注意事项
    //输入到DataRam的addra是字地址，一个字32bit
    //请配合DataExt模块实现非字对齐字节load
