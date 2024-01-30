module W_REG (
    input clk,
    input reset,
    input en,
    
    input [31:0] instr_in,
    input [31:0] PC_in,
    input [31:0] ALU_in,
    input [31:0] DM_in,
    input [31:0] MDU_in,

    output reg [31:0] instr_out,
    output reg [31:0] PC_out,
    output reg [31:0] ALU_out,
    output reg [31:0] DM_out,
    output reg [31:0] MDU_out
);
    always @(posedge clk) begin
        if(reset) begin
            instr_out <= 0;
            PC_out <= 0;
            ALU_out <= 0;
            DM_out <= 0;
            MDU_out <= 0;
        end 
        else if(en) begin
            instr_out <= instr_in;
            PC_out <= PC_in;
            ALU_out <= ALU_in;
            DM_out <= DM_in;
            MDU_out <= MDU_in;
        end
        else begin
            instr_out <= instr_out;
            PC_out <= PC_out;
            ALU_out <= ALU_out;
            DM_out <= DM_out;
            MDU_out <= MDU_out;
        end
    end
    
endmodule