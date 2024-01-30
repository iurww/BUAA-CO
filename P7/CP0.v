`define IM SR[15:10]          // 是否允许外部中断
`define EXL SR[1]             // 是否处于异常状态，是则禁止中断
`define IE SR[0]              // 是否允许中断

`define BD CAUSE[31]          // 是否为延迟槽指令
`define IP CAUSE[15:10]       // 是否存在外部中断
`define ExcCode CAUSE[6:2]    // 异常种类

module CP0 (
    input clk,                // 时钟信号
    input reset,              // 同步复位信号
    input en,                 // CP0寄存器写使能信号
    input EXL_reset,          // eret产生的EXL位复位信号

    input [4:0] CP0A,         // 读/写CP0寄存器编号
    input [31:0] CP0_in,      // 待写入CP0数据
    input [31:0] VPC,         // 受害PC

    input [5:0] HWint_in,     // 外部中断信号
    input BD_in,              // 是否为延迟槽指令
    input [4:0] ExcCode_in,   // 内部异常码

    output [31:0] CP0_out,    // CP0寄存器读出数据
    output [31:0] EPC_out,    // EPC寄存器的值
    output int_req            // 中断请求
);
    reg [31:0] SR, CAUSE, EPC;

    wire hw_int = (|(HWint_in & `IM)) & !`EXL & `IE;
    wire exc_int = (|ExcCode_in) & !`EXL;   
    assign int_req = hw_int | exc_int;

    initial begin
        SR <= 0;
        CAUSE <= 0;
        EPC <= 0;
    end

    always @(posedge clk) begin
        if(reset) begin
            SR <= 0;
            CAUSE <= 0;
            EPC <= 0;
        end 
        else begin
            `IP <= HWint_in;     // 每个周期都更新IP（是否存在外部中断）
            if(int_req) begin    // 中断响应
                `EXL <= 1'b1;
                `BD <= BD_in;
                `ExcCode <= hw_int ? 5'd0 : ExcCode_in;
                EPC <= (BD_in) ? VPC - 4 : VPC;
            end  
            else if(en) begin    // mtc0
                if(CP0A == 12) begin
                    `IM <= CP0_in[15:10];
                    `EXL <= CP0_in[1];
                    `IE <= CP0_in[0];
                end
                else if(CP0A == 14) begin
                    EPC <= CP0_in;  
                end
            end
            else if(EXL_reset) `EXL <= 1'b0;  // eret
        end
    end

    assign CP0_out = (CP0A == 12) ? SR :
                     (CP0A == 13) ? CAUSE : 
                     (CP0A == 14) ? EPC : 0;

    assign EPC_out = EPC;
endmodule