module Bridge (
    input  [31:0] dm_rdata,      // 从DM读出的数据
    input  [31:0] dev0_rdata,    // 从tc0读出的数据
    input  [31:0] dev1_rdata,    // 从tc1读出的数据
    output [31:0] rdata,         // addr地址对应的数据
  
    input  [31:0] addr,          // 读/写的地址
    output [31:0] dev_waddr,     // 写地址

    input  [31:0] wdata,         // 待写入设备的数据
    output [31:0] dev_wdata,     // 写数据
    
    input  WE,                   // 写使能信号
    output dm_WE,                // 写DM使能信号
    output dev0_WE,              // 写tc0使能信号
    output dev1_WE,              // 写tc1使能信号
    output int_WE                // 写中断发生器使能信号
);
    wire dm_addr = (addr>=32'h0000_0000 && addr<=32'h0000_2fff);
    wire t0_addr = (addr>=32'h0000_7f00 && addr<=32'h0000_7f0b);
    wire t1_addr = (addr>=32'h0000_7f10 && addr<=32'h0000_7f1b);
    wire int_addr = (addr>=32'h0000_7f20 && addr<=32'h0000_7f23);

    assign rdata = (dm_addr) ? dm_rdata :
                   (t0_addr) ? dev0_rdata :
                   (t1_addr) ? dev1_rdata : 0;

    assign dev_waddr = addr;

    assign dev_wdata = wdata;

    assign dm_WE = WE && dm_addr;
    assign dev0_WE = WE && t0_addr;
    assign dev1_WE = WE && t1_addr;
    assign int_WE = WE && int_addr;

endmodule