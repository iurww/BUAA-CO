module M_DMR (
    input [31:0] DM_temp,
    input [31:0] addr,
    input [2:0] DMRop,
    output [31:0] DM_out
);
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

    assign DM_out = (DMRop == 0) ? DM_temp :
                    (DMRop == 1) ? lh : 
                    (DMRop == 2) ? lb : 
                    (DMRop == 3) ? lhu : 
                    (DMRop == 4) ? lbu : 0;
    
endmodule