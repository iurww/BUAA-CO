module E_REG (
    input clk,                      // 时钟信号
    input reset,                    // 同步复位信号
    input int_req,                  // 中断信号
    input stall,                    // 阻塞信号

    input [31:0] instr_in,          // D级指令
    input [31:0] PC_in,             // D级PC
    input [31:0] rs_data_in,        // D级rs寄存器值
    input [31:0] rt_data_in,        // D级rt寄存器值
    input [31:0] EXT_in,            // D级EXT输出
    input BD_in,                    // D级指令是否为延迟槽指令
    input [4:0] ExcCode_in,         // D级指令异常码

    output reg [31:0] instr_out,    // E级指令
    output reg [31:0] PC_out,       // E级PC
    output reg [31:0] rs_data_out,  // E级rs寄存器值
    output reg [31:0] rt_data_out,  // E级rt寄存器值
    output reg [31:0] EXT_out,      // E级EXT输出
    output reg BD_out,              // E级指令是否为延迟槽指令
    output reg [4:0] ExcCode_out    // E级指令异常码
);
    always @(posedge clk) begin
        if(reset || int_req || stall) begin  //阻塞时，D级PC和BD向E级流水而不清空
            instr_out <= 0;
            PC_out <= reset ? 0 : (int_req ? 32'h0000_4180 : PC_in);
            rs_data_out <= 0;
            rt_data_out <= 0;
            EXT_out <= 0;
            BD_out <= reset ? 0 : (int_req ? 0 : BD_in);
            ExcCode_out <= 0;
        end 
        else begin
            instr_out <= instr_in;
            PC_out <= PC_in;
            rs_data_out <= rs_data_in;
            rt_data_out <= rt_data_in;
            EXT_out <= EXT_in;
            BD_out <= BD_in;
            ExcCode_out <= ExcCode_in;
        end
    end
    
endmodule