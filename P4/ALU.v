module ALU (
    input [31:0] A,
    input [31:0] B,
    input [4:0] shamt,
    input [3:0] ALUop,
    output equal,
    output [31:0] ALUresult
);
    assign ALUresult = (ALUop == 0) ? A + B :
                       (ALUop == 1) ? A - B :
                       (ALUop == 2) ? B << 16 :
                       (ALUop == 3) ? A | B :
                       (ALUop == 4) ? A & B :
                       (ALUop == 5) ? B << shamt :
                       (ALUop == 6) ? B << A[4:0] : 
                       (ALUop == 7) ? {{31{1'b0}}, $signed($signed(A) < $signed(B))} : 0;

    assign equal = (A == B);

endmodule 