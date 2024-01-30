module NPC (
    input [31:0] PC,
    input [25:0] imm26,
    input [31:0] RD1,
    input equal,
    input [1:0] jumpop,
    output [31:0] PC4,
    output [31:0] NPC
);
    assign PC4 = PC + 4;
    assign NPC = (jumpop == 0) ? PC + 4 :
                 (jumpop == 1 && equal) ? ({{16{imm26[15]}}, imm26[15:0]} << 2) + PC4:
                 (jumpop == 2) ? {PC[31:28], imm26, 2'b00} : 
                 (jumpop == 3) ? RD1 : PC + 4; 
    
endmodule