module F_PC (
    input clk,
    input reset,
    input en,

    input [31:0] NPC,
    output reg [31:0] PC
);

    always @(posedge clk) begin
        if(reset) PC <= 32'h0000_3000;
        else if(en) PC <= NPC;
        else PC <= PC;
    end
    
endmodule