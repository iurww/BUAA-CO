module CU (
    input [5:0] opcode,
    input [5:0] funct,
    output RegWrite,
    output MemWrite,
    output [3:0] ALUop,
    output EXTop,
    output [1:0] jumpop,
    output [2:0] DMRop,
    output [1:0] DMWop,
    output [1:0] A3Sel,
    output [1:0] RWDSel,
    output ALUBSel
);
    wire R;
    assign R = (opcode == 6'b000000);
    
    wire add, sub, And, Or, jr, sll, sllv, slt;
    wire addi, lui, ori, sw, sh, sb, lw, lh, lb;
    wire beq, j, jal;

    assign add = (R && funct == 6'b10_0000);
    assign sub = (R && funct == 6'b10_0010);
    assign And = (R && funct == 6'b10_0100);
    assign Or = (R && funct == 6'b10_0101);
    assign jr = (R && funct == 6'b00_1000);
    assign sll = (R && funct == 6'b00_0000);
    assign sllv = (R && funct == 6'b00_0100);
    assign slt = (R && funct == 6'b10_1010);

    assign addi = (opcode == 6'b00_1000);
    assign lui = (opcode == 6'b00_1111);
    assign ori = (opcode == 6'b00_1101);
    assign sw = (opcode == 6'b10_1011);
    assign sh = (opcode == 6'b10_1001);
    assign sb = (opcode == 6'b10_1000);
    assign lw = (opcode == 6'b10_0011);
    assign lh = (opcode == 6'b10_0001);
    assign lb = (opcode == 6'b10_0000);

    assign beq = (opcode == 6'b00_0100);
    assign j = (opcode == 6'b00_0010);
    assign jal = (opcode == 6'b00_0011);

    assign RegWrite = (add || addi || sub || lui || ori ||
                       Or || And || jal || sll || sllv ||
                       slt || lw || lh || lb) ? 1 : 0;

    assign MemWrite = (sw || sh || sb) ? 1 : 0;

    assign ALUop = (sub || beq) ? 1 : 
                   (lui) ? 2 : 
                   (Or || ori) ? 3 : 
                   (And) ? 4 :
                   (sll) ? 5 :
                   (sllv) ? 6 :
                   (slt) ? 7 : 0;
    
    assign EXTop = (sw || lw || sh || lh || sb || lb || addi) ? 1 : 0;

    assign jumpop = (beq) ? 1 : 
                    (j || jal) ? 2 :
                    (jr) ? 3 : 0;

    assign DMRop = (lh) ? 1 :
                   (lb) ? 2 : 0;
    
    assign DMWop = (sh) ? 1 :
                   (sb) ? 2 : 0;               

    assign A3Sel = (R) ? 1 : 
                   (jal) ? 2 : 0;
    
    assign RWDSel = (lw || lh || lb) ? 1 : 
                    (jal) ? 2 : 0;

    assign ALUBSel = (sw || lw || sh || lh || sb || lb ||
                      addi || ori || lui) ? 1 : 0;

endmodule