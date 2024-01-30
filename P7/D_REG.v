module D_REG (
    input clk,                      // 时钟信号
    input reset,                    // 同步复位信号
    input int_req,                  // 中断信号
    input stall,                    // 阻塞信号

    input [31:0] instr_in,          // F级指令
    input [31:0] PC_in,             // F级PC
    input BD_in,                    // F级指令是否为延迟槽指令
    input [4:0] ExcCode_in,         // F级指令异常码

    output reg [31:0] instr_out,    // D级指令 
    output reg [31:0] PC_out,       // D级PC
    output reg BD_out,              // D级指令是否为延迟槽指令
    output reg [4:0] ExcCode_out    // D级指令异常码 
);

    always @(posedge clk) begin
        if(reset || int_req) begin
            instr_out <= 0;
            PC_out <= int_req ? 32'h0000_4180 : 0; 
            BD_out <= 0;
            ExcCode_out <= 0;
        end
        else if(!stall) begin
            instr_out <= instr_in;
            PC_out <= PC_in;
            BD_out <= BD_in;
            ExcCode_out <= ExcCode_in;
        end 
    end    
endmodule