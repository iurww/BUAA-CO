module gray (
    input Clk,
    input Reset,
    input En,
    output [2:0] Output,
    output Overflow
);
    reg [2:0] status;
    reg f;

    assign Output = status;
    assign Overflow = f;

    initial begin
        status = 3'b000;
        f = 1'b0;
    end

    always @(posedge Clk) begin
        if(Reset) begin
            status = 3'b000;
            f = 1'b0;
        end
        else if(En) begin
            case(status)
                3'b000: begin
                    status <= 3'b001;
                end
                3'b001: begin
                    status <= 3'b011;
                end
                3'b011: begin
                    status <= 3'b010;
                end
                3'b010: begin
                    status <= 3'b110;
                end
                3'b110: begin
                    status <= 3'b111;
                end
                3'b111: begin
                    status <= 3'b101;
                end
                3'b101: begin
                    status <= 3'b100;
                end
                3'b100: begin
                    status <= 3'b000;
                    f <= 1'b1;
                end
                default: begin
                    status <= status;
                end
            endcase
        end
    end


endmodule