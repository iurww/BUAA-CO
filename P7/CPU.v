module CPU (
    input clk,                      // 时钟信号
    input reset,                    // 同步复位信号
    input [5:0] HWint,              // 外部中断信号
    output [31:0] macroscopic_pc,   // 宏观PC

    output [31:0] i_inst_addr,      // IM 读取地址（PC）
    input  [31:0] i_inst_rdata,     // IM 读取数据（指令）
   
    output [31:0] m_data_addr,      // 外设 读/写地址
    input  [31:0] m_data_rdata,     // 外设 读取数据
    output [31:0] m_data_wdata,     // 外设 待写入数据
    output [3 :0] m_data_byteen,    // 外设 写字节使能信号

    output [31:0] m_inst_addr,      // M级PC
    
    output w_grf_we,                // GRF 写使能信号
    output [4 :0] w_grf_addr,       // GRF 待写入寄存器编号
    output [31:0] w_grf_wdata,      // GRF 待写入数据
    
    output [31:0] w_inst_addr       // W级PC
);
    wire stall, busy, int_req;

    wire [31:0] F_instr, D_instr, E_instr, M_instr, W_instr;
    wire [31:0] F_PC, D_PC, E_PC, M_PC, W_PC;

    wire F_AdEL;

    wire [4:0] D_rs, D_rt;
    wire [15:0] D_imm16;
    wire [25:0] D_imm26;
    wire D_EXTop, D_need_b; 
    wire [2:0] D_NPCop; 
    wire [3:0] D_CMPop; 
    wire [31:0] D_RD1, D_RD2, D_EXT_out, D_rs_data, D_rt_data, D_NPC;
    wire D_RI, D_syscall, D_eret;

    wire [4:0] E_shamt, E_RWA, E_rs, E_rt;
    wire E_RWE, E_ALUBsel;
    wire [3:0] E_ALUop, E_MDUop;
    wire [2:0] E_RWDsel;
    wire [31:0] E_EXT_out, E_rs_data, E_rt_data, E_rs_ndata, E_rt_ndata, E_ALU_out, E_MDU_out;
    wire E_check_AdEL, E_check_AdES, E_check_Ov;
    wire E_AdEL, E_AdES, E_Ov;

    wire [2:0] M_DMRop;
    wire [2:0] M_DMWop, M_RWDsel;
    wire [4:0] M_RWA, M_rt, M_rd;
    wire [3:0] M_byteen;
    wire [31:0] M_rt_data, M_rt_ndata, M_ALU_out, M_DM_out, M_MDU_out,
                M_CP0_out, EPC;
    wire M_AdEL, M_AdES;
    wire M_eret, M_mtc0;

    wire [4:0] W_RWA;
    wire [2:0] W_RWDsel;
    wire [31:0] W_ALU_out, W_DM_out, W_MDU_out, W_CP0_out;

    wire [31:0] E_FD, M_FD, W_FD;

    wire F_BD, D_BD, E_BD, M_BD;
    wire [4:0] F_ExcCode, D_ExcCode, E_ExcCode, M_ExcCode;
    wire [4:0] D_nExcCode, E_nExcCode, M_nExcCode;

//****************************** Stall Unit
    SU su (
        .D_instr(D_instr), 
        .E_instr(E_instr), 
        .M_instr(M_instr), 
        .busy(busy),
        .stall(stall)
    );
//******************************


//****************************** Stage F
    F_PC F_pc (
        .clk(clk), 
        .reset(reset), 
        .int_req(int_req),
        .stall(stall),

        .NPC(D_NPC), 
        .PC(F_PC),
        .AdEL(F_AdEL)
    );

    assign F_ExcCode = F_AdEL ? 4 : 0;

    assign i_inst_addr = (D_eret) ? EPC : F_PC;
    assign F_instr = i_inst_rdata;

//******************************


