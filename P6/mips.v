module mips (
    input clk,
    input reset,
    
    input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
    
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3 :0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
);
    wire stall, busy;
    wire [31:0] F_instr, D_instr, E_instr, M_instr, W_instr;
    wire [31:0] F_PC, D_PC, E_PC, M_PC, W_PC;

    wire [4:0] D_rs, D_rt;
    wire [15:0] D_imm16;
    wire [25:0] D_imm26;
    wire D_EXTop, D_need_b; 
    wire [2:0] D_NPCop; 
    wire [3:0] D_CMPop; 
    wire [31:0] D_RD1, D_RD2, D_EXT_out, D_rs_data, D_rt_data, D_NPC;

    wire [4:0] E_shamt, E_RWA, E_rs, E_rt;
    wire E_RWE, E_ALUBsel;
    wire [3:0] E_ALUop, E_MDUop;
    wire [1:0] E_RWDsel;
    wire [31:0] E_EXT_out, E_rs_data, E_rt_data, E_rs_ndata, E_rt_ndata, E_ALU_out, E_MDU_out;

    wire M_MWE;
    wire [2:0] M_DMRop;
    wire [1:0] M_DMWop, M_RWDsel;
    wire [4:0] M_RWA, M_rt;
    wire [3:0] M_byteen;
    wire [31:0] M_rt_data, M_MWD, M_ALU_out, M_DM_out, M_MDU_out;

    wire W_RWE;
    wire [4:0] W_RWA;
    wire [1:0] W_RWDsel;
    wire [31:0] W_ALU_out, W_DM_out, W_MDU_out;

    wire [31:0] E_FD, M_FD, W_FD;

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
        .en(!stall), 
        .NPC(D_NPC), //
        .PC(F_PC)
    );

    assign i_inst_addr = F_PC;
//******************************


//****************************** Stage D
    D_REG D_reg (
        .clk(clk), 
        .reset(reset), 
        .en(!stall), 
        .instr_in(i_inst_rdata), 
        .PC_in(F_PC), 
        .instr_out(D_instr), 
        .PC_out(D_PC)
    );

    CU D_cu (
        .instr(D_instr), 
        .rs(D_rs), 
        .rt(D_rt), 
        .imm16(D_imm16), 
        .imm26(D_imm26), 
        .EXTop(D_EXTop), 
        .NPCop(D_NPCop), 
        .CMPop(D_CMPop)
    );
    
    D_GRF D_grf (
        .clk(clk), 
        .reset(reset), 
        .RWE(W_RWE), //
        .A1(D_rs), 
        .A2(D_rt), 
        .RWA(W_RWA), //
        .RWD(W_FD), //
        .RD1(D_RD1), 
        .RD2(D_RD2)  
    );

    assign w_grf_we = W_RWE;
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
        .imm26(D_imm26), 
        .rs_data(D_rs_data), 
        .need_b(D_need_b), 
        .NPCop(D_NPCop), 
        .NPC(D_NPC)
    );
//******************************


//****************************** Stage E
    E_REG E_reg (
        .clk(clk), 
        .reset(reset || stall), 
        .en(1'b1), 

        .instr_in(D_instr), 
        .PC_in(D_PC), 
        .rs_data_in(D_rs_data), 
        .rt_data_in(D_rt_data), 
        .EXT_in(D_EXT_out), 

        .instr_out(E_instr), 
        .PC_out(E_PC), 
        .rs_data_out(E_rs_data), 
        .rt_data_out(E_rt_data), 
        .EXT_out(E_EXT_out)
    );

    CU E_cu (
        .instr(E_instr), 
        .shamt(E_shamt), 
        .rs(E_rs),
        .rt(E_rt),
        .RWE(E_RWE), 
        .ALUop(E_ALUop), 
        .MDUop(E_MDUop),
        .RWAsel(E_RWA), 
        .RWDsel(E_RWDsel), 
        .ALUBsel(E_ALUBsel)
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
        .ALUresult(E_ALU_out)
    );

    E_MDU E_mdu (
        .clk(clk),
        .reset(reset),
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
        .en(1'b1), 

        .instr_in(E_instr), 
        .PC_in(E_PC), 
        .rt_data_in(E_rt_ndata), 
        .ALU_in(E_ALU_out), 
        .MDU_in(E_MDU_out),

        .instr_out(M_instr), 
        .PC_out(M_PC), 
        .rt_data_out(M_rt_data), 
        .ALU_out(M_ALU_out),
        .MDU_out(M_MDU_out)
    );

    CU M_cu (
        .instr(M_instr), 
        .rt(M_rt),
        .MWE(M_MWE), 
        .DMRop(M_DMRop), 
        .DMWop(M_DMWop), 
        .RWAsel(M_RWA), 
        .RWDsel(M_RWDsel)
    );

    assign M_MWD = (M_rt == 0) ? 0 :
                   (M_rt == W_RWA) ? W_FD : M_rt_data;

    M_DMW M_dmw (
        .DMWop(M_DMWop),
        .addr(M_ALU_out),
        .data(M_MWD),
        .MWE(M_MWE),
        .byteen(M_byteen),
        .wdata(m_data_wdata)
    );

    assign m_data_addr = M_ALU_out;
    //assign m_data_wdata = M_MWD;
    assign m_data_byteen = M_byteen;
    assign m_inst_addr = M_PC;

    M_DMR M_dmr (
        .DM_temp(m_data_rdata),
        .addr(M_ALU_out),
        .DMRop(M_DMRop),
        .DM_out(M_DM_out)
    );

    assign M_FD = (M_RWDsel == 0) ? M_ALU_out :
                  (M_RWDsel == 2) ? M_PC + 8 : 
                  (M_RWDsel == 3) ? M_MDU_out : 0;

//******************************


//****************************** Stage W
    W_REG W_reg (
        .clk(clk), 
        .reset(reset), 
        .en(1'b1), 

        .instr_in(M_instr), 
        .PC_in(M_PC), 
        .ALU_in(M_ALU_out), 
        .DM_in(M_DM_out), 
        .MDU_in(M_MDU_out),

        .instr_out(W_instr), 
        .PC_out(W_PC), 
        .ALU_out(W_ALU_out), 
        .DM_out(W_DM_out),
        .MDU_out(W_MDU_out)
    );

    CU W_cu (
        .instr(W_instr), 
        .RWE(W_RWE), 
        .RWAsel(W_RWA), 
        .RWDsel(W_RWDsel)
    );

    assign W_FD = (W_RWDsel == 0) ? W_ALU_out :
                  (W_RWDsel == 1) ? W_DM_out :
                  (W_RWDsel == 2) ? W_PC + 8 : 
                  (W_RWDsel == 3) ? W_MDU_out : 0;

//******************************
    
endmodule