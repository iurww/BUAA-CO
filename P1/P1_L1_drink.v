module drink (
    input clk,
    input reset,
    input [1:0] coin,
    output reg drink,
    output reg [1:0] back
);
    reg [1:0] s;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            s <= 2'b11;
            drink <= 0;
            back <= 0;
        end 
        else begin
            case(s)
                2'b11: begin
                    drink <= 0;
                    back <= 0;
                    if(coin == 0) s <= 2'b11;
                    else if(coin == 1) s <= 2'b10;
                    else if(coin == 2) s <= 2'b01;
                    else if(coin == 3) s <= 2'b11;
                end
                2'b10: begin
                    if(coin == 0) s <= 2'b10;
                    else if(coin == 1) s <= 2'b01;
                    else if(coin == 2) s <= 2'b00;
                    else if(coin == 3) begin
                        s <= 2'b11;
                        back <= 1;
                    end
                end
                2'b01: begin
                    if(coin == 0) s <= 2'b01;
                    else if(coin == 1) s <= 2'b00;
                    else if(coin == 2) begin
                        s <= 2'b11;
                        drink <= 1;
                    end
                    else if(coin == 3) begin
                        s <= 2'b11;
                        back <= 2;
                    end
                end
                2'b00: begin
                    if(coin == 0) s <= 2'b00;
                    else if(coin == 1) begin
                        s <= 2'b11;
                        drink <= 1;
                    end
                    else if(coin == 2) begin
                        s <= 2'b11;
                        back <= 1;
                        drink <= 1;
                    end
                    else if(coin == 3) begin
                        s <= 2'b11;
                        back <= 3;
                    end
                end

            endcase
        end
    end


endmodule