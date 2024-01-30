module D_GRF (
    input clk,          // 时钟信号
    input reset,        // 同步复位信号
    
    input [4:0] A1,     //Read Address 1
    input [4:0] A2,     //Read Address 2
    input [4:0] RWA,    //Register Write Address  
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
            for(i = 0; i < 32; i = i + 1) 
                grf[i] <= 0;
        end
        else if(RWA) begin
            grf[RWA] <= RWD;
        end
    end
    
    // 内部转发 W -> D
    assign RD1 = (RWA == A1 && RWA) ? RWD : grf[A1];
    assign RD2 = (RWA == A2 && RWA) ? RWD : grf[A2];
    
endmodule