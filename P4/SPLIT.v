module SPLIT (
    input [31:0] instr,
    output [5:0] opcode,
    output [4:0] Rs,
    output [4:0] Rt,
    output [4:0] Rd,
    output [4:0] shamt,
    output [5:0] funct,
    output [15:0] imm16,
    output [25:0] imm26
);
    assign opcode = instr[31:26];
    assign Rs = instr[25:21];
    assign Rt = instr[20:16];
    assign Rd = instr[15:11];
    assign shamt = instr[10:6];
    assign funct = instr[5:0];
    assign imm16 = instr[15:0];
    assign imm26 = instr[25:0];
    
endmodule