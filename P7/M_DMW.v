module M_DMW (
    input [2:0] DMWop,        // 写入字长类型
    input [31:0] addr,        // 写入地址
    input [31:0] data,        // 待写入原始数据
    output reg [3:0] byteen,  // 字节使能信号
    output reg [31:0] wdata,  // 预处理后的待写入数据
    
    output AdES
);
    wire dm_addr = (addr>=32'h0000_0000 && addr<=32'h0000_2fff);
    wire t0_addr = (addr>=32'h0000_7f00 && addr<=32'h0000_7f0b);
    wire t1_addr = (addr>=32'h0000_7f10 && addr<=32'h0000_7f1b);
    wire t0_count_addr = (addr>=32'h0000_7f08 && addr<=32'h0000_7f0b);
    wire t1_count_addr = (addr>=32'h0000_7f18 && addr<=32'h0000_7f1b);
    wire int_addr = (addr>=32'h0000_7f20 && addr<=32'h0000_7f23);

    assign AdES = (DMWop == 1 && addr[1:0]) ? 1 :  //sw未对齐
                  (DMWop == 2 && addr[0]) ? 1 :    //sh未对齐
                  ((DMWop == 2 || DMWop == 3) && (t0_addr || t1_addr)) ? 1 :  //sh,sb写timer寄存器
                  (DMWop && (t0_count_addr || t1_count_addr)) ? 1 :           //写timer的count寄存器
                  (DMWop && !(dm_addr || t0_addr || t1_addr || int_addr)) ? 1 : 0;  //非法地址

    always @(*) begin
        case(DMWop)
            1: begin
                byteen = 4'b1111;
                wdata = data;
            end
            2: begin
                if(addr[1:0] == 0 || addr[1:0] == 1) begin
                    byteen = 4'b0011;
                    wdata = {16'd0, data[15:0]};
                end
                else begin
                    byteen = 4'b1100;
                    wdata = {data[15:0], 16'd0};
                end
            end
            3: begin
                if(addr[1:0] == 0) begin
                    byteen = 4'b0001;
                    wdata = {24'd0, data[7:0]};
                end
                else if(addr[1:0] == 1) begin
                    byteen = 4'b0010;
                    wdata = {16'd0, data[7:0], 8'd0};
                end
                else if(addr[1:0] == 2) begin
                    byteen = 4'b0100;
                    wdata = {8'd0, data[7:0], 16'd0};
                end
                else begin
                    byteen = 4'b1000; 
                    wdata = {data[7:0], 24'h0};
                end
            end
            default: begin
                byteen = 4'b0000;
                wdata = 32'd0;
            end
        endcase
    end

    
endmodule