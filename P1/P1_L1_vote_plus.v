module VoterPlus (
    input clk,
    input reset,
    input [31:0] np,
    input [7:0] vip,
    input vvip,
    output [7:0] result
);
    reg [7:0] sum;
    
    reg [31:0] curnp;
    reg [7:0] curvip;
    reg curvvip;

    assign result = sum;

    integer i;
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            curnp <= 0;
            curvip <= 0;
            curvvip <= 0;
            sum <= 0;
        end
        else begin
            sum = 0;
            curnp = curnp | np;
            curvip = curvip | vip;
            curvvip = curvvip | vvip;
            for(i = 0; i <= 31; i = i + 1) begin
                if(curnp[i]) 
                    sum = sum + 1; 
            end
            for(i = 0; i <= 7; i = i + 1) begin
                if(curvip[i]) 
                    sum = sum + 4; 
            end
            if(curvvip) sum = sum + 16;
        end
    end

endmodule