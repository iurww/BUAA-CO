module alu (
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUOp,
    output [31:0] C
);
    assign C = (ALUOp == 3'b000) ? A + B :
               (ALUOp == 3'b001) ? A - B :
               (ALUOp == 3'b010) ? A & B :
               (ALUOp == 3'b011) ? A | B :
               (ALUOp == 3'b100) ? A >> B : $signed($signed(A) >>> B);
endmodule