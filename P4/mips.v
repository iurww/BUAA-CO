`include "IFU.v"
`include "NPC.v"
`include "SPLIT.v"
`include "CU.v"
`include "ALU.v"
`include "EXT.v"
`include "GRF.v"
`include "DM.v"

module mips (
    input clk,
    input reset
);

    wire [31:0] PC, PC4, NPC, instr;
    wire [5:0] opcode, funct;
    wire [4:0] Rs, Rt, Rd, shamt;
    wire [15:0] imm16;
    wire [25:0] imm26; 

    wire RegWrite, MemWrite;
    wire [3:0] ALUop;
    wire EXTop;
    wire [1:0] jumpop;
    wire [2:0] DMRop;
    wire [1:0] DMWop;
    wire [1:0] A3Sel, RWDSel;
    wire ALUBSel;

    wire [31:0] ALUout, EXTout, RD1, RD2, DMout;
    wire equal;

    IFU ifu (
        .clk(clk),
        .reset(reset),
        .NPC(NPC),
        .PC(PC),
        .instr(instr)
    );

    NPC npc (
        .PC(PC),
        .imm26(imm26),
        .RD1(RD1),
        .equal(equal),
        .jumpop(jumpop),
        .PC4(PC4),
        .NPC(NPC)
    );

    SPLIT split (
        .instr(instr), 
        .opcode(opcode), 
        .Rs(Rs), 
        .Rt(Rt), 
        .Rd(Rd), 
        .shamt(shamt), 
        .funct(funct), 
        .imm16(imm16), 
        .imm26(imm26)
    );

    CU cu (
        .opcode(opcode), 
        .funct(funct), 
        .RegWrite(RegWrite), 
        .MemWrite(MemWrite), 
        .ALUop(ALUop), 
        .EXTop(EXTop), 
        .jumpop(jumpop), 
        .DMRop(DMRop), 
        .DMWop(DMWop), 
        .A3Sel(A3Sel), 
        .RWDSel(RWDSel), 
        .ALUBSel(ALUBSel)
    );

    wire [4:0] A3;
    assign A3 = (A3Sel == 0) ? Rt : 
                (A3Sel == 1) ? Rd : 
                (A3Sel == 2) ? 31 : 0;
    wire [31:0] RWD;
    assign RWD = (RWDSel == 0) ? ALUout : 
                 (RWDSel == 1) ? DMout : 
                 (RWDSel == 2) ? PC4 : 0;
    GRF grf (
        .PC(PC),
        .clk(clk), 
        .reset(reset), 
        .RWE(RegWrite), 
        .A1(Rs), 
        .A2(Rt), 
        .A3(A3), 
        .RWD(RWD), 
        .RD1(RD1), 
        .RD2(RD2)
    );

    wire [31:0] B;
    assign B = (ALUBSel == 0) ? RD2 : EXTout;
    ALU alu (
        .A(RD1), 
        .B(B), 
        .shamt(shamt), 
        .ALUop(ALUop), 
        .equal(equal), 
        .ALUresult(ALUout)
    );

    EXT ext (
        .imm16(imm16), 
        .EXTop(EXTop), 
        .EXTout(EXTout)
    );

    DM dm (
        .PC(PC),
        .clk(clk), 
        .reset(reset), 
        .MWE(MemWrite), 
        .addr(ALUout), 
        .data(RD2), 
        .DMWop(DMWop), 
        .DMRop(DMRop), 
        .DMout(DMout)
    );




endmodule