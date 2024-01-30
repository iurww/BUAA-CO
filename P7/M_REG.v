module M_REG (
    input clk,                      // 时钟信号
    input reset,                    // 同步复位信号
    input int_req,                  // 中断信号
    input stall,                    // 阻塞信号
    
    input [31:0] instr_in,          // E级指令
    input [31:0] PC_in,             // E级PC
    input [31:0] rt_data_in,        // E级rt寄存器值
    input [31:0] ALU_in,            // E级ALU输出
    input [31:0] MDU_in,            // E级MDU输出
    input BD_in,                    // E级指令是否为延迟槽指令
    input [4:0] ExcCode_in,         // E级指令异常码

    output reg [31:0] instr_out,    // M级指令
    output reg [31:0] PC_out,       // M级PC
    output reg [31:0] rt_data_out,  // M级rt寄存器值
    output reg [31:0] ALU_out,      // M级ALU输出
    output reg [31:0] MDU_out,      // M级MDU输出
    output reg BD_out,              // M级指令是否为延迟槽指令
    output reg [4:0] ExcCode_out    // M级指令异常码
);
    always @(posedge clk) begin
        if(reset || int_req) begin
            instr_out <= 0;
            PC_out <= int_req ? 32'h0000_4180 : 0;
            rt_data_out <= 0;
            ALU_out <= 0;
            MDU_out <= 0;
            BD_out <= 0;
            ExcCode_out <= 0;
        end 
        else begin
            instr_out <= instr_in;
            PC_out <= PC_in;
            rt_data_out <= rt_data_in;
            ALU_out <= ALU_in;
            MDU_out <= MDU_in;
            BD_out <= BD_in;
            ExcCode_out <= ExcCode_in;
        end
    end
    
endmodule