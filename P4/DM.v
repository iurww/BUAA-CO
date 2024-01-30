module DM (
    input [31:0] PC,
    input clk,
    input reset,
    input MWE,
    input [31:0] addr,
    input [31:0] data,
    input [1:0] DMWop,
    input [2:0] DMRop,
    output [31:0] DMout 
);
    reg [31:0] dm [0:1023];
    wire [9:0] waddr;
    integer i;

    assign waddr = addr[11:2];

    assign DMout = (DMRop == 0) ? dm[waddr] :
                   (DMRop == 1) ? {{16{dm[waddr][15+addr[1]*16]}}, dm[waddr][15 + addr[1] * 16 -:16]} :
                   (DMRop == 2) ? {{24{dm[waddr][7+addr[1:0]*8]}}, dm[waddr][7 + addr[1:0] * 8 -:8]} :32'd0;

    initial begin
        for(i = 0; i < 1024; i = i + 1) begin
            dm[i] <= 0;
        end
    end

    always @(posedge clk) begin
        if(reset) begin
            for(i = 0; i < 1024; i = i + 1) begin
              dm[i] <= 0;
            end
        end
        else if(MWE) begin
            if(DMWop == 0) dm[waddr] <= data;
            else if(DMWop == 1) dm[waddr][15 + addr[1] * 16 -:16] <= data[15:0];
            else dm[waddr][7 + addr[1:0] * 8 -:8] <= data[7:0];
            $display("@%h: *%h <= %h", PC, addr, data);
        end
    end

    
endmodule