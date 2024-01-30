module W_REG (
    input clk,                      // 时钟信号
    input reset,                    // 同步复位信号
    input int_req,                  // 中断信号
    input stall,                    // 阻塞信号
    
    input [31:0] instr_in,          // M级指令
    input [31:0] PC_in,             // M级PC
    input [31:0] ALU_in,            // M级ALU输出
    input [31:0] DM_in,             // M级DM输出
    input [31:0] MDU_in,            // M级MDU输出
    input [31:0] CP0_in,            // M级CP0输出

    output reg [31:0] instr_out,    // W级指令
    output reg [31:0] PC_out,       // W级PC
    output reg [31:0] ALU_out,      // W级ALU输出
    output reg [31:0] DM_out,       // W级DM输出
    output reg [31:0] MDU_out,      // W级MDU输出
    output reg [31:0] CP0_out       // W级CP0输出
);
    always @(posedge clk) begin
        if(reset || int_req) begin
            instr_out <= 0;
            PC_out <= int_req ? 32'h0000_4180 : 0;
            ALU_out <= 0;
            DM_out <= 0;
            MDU_out <= 0;
            CP0_out <= 0;
        end 
        else begin
            instr_out <= instr_in;
            PC_out <= PC_in;
            ALU_out <= ALU_in;
            DM_out <= DM_in;
            MDU_out <= MDU_in;
            CP0_out <= CP0_in;
        end
    end
    
endmodule