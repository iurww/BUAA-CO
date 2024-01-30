module FloatType (
    input [31:0] num,
    output [4:0] type
);
    wire a;
    wire [7:0] b;
    wire [22:0] c;

    assign a = num[31];
    assign b = num[30:23];
    assign c = num[22:0];

    assign type = (!b && !c) ? 5'b00001 :
                  (b && b != 8'hff) ? 5'b00010 :
                  (!b && c) ? 5'b00100 :
                  (b == 8'hff && !c) ? 5'b01000 :
                  (b == 8'hff && c) ? 5'b10000 : 0;

endmodule