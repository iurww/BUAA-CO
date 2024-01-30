module E_ALU (
    input [31:0] A,                 // 运算数1
    input [31:0] B,                 // 运算数2
    input [4:0] shamt,              // 指令shamt段
    input [3:0] ALUop,              // ALU运算类型
    output reg [31:0] ALUresult,    // ALU运算结果

    input check_Ov,                 // 是否检查add,addi,sub溢出
    input check_AdEL,               // 是否检查load型指令地址溢出
    input check_AdES,               // 是否检查store型指令地址溢出
    output Ov,                      // E级是否存在Ov异常
    output AdEL,                    // E级是否存在AdEL异常
    output AdES                     // E级是否存在AdES异常 
);
    always @(*) begin
        case(ALUop)
            0: ALUresult = A + B;
            1: ALUresult = A - B;
            2: ALUresult = B << 16;
            3: ALUresult = A | B;
            4: ALUresult = A & B;
            5: ALUresult = $unsigned($signed(A) < $signed(B));
            6: ALUresult = (A < B);
            default: ALUresult = 0;
        endcase
    end

    wire [32:0] Aext = {A[31], A};
    wire [32:0] Bext = {B[31], B};
    wire [32:0] add = Aext + Bext;
    wire [32:0] sub = Aext - Bext;
    wire add_Ov = (add[32] != add[31]);
    wire sub_Ov = (sub[32] != sub[31]);

    assign Ov = (check_Ov && ((add_Ov && ALUop == 0) || (sub_Ov && ALUop == 1)));  //add,sub,addi溢出
    assign AdEL = (check_AdEL && add_Ov);          //load地址溢出
    assign AdES = (check_AdES && add_Ov);          //store地址溢出

endmodule 