//****************************** Stage D
    D_REG D_reg (
        .clk(clk), 
        .reset(reset), 
        .int_req(int_req),
        .stall(stall),

        .instr_in((F_ExcCode != 0) ? 0 : F_instr), 
        .PC_in(i_inst_addr), 
        .BD_in(D_NPCop ? 1'b1 : 1'b0),
        .ExcCode_in(F_ExcCode),

        .instr_out(D_instr), 
        .PC_out(D_PC),
        .BD_out(D_BD),
        .ExcCode_out(D_ExcCode)
    );

    CU D_cu (
        .instr(D_instr), 
        .rs(D_rs), 
        .rt(D_rt), 
        .imm16(D_imm16), 
        .imm26(D_imm26), 

        .EXTop(D_EXTop), 
        .NPCop(D_NPCop), 
        .CMPop(D_CMPop),

        .RI(D_RI),
        .syscall(D_syscall),
        .eret(D_eret)
    );

    assign D_nExcCode = (D_ExcCode) ? D_ExcCode :
                        (D_RI) ? 10 : 
                        (D_syscall) ? 8 : 0;
    
    D_GRF D_grf (
        .clk(clk), 
        .reset(reset), 
        .A1(D_rs), 
        .A2(D_rt), 
        .RWA(W_RWA), //
        .RWD(W_FD), //
        .RD1(D_RD1), 
        .RD2(D_RD2)  
    );

    assign w_grf_we = 1'b1;
    assign w_grf_addr = W_RWA;
    assign w_grf_wdata = W_FD;

    assign w_inst_addr = W_PC;

    D_EXT D_ext (
        .imm16(D_imm16), 
        .EXTop(D_EXTop), 
        .EXTout(D_EXT_out)
    );
    
    assign D_rs_data = (D_rs == 0) ? 0 :
                       (D_rs == E_RWA) ? E_FD :
                       (D_rs == M_RWA) ? M_FD : D_RD1;
    assign D_rt_data = (D_rt == 0) ? 0 :
                       (D_rt == E_RWA) ? E_FD :
                       (D_rt == M_RWA) ? M_FD : D_RD2;

    D_CMP D_cmp (
        .rs_data(D_rs_data), 
        .rt_data(D_rt_data), 
        .CMPop(D_CMPop), 
        .need_b(D_need_b)
    );

    D_NPC D_npc (
        .F_PC(F_PC), 
        .D_PC(D_PC),
        .EPC(EPC),
        .imm26(D_imm26), 
        .rs_data(D_rs_data), 
        .need_b(D_need_b), 
        .NPCop(D_NPCop), 
        .eret(D_eret),
        .NPC(D_NPC)
    );
//******************************


//****************************** Stage E
    E_REG E_reg (
        .clk(clk), 
        .reset(reset), 
        .int_req(int_req),
        .stall(stall), 

        .instr_in((D_ExcCode != 0) ? 0 : D_instr), 
        .PC_in(D_PC), 
        .rs_data_in(D_rs_data), 
        .rt_data_in(D_rt_data), 
        .EXT_in(D_EXT_out), 
        .BD_in(D_BD),
        .ExcCode_in(D_nExcCode),

        .instr_out(E_instr), 
        .PC_out(E_PC), 
        .rs_data_out(E_rs_data), 
        .rt_data_out(E_rt_data), 
        .EXT_out(E_EXT_out),
        .BD_out(E_BD),
        .ExcCode_out(E_ExcCode)
    );

    CU E_cu (
        .instr(E_instr), 
        .shamt(E_shamt), 
        .rs(E_rs),
        .rt(E_rt),

        .ALUop(E_ALUop), 
        .MDUop(E_MDUop),
        .RWAsel(E_RWA), 
        .RWDsel(E_RWDsel), 
        .ALUBsel(E_ALUBsel),

        .check_AdEL(E_check_AdEL),
        .check_AdES(E_check_AdES),
        .check_Ov(E_check_Ov)
    );

    assign E_rs_ndata = (E_rs == 0) ? 0 :
                        (E_rs == M_RWA) ? M_FD : 
                        (E_rs == W_RWA) ? W_FD : E_rs_data;

    assign E_rt_ndata = (E_rt == 0) ? 0 :
                        (E_rt == M_RWA) ? M_FD : 
                        (E_rt == W_RWA) ? W_FD : E_rt_data;

    E_ALU E_alu (
        .A(E_rs_ndata), 
        .B((E_ALUBsel) ? E_EXT_out : E_rt_ndata), 
        .shamt(E_shamt), 
        .ALUop(E_ALUop), 
        .ALUresult(E_ALU_out),

        .check_AdEL(E_check_AdEL),
        .check_AdES(E_check_AdES),
        .check_Ov(E_check_Ov),
        .AdEL(E_AdEL),
        .AdES(E_AdES),
        .Ov(E_Ov)
    );

    assign E_nExcCode = (E_ExcCode) ? E_ExcCode :
                        (E_AdEL) ? 4 : 
                        (E_AdES) ? 5 : 
                        (E_Ov) ? 12 : 0; 

    E_MDU E_mdu (
        .clk(clk),
        .reset(reset),
        .int_req(int_req),
        .A(E_rs_ndata),
        .B(E_rt_ndata),
        .MDUop(E_MDUop),
        .busy(busy),
        .MDUresult(E_MDU_out)
    );
  

    assign E_FD = (E_RWDsel == 2) ? E_PC + 8 : 0;

