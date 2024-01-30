module M_DMR (
    input [31:0] DM_temp,     // 读取的原始外设数据
    input [31:0] addr,        // 地址
    input [2:0] DMRop,        // 读出字长类型
    output [31:0] DM_out,     // 经字长控制的原始数据

    output AdEL               // M级是否存在AdEL异常
);
    wire dm_addr = (addr>=32'h0000_0000 && addr<=32'h0000_2fff);
    wire t0_addr = (addr>=32'h0000_7f00 && addr<=32'h0000_7f0b);
    wire t1_addr = (addr>=32'h0000_7f10 && addr<=32'h0000_7f1b);
    wire int_addr = (addr>=32'h0000_7f20 && addr<=32'h0000_7f23);

    assign AdEL = (DMRop == 1 && addr[1:0]) ? 1 :  //lw未对齐
                  (DMRop == 2 && addr[0]) ? 1 :    //lh未对齐
                  ((DMRop == 2 || DMRop == 3) && (t0_addr || t1_addr)) ? 1 :  //lh,lb取timer寄存器 
                  (DMRop && !(dm_addr || t0_addr || t1_addr || int_addr)) ? 1 : 0;  //非法地址


    wire [31:0] lh, lb, lhu, lbu;    

    assign lh = (addr[1:0] < 2) ? {{16{DM_temp[15]}}, DM_temp[15:0]}
                                : {{16{DM_temp[31]}}, DM_temp[31:16]};

    assign lhu = (addr[1:0] < 2) ? {16'h0000, DM_temp[15:0]}
                                 : {16'h0000, DM_temp[31:16]};
    
    assign lb = (addr[1:0] == 0) ? {{24{DM_temp[7]}}, DM_temp[7:0]} :
                (addr[1:0] == 1) ? {{24{DM_temp[15]}}, DM_temp[15:8]} :
                (addr[1:0] == 2) ? {{24{DM_temp[23]}}, DM_temp[23:16]}
                                 : {{24{DM_temp[31]}}, DM_temp[31:24]} ;
    
    assign lbu = (addr[1:0] == 0) ? {24'h0000_00, DM_temp[7:0]} :
                 (addr[1:0] == 1) ? {24'h0000_00, DM_temp[15:8]} :
                 (addr[1:0] == 2) ? {24'h0000_00, DM_temp[23:16]}
                                  : {24'h0000_00, DM_temp[31:24]} ;

    assign DM_out = (DMRop == 1) ? DM_temp :
                    (DMRop == 2) ? lh : 
                    (DMRop == 3) ? lb : 
                    (DMRop == 4) ? lhu : 
                    (DMRop == 5) ? lbu : 0;
    
endmodule