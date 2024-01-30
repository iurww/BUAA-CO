module SU (
    input [31:0] D_instr,     // D级指令
    input [31:0] E_instr,     // E级指令
    input [31:0] M_instr,     // M级指令
    input busy,               // 乘除单元是否处于busy状态
    output stall              // 是否阻塞
);
    wire D_cal_r, D_cal_i, D_load, D_store, D_branch, D_jump_i, D_jump_r;
    wire D_mdc, D_mdf, D_mdt;
    wire D_mtc0, D_eret;
    wire [4:0] D_rs, D_rt;
    CU D_cu (
        .instr(D_instr),
        .rs(D_rs),
        .rt(D_rt),
        .cal_r(D_cal_r),
        .cal_i(D_cal_i),
        .load(D_load),
        .store(D_store),
        .branch(D_branch),
        .jump_i(D_jump_i),
        .jump_r(D_jump_r),
        .mdc(D_mdc),
        .mdf(D_mdf),
        .mdt(D_mdt),
        .mtc0(D_mtc0),
        .eret(D_eret)
    );
    wire [2:0] Tuse_rs, Tuse_rt;
    assign Tuse_rs = (D_branch || D_jump_r) ? 0 :
                     (D_cal_r || D_cal_i || D_load || D_store || D_mdc || D_mdt) ? 1 : 3;
    assign Tuse_rt = (D_branch) ? 0 :
                     (D_cal_r || D_mdc) ? 1 :
                     (D_store || D_mtc0) ? 2 : 3;


    wire E_cal_r, E_cal_i, E_load;
    wire E_mdc, E_mdf;
    wire E_mfc0, E_mtc0;
    wire [4:0] E_RWA, E_rd;
    CU E_cu (
        .instr(E_instr),
        .rd(E_rd),
        .cal_r(E_cal_r),
        .cal_i(E_cal_i),
        .load(E_load),
        .RWAsel(E_RWA),
        .mdc(E_mdc),
        .mdf(E_mdf),
        .mfc0(E_mfc0),
        .mtc0(E_mtc0)
    );
    wire [2:0] Tnew_E;
    assign Tnew_E = (E_cal_r || E_cal_i || E_mdf) ? 1 :
                    (E_load || E_mfc0) ? 2 : 0;


    wire M_load;
    wire M_mfc0, M_mtc0;
    wire [4:0] M_RWA, M_rd;
    CU M_cu (
        .instr(M_instr),
        .rd(M_rd),
        .load(M_load),
        .RWAsel(M_RWA),
        .mfc0(M_mfc0),
        .mtc0(M_mtc0)
    );
    wire [2:0] Tnew_M;
    assign Tnew_M = (M_load || M_mfc0) ? 1 : 0;


    wire stall_rs_E = (Tuse_rs < Tnew_E) && (D_rs == E_RWA) && D_rs;
    wire stall_rs_M = (Tuse_rs < Tnew_M) && (D_rs == M_RWA) && D_rs;
    wire stall_rt_E = (Tuse_rt < Tnew_E) && (D_rt == E_RWA) && D_rt;
    wire stall_rt_M = (Tuse_rt < Tnew_M) && (D_rt == M_RWA) && D_rt;
    wire stall_md = (D_mdc || D_mdf || D_mdt) && (E_mdc || busy);
    wire stall_eret = D_eret && ((E_mtc0 && (E_rd == 14)) || (M_mtc0 && (M_rd == 14))); 

    assign stall = stall_rs_E || stall_rs_M ||
                   stall_rt_E || stall_rt_M ||
                   stall_md || stall_eret;
    
endmodule