module mips(
    input clk,                      // 时钟信号
    input reset,                    // 同步复位信号
    input interrupt,                // 外部中断信号
    output [31:0] macroscopic_pc,   // 宏观 PC

    output [31:0] i_inst_addr,      // IM 读取地址（PC）
    input  [31:0] i_inst_rdata,     // IM 读取数据（指令）

    output [31:0] m_data_addr,      // 外设 读/写地址
    input  [31:0] m_data_rdata,     // 外设 读取数据
    output [31:0] m_data_wdata,     // 外设 待写入数据
    output [3 :0] m_data_byteen,    // 外设 字节使能信号

    output [31:0] m_int_addr,       // 中断发生器待写入地址
    output [3 :0] m_int_byteen,     // 中断发生器字节使能信号

    output [31:0] m_inst_addr,      // M级PC

    output w_grf_we,                // GRF 写使能信号
    output [4 :0] w_grf_addr,       // GRF 待写入寄存器编号
    output [31:0] w_grf_wdata,      // GRF 待写入数据

    output [31:0] w_inst_addr       // W级PC
);

    wire IRQ0, IRQ1;    
    wire [31:0] tc0_rdata, tc1_rdata, dev_rdata;
    wire [31:0] dev_addr, dev_wdata;
    wire dm_WE, tc0_WE, tc1_WE, int_WE;
    wire [3:0] dev_byteen;

    CPU cpu (
        .clk(clk),
        .reset(reset),
        .HWint({3'b0, interrupt, IRQ1, IRQ0}),
        .macroscopic_pc(macroscopic_pc),

        .i_inst_addr(i_inst_addr),
        .i_inst_rdata(i_inst_rdata),

        .m_data_addr(dev_addr),
        .m_data_rdata(dev_rdata),
        .m_data_wdata(dev_wdata),
        .m_data_byteen(dev_byteen),

        .m_inst_addr(m_inst_addr),
        
        .w_grf_we(w_grf_we),
        .w_grf_addr(w_grf_addr),
        .w_grf_wdata(w_grf_wdata),

        .w_inst_addr(w_inst_addr)
    );
    
    assign m_int_addr = (int_WE ? 32'h0000_7f20 : 0);
    assign m_int_byteen = (int_WE ? 4'b0001 : 0);

    Bridge bridge (
        .dm_rdata(m_data_rdata),
        .dev0_rdata(tc0_rdata),
        .dev1_rdata(tc1_rdata),
        .rdata(dev_rdata),

        .addr(dev_addr),
        .dev_waddr(m_data_addr),

        .wdata(dev_wdata),
        .dev_wdata(m_data_wdata),

        .WE(|dev_byteen),
        .dm_WE(dm_WE),
        .dev0_WE(tc0_WE),
        .dev1_WE(tc1_WE),
        .int_WE(int_WE)
    );

    assign m_data_byteen = dev_byteen & {4{dm_WE}};

    TC tc0 (
        .clk(clk),
        .reset(reset),
        .Addr(m_data_addr[31:2]),
        .WE(tc0_WE),
        .Din(m_data_wdata),
        .Dout(tc0_rdata),
        .IRQ(IRQ0)
    );

    TC tc1 (
        .clk(clk),
        .reset(reset),
        .Addr(m_data_addr[31:2]),
        .WE(tc1_WE),
        .Din(m_data_wdata),
        .Dout(tc1_rdata),
        .IRQ(IRQ1)
    );


endmodule