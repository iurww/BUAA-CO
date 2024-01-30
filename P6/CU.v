module CU (
    input [31:0] instr,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [4:0] shamt,
    output [15:0] imm16,
    output [25:0] imm26,

    output cal_r,
    output cal_i,
    output load,
    output store,
    output branch,
    output jump_i,
    output jump_r,
    output mdc,
    output mdf,
    output mdt,

    output RWE,
    output MWE,
    output [3:0] ALUop,
    output EXTop,
    output [2:0] NPCop,
    output [3:0] CMPop,
    output [2:0] DMRop,
    output [1:0] DMWop,
    output [3:0] MDUop,
    output [4:0] RWAsel,
    output [1:0] RWDsel,
    output ALUBsel
);
    wire [5:0] opcode, funct;
    assign opcode = instr[31:26];
    assign funct = instr[5:0];

    assign rs = instr[25:21];
    assign rt = instr[20:16];
    assign rd = instr[15:11];
    assign shamt = instr[10:6];    

    assign imm16 = instr[15:0];
    assign imm26 = instr[25:0];

    wire R;
    assign R = (opcode == 6'b000000);
    
    wire add, sub, And, Or, sll, sllv, slt, sltu, addu, subu;
    wire addi, lui, ori, andi;
    wire sw, sh, sb;
    wire lw, lh, lb, lhu, lbu;
    wire beq, bne, j, jal, jr;
    wire mult, multu, div, divu, mfhi, mflo, mthi, mtlo;
    wire madd, maddu, msub, msubu;

    assign add = (R && funct == 6'b10_0000);
    assign sub = (R && funct == 6'b10_0010);
    assign addu = (R && funct == 6'b10_0001);
    assign subu = (R && funct == 6'b10_0011);
    assign And = (R && funct == 6'b10_0100);
    assign Or = (R && funct == 6'b10_0101);
    //assign sll = (R && funct == 6'b00_0000);
    //assign sllv = (R && funct == 6'b00_0100);
    assign slt = (R && funct == 6'b10_1010);
    assign sltu = (R && funct == 6'b10_1011);

    assign addi = (opcode == 6'b00_1000);
    assign lui = (opcode == 6'b00_1111);
    assign ori = (opcode == 6'b00_1101);
    assign andi = (opcode == 6'b00_1100);

    assign sw = (opcode == 6'b10_1011);
    assign sh = (opcode == 6'b10_1001);
    assign sb = (opcode == 6'b10_1000);

    assign lw = (opcode == 6'b10_0011);
    assign lh = (opcode == 6'b10_0001);
    assign lb = (opcode == 6'b10_0000);
    assign lhu = (opcode == 6'b10_0101);
    assign lbu = (opcode == 6'b10_0100);

    assign beq = (opcode == 6'b00_0100);
    assign bne = (opcode == 6'b00_0101);
    assign j = (opcode == 6'b00_0010);
    assign jal = (opcode == 6'b00_0011);
    assign jr = (R && funct == 6'b00_1000);

    assign mult = (R && funct == 6'b01_1000);
    assign multu = (R && funct == 6'b01_1001);
    assign div = (R && funct == 6'b01_1010);
    assign divu = (R && funct == 6'b01_1011);
    assign mfhi = (R && funct == 6'b01_0000);
    assign mflo = (R && funct == 6'b01_0010);
    assign mthi = (R && funct == 6'b01_0001);
    assign mtlo = (R && funct == 6'b01_0011);
    assign madd = (opcode == 6'b01_1100 && funct == 6'b00_0000);
    assign maddu = (opcode == 6'b01_1100 && funct == 6'b00_0001);
    assign msub = (opcode == 6'b01_1100 && funct == 6'b00_0100);
    assign msubu = (opcode == 6'b01_1100 && funct == 6'b00_0101);

    assign cal_r = (add || sub || And || Or || slt || sltu || addu || subu);
    assign cal_i = (addi || lui || ori || andi);
    assign load = (lw || lh || lb || lhu || lbu);
    assign store = (sw || sh || sb);
    assign branch = (beq || bne);
    assign jump_i = (j || jal);
    assign jump_r = (jr);
    assign mdc = (mult || multu || div || divu || madd || maddu || msub || msubu);
    assign mdf = (mfhi || mflo);
    assign mdt = (mthi || mtlo);

    //0:not write, 1:write
    assign RWE = (add || addi || sub || And || Or || lui || ori ||
                  andi || jal || lw || lh || lb || slt || sltu || mfhi || mflo ||
                  lhu || lbu || addu || subu) ? 1 : 0;

    //0:not write, 1:write
    assign MWE = (sw || sh || sb) ? 1 : 0;
    
    //0:+, 1:-, 2:lui, 3:|, 4:&, 5:<, 6<unsigned, 
    assign ALUop = (add || addu || addi || lw || sw || lh || sh || lb || sb || lhu || lbu) ? 0 :
                   (sub || subu) ? 1 : 
                   (lui) ? 2 : 
                   (ori || Or) ? 3 : 
                   (andi || And) ? 4 : 
                   (slt) ? 5 : 
                   (sltu) ? 6 : 0;
    
    //0:unsigned, 1:signed
    assign EXTop = (addi || sw || lw || sh || lh || sb || lb || lhu || lbu) ? 1 : 0;

    //0:PC+4, 1:branch, 2:j, 3:j-register
    assign NPCop = (beq || bne) ? 1 : 
                   (j || jal) ? 2 :
                   (jr) ? 3 : 0;

    //0:beq, 1:bne, 2:0
    assign CMPop = (beq) ? 0 :
                   (bne) ? 1 : 10;

    //0:word, 1:halfword, 2:byte
    assign DMRop = (lh) ? 1 :
                   (lb) ? 2 : 
                   (lhu) ? 3 : 
                   (lbu) ? 4 : 0;
    
    //0:word, 1:halfword, 2:byte
    assign DMWop = (sh) ? 1 :
                   (sb) ? 2 : 0;               

    //0:rt, 1:rd, 2:31($ra)
    assign RWAsel = (lw || lh || lb || addi || lui || ori || andi || lhu || lbu) ? rt :
                    (add || sub || addu || subu || And || Or || slt || sltu || mfhi || mflo) ? rd :
                    (jal) ? 5'd31 : 5'd0;
               
    //0:ALUout, 1:DMout, 2:PC+8, 3:MDUout
    assign RWDsel = (add || addi || sub || lui || andi || ori || And ||
                     Or || slt || sltu || addu || subu) ? 0 :
                    (lw || lh || lb || lhu || lbu) ? 1 : 
                    (jal) ? 2 : 
                    (mfhi || mflo) ? 3 : 0;
    
    //0:RD2, 1:EXTout
    assign ALUBsel = (addi || sw || lw || sh || lh || sb || lb || andi ||
                      ori || lui || lhu || lbu) ? 1 : 0;

    assign MDUop = (mult) ? 1 : 
                   (multu) ? 2 :
                   (div) ? 3 : 
                   (divu) ? 4 :
                   (mfhi) ? 5 :
                   (mflo) ? 6 :
                   (mthi) ? 7 :
                   (mtlo) ? 8 : 
                   (madd) ? 9 :
                   (maddu) ? 10 : 
                   (msub) ? 11: 
                   (msubu) ? 12 : 0;
endmodule

/*
add, sub, and, or, slt, sltu, lui, addu, subu
addi, andi, ori
lb, lh, lw, sb, sh, sw, lhu, lbu
mult, multu, div, divu, mfhi, mflo, mthi, mtlo
beq, bne, jal, jr
*/