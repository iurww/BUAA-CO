module CU (
    input [31:0] instr,       // 指令
    output [4:0] rs,          // rs[25:21]
    output [4:0] rt,          // rt[20:16]
    output [4:0] rd,          // rd[15:11]
    output [4:0] shamt,       // shamt[10:6]
    output [15:0] imm16,      // imm16[15:0]
    output [25:0] imm26,      // imm26[25:0]

    output cal_r,             // R型计算指令
    output cal_i,             // I型计算指令
    output load,              // 取存型指令
    output store,             // 写存型指令
    output branch,            // 条件分支型指令
    output jump_i,            // 直接跳转型指令
    output jump_r,            // 间接跳转型指令
    output mdc,               // 计算型乘除指令
    output mdf,               // 取hi,lo
    output mdt,               // 写hi,lo

    output [3:0] ALUop,       // ALU运算类型
    output EXTop,             // 16位立即数符号扩展类型
    output [2:0] NPCop,       // 跳转类型
    output [3:0] CMPop,       // 条件分支条件类型
    output [2:0] DMRop,       // 取内存字长类型
    output [2:0] DMWop,       // 写内存字长类型
    output [3:0] MDUop,       // 乘除单元指令类型
    output [4:0] RWAsel,      // 寄存器写地址
    output [2:0] RWDsel,      // 寄存器写数据来源
    output ALUBsel,           // ALU第二个运算数来源

    output check_AdEL,        // 是否检查AdEL（取数）型异常
    output check_Ov,          // 是否检查Ov（溢出）型异常
    output check_AdES,        // 是否检查AdES（存数）型异常
    output RI,                // 是否为未知指令

    output eret,              // 是否为eret
    output syscall,           // 是否为syscall
    output mfc0,              // 是否为mfc0
    output mtc0               // 是否为mtc0
);
    //拆解
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
    
    wire nop;
    wire add, sub, And, Or, slt, sltu;
    wire addi, lui, ori, andi;
    wire sw, sh, sb;
    wire lw, lh, lb;
    wire beq, bne, jal, jr;
    wire mult, multu, div, divu, mfhi, mflo, mthi, mtlo;

    assign nop = (instr == 32'h0);

    assign add = (R && funct == 6'b10_0000);
    assign sub = (R && funct == 6'b10_0010);
    assign And = (R && funct == 6'b10_0100);
    assign Or = (R && funct == 6'b10_0101);
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

    assign beq = (opcode == 6'b00_0100);
    assign bne = (opcode == 6'b00_0101);
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

    assign mfc0 = (instr[31:21] == 11'b010000_00000 && instr[10:0] == 11'b0);
    assign mtc0 = (instr[31:21] == 11'b010000_00100 && instr[10:0] == 11'b0);
    assign eret = (instr == 32'b010000_10000000000000000000_011000);
    assign syscall = (R && funct == 6'b00_1100);

    //分类
    assign cal_r = (add || sub || And || Or || slt || sltu);
    assign cal_i = (addi || lui || ori || andi);
    assign load = (lw || lh || lb);
    assign store = (sw || sh || sb);
    assign branch = (beq || bne);
    assign jump_i = (jal);
    assign jump_r = (jr);
    assign mdc = (mult || multu || div || divu);
    assign mdf = (mfhi || mflo);
    assign mdt = (mthi || mtlo);

    //0:+, 1:-, 2:lui, 3:|, 4:&, 5:<, 6<unsigned, 
    assign ALUop = (add || addi || lw || sw || lh || sh || lb || sb) ? 0 :
                   (sub) ? 1 : 
                   (lui) ? 2 : 
                   (ori || Or) ? 3 : 
                   (andi || And) ? 4 : 
                   (slt) ? 5 : 
                   (sltu) ? 6 : 0;
    
    //0:unsigned, 1:signed
    assign EXTop = (addi || sw || lw || sh || lh || sb || lb) ? 1 : 0;

    //0:PC+4, 1:branch, 2:j, 3:j-register
    assign NPCop = (beq || bne) ? 1 : 
                   (jal) ? 2 :
                   (jr) ? 3 : 0;

    //0:beq, 1:bne, 2:0
    assign CMPop = (beq) ? 0 :
                   (bne) ? 1 : 10;

    //1:word, 2:halfword, 3:byte
    assign DMRop = (lw) ? 1 : 
                   (lh) ? 2 :
                   (lb) ? 3 : 0;
    
    //1:word, 2:halfword, 3:byte
    assign DMWop = (sw) ? 1 :
                   (sh) ? 2 :
                   (sb) ? 3 : 0;               

    //0:rt, 1:rd, 2:31($ra)
    assign RWAsel = (lw || lh || lb || addi || lui || ori || andi) ? rt :
                    (add || sub || And || Or || slt || sltu || mfhi || mflo) ? rd :
                    (mfc0) ? rt : 
                    (jal) ? 5'd31 : 5'd0;
               
    //0:ALUout, 1:DMout, 2:PC+8, 3:MDUout, 4:CP0out
    assign RWDsel = (add || addi || sub || lui || andi || ori || And ||
                     Or || slt || sltu) ? 0 :
                    (lw || lh || lb) ? 1 : 
                    (jal) ? 2 : 
                    (mfhi || mflo) ? 3 : 
                    (mfc0) ? 4 : 0;
    
    //0:RD2, 1:EXTout
    assign ALUBsel = (addi || sw || lw || sh || lh || sb || lb || andi ||
                      ori || lui) ? 1 : 0;

    assign MDUop = (mult) ? 1 : 
                   (multu) ? 2 :
                   (div) ? 3 : 
                   (divu) ? 4 :
                   (mfhi) ? 5 :
                   (mflo) ? 6 :
                   (mthi) ? 7 :
                   (mtlo) ? 8 : 0;
        
    assign check_Ov = (add || sub || addi);

    assign check_AdEL = (lw || lh || lb);

    assign check_AdES = (sw || sh || sb);

    assign RI = !(nop || add || sub || And || Or || slt || sltu ||
                  lui || addi || andi || ori ||
                  lb || lh || lw || sb || sh || sw ||
                  mult || multu || div || divu || mfhi || mflo || mthi || mtlo ||
                  beq || bne || jal || jr ||
                  mfc0 || mtc0 || eret || syscall) ? 1 : 0;
endmodule

/*
nop, add, sub, and, or, slt, sltu
lui, addi, andi, ori
lb, lh, lw, sb, sh, sw
mult, multu, div, divu, mfhi, mflo, mthi, mtlo
beq, bne, jal, jr,
mfc0, mtc0, eret, syscall
*/