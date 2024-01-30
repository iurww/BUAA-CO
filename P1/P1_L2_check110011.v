module fsm (
    input clk,
    input reset,
    input in,
    output out
);
    reg [5:0] cur;
    
    assign out = (cur == 6'b110011) ? 1 : 0;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            cur <= 6'b000000;
        end
        else begin
            cur <= {cur[4:0], in};
        end
    end
    
endmodule