module D_CMP (
    input [31:0] rs_data,    // rs寄存器值 
    input [31:0] rt_data,    // rt寄存器值
    input [3:0] CMPop,       // 比较类型
    output reg need_b        // 是否满足分支条件
);
    always @(*) begin
        case(CMPop)
            0: begin    // beq
                need_b = (rs_data == rt_data);
            end
            1: begin    // bne
                need_b = (rs_data != rt_data);
            end 
            default: begin
                need_b = 0;
            end 

        endcase
    end

endmodule