//******************************


//****************************** Stage M
    M_REG M_reg (
        .clk(clk), 
        .reset(reset), 
        .int_req(int_req),
        .stall(stall), 

        .instr_in((E_ExcCode != 0) ? 0 : E_instr), 
        .PC_in(E_PC), 
        .rt_data_in(E_rt_ndata), 
        .ALU_in(E_ALU_out), 
        .MDU_in(E_MDU_out),
        .BD_in(E_BD),
        .ExcCode_in(E_nExcCode),

        .instr_out(M_instr), 
        .PC_out(M_PC), 
        .rt_data_out(M_rt_data), 
        .ALU_out(M_ALU_out),
        .MDU_out(M_MDU_out),
        .BD_out(M_BD),
        .ExcCode_out(M_ExcCode)
    );

    CU M_cu (
        .instr(M_instr), 
        .rt(M_rt),
        .rd(M_rd),
        .DMRop(M_DMRop), 
        .DMWop(M_DMWop), 
        .RWAsel(M_RWA), 
        .RWDsel(M_RWDsel),

        .eret(M_eret),
        .mtc0(M_mtc0)
    );

    assign M_rt_ndata = (M_rt == 0) ? 0 :
                        (M_rt == W_RWA) ? W_FD : M_rt_data;

    M_DMW M_dmw (
        .DMWop(M_DMWop),
        .addr(M_ALU_out),
        .data(M_rt_ndata),
        .byteen(M_byteen),
        .wdata(m_data_wdata),

        .AdES(M_AdES)
    );

    assign m_data_addr = M_ALU_out;
    //assign m_data_wdata = M_rt_ndata;
    assign m_data_byteen = (int_req) ? 4'b0000 : M_byteen;
    assign m_inst_addr = M_PC;
    assign macroscopic_pc = M_PC;

    M_DMR M_dmr (
        .DM_temp(m_data_rdata),
        .addr(M_ALU_out),
        .DMRop(M_DMRop),
        .DM_out(M_DM_out),

        .AdEL(M_AdEL)
    );

    assign M_nExcCode = (M_ExcCode) ? M_ExcCode :
                        (M_AdEL) ? 4 :
                        (M_AdES) ? 5 : 0;

    CP0 M_cp0 (
      .clk(clk),
      .reset(reset),
      .en(M_mtc0),
      .EXL_reset(M_eret),

      .CP0A(M_rd),
      .CP0_in(M_rt_ndata),
      .VPC(M_PC),
      .HWint_in(HWint),
      .BD_in(M_BD),
      .ExcCode_in(M_nExcCode),

      .CP0_out(M_CP0_out),
      .EPC_out(EPC),
      .int_req(int_req)
    );
  

    assign M_FD = (M_RWDsel == 0) ? M_ALU_out :
                  (M_RWDsel == 2) ? M_PC + 8 : 
                  (M_RWDsel == 3) ? M_MDU_out : 0;

//******************************


//****************************** Stage W
    W_REG W_reg (
        .clk(clk), 
        .reset(reset), 
        .int_req(int_req),
        .stall(stall), 

        .instr_in(M_instr), 
        .PC_in(M_PC), 
        .ALU_in(M_ALU_out), 
        .DM_in(M_DM_out), 
        .MDU_in(M_MDU_out),
        .CP0_in(M_CP0_out),

        .instr_out(W_instr), 
        .PC_out(W_PC), 
        .ALU_out(W_ALU_out), 
        .DM_out(W_DM_out),
        .MDU_out(W_MDU_out),
        .CP0_out(W_CP0_out)
    );

    CU W_cu (
        .instr(W_instr), 
        .RWAsel(W_RWA), 
        .RWDsel(W_RWDsel)
    );

    assign W_FD = (W_RWDsel == 0) ? W_ALU_out :
                  (W_RWDsel == 1) ? W_DM_out :
                  (W_RWDsel == 2) ? W_PC + 8 : 
                  (W_RWDsel == 3) ? W_MDU_out : 
                  (W_RWDsel == 4) ? W_CP0_out : 0;

//******************************
    
endmodule