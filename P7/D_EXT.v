module D_EXT (
    input [15:0] imm16,    // 16位立即数
    input EXTop,           // 符号扩展类型
    output [31:0] EXTout   // 扩展结果
);

    assign EXTout = EXTop ? {{16{imm16[15]}}, imm16} : {{16{1'b0}}, imm16};
    
endmodule