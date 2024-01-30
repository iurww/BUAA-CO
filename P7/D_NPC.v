module D_NPC (
    input [31:0] F_PC,     // F级PC
    input [31:0] D_PC,     // D级PC
    input [31:0] EPC,      // CP0: EPC
    input [25:0] imm26,    // 26位地址
    input [31:0] rs_data,  // rs寄存器值
    input need_b,          // 是否满足分支条件
    input eret,            // 是否为eret
    input [2:0] NPCop,     // 跳转类型
    output [31:0] NPC      // 下一个上升沿应该写入PC的值
);
    assign NPC = (eret) ? EPC + 4 :
                 (NPCop == 0) ? F_PC + 4 :
                 (NPCop == 1 && need_b) ? {{16{imm26[15]}}, imm26[15:0], 2'b00} + D_PC + 4 :
                 (NPCop == 2) ? {D_PC[31:28], imm26, 2'b00} : 
                 (NPCop == 3) ? rs_data : F_PC + 4; 
    
endmodule