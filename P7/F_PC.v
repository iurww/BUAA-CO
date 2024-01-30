module F_PC (
    input clk,                // 时钟信号
    input reset,              // 同步复位信号
    input int_req,            // 中断信号
    input stall,              // 阻塞信号

    input [31:0] NPC,         // 待写入PC的值
    output reg [31:0] PC,     // F级 PC寄存器

    output AdEL               // F级是否存在AdEL异常
);

    always @(posedge clk) begin
        if(reset) PC <= 32'h0000_3000;          // 复位至0x00003000
        else if(int_req) PC <= 32'h0000_4180;   // 中断则跳转至0x00004180
        else if(!stall) PC <= NPC;              // 不阻塞则写入下一条指令PC值
    end

    assign AdEL = (PC[1:0] != 2'b00) ? 1 :    //PC未对齐
                  (PC<32'h0000_3000 || PC>32'h00006ffc) ? 1 : 0;  //非法PC
    
endmodule