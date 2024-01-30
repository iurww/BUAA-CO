module GRF (
    input [31:0] PC,
    input clk,
    input reset,
    input RWE,          //Register Write Enable
    input [4:0] A1,     //Read Address 1
    input [4:0] A2,     //Read Address 2
    input [4:0] A3,     //Write Address 
    input [31:0] RWD,   //Register Write Data 
    output [31:0] RD1,  //Read Data 1
    output [31:0] RD2   //Read Data 2
);
    reg [31:0] grf [31:0];
    integer i;

    initial begin
        for(i = 0; i < 32; i = i + 1) begin
            grf[i] <= 0;
        end
    end

    always @(posedge clk) begin
        if(reset) begin
            for(i = 0; i < 32; i = i + 1) begin
                grf[i] <= 0;
            end
        end
        else if(RWE) begin
            if(A3) begin
                grf[A3] <= RWD;
                $display("@%h: $%d <= %h", PC, A3, RWD);
            end
        end
    end
    
    assign RD1 = grf[A1];
    assign RD2 = grf[A2];
    
endmodule