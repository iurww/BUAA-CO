module IFU (
    input clk,
    input reset,
    input [31:0] NPC,
    output reg [31:0] PC,
    output [31:0] instr
);
    reg [31:0] IM [0:8191];

    initial begin
        PC <= 32'h0000_3000;
        $readmemh("code.txt", IM);
    end

    always @(posedge clk) begin
        if(reset) PC <= 32'h0000_3000;
        else PC <= NPC;
    end
    
    assign instr = IM[PC[16:2] - 13'hc00];

endmodule