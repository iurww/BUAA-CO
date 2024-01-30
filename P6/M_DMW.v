module M_DMW (
    input [1:0] DMWop,
    input [31:0] addr,
    input [31:0] data,
    input MWE,
    output reg [3:0] byteen,
    output reg [31:0] wdata 
);
    always @(*) begin
        if(MWE) begin
            case(DMWop)
                0: begin
                    byteen = 4'b1111;
                    wdata = data;
                end
                1: begin
                    if(addr[1:0] == 0 || addr[1:0] == 1) begin
                        byteen = 4'b0011;
                        wdata = {16'd0, data[15:0]};
                    end
                    else begin
                        byteen = 4'b1100;
                        wdata = {data[15:0], 16'd0};
                    end
                end
                2: begin
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
        else begin
            byteen = 4'b0000;
            wdata = 32'd0;
        end
    end

    
endmodule