module comparator (
    input [3:0] A,
    input [3:0] B,
    output Out
);
    
    wire [4:0] C;
    assign C = {A[3],A} - {B[3],B};
    assign Out = (C[4] == 1'b1) ? 1'b1 : 1'b0;
    
endmodule