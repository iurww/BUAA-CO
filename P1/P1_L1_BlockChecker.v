module BlockChecker (
    input clk,
    input reset,
    input [7:0] in,
    output result
);
    wire isspace, isalpha;
    wire [7:0] lower;
    assign isspace = (in == " ");
    assign isalpha = ((in >= "a" && in <= "z") || (in >= "A" && in <= "Z")) ? 1 : 0;
    assign lower = (in >= "A" && in <= "Z") ? in - "A" + "a" : in;
    
    reg [6:0] bs; wire [6:0] nextbs;
    assign nextbs[0] = ~(isalpha | isspace);
    assign nextbs[1] = bs[0] & (lower == "b");
    assign nextbs[2] = bs[1] & (lower == "e");
    assign nextbs[3] = bs[2] & (lower == "g");
    assign nextbs[4] = bs[3] & (lower == "i");
    assign nextbs[5] = bs[4] & (lower == "n");
    assign nextbs[6] = bs[6] | (bs[0] & (lower != "b")) | (bs[1] & (lower != "e")) |
                      (bs[2] & (lower != "g")) | (bs[3] & (lower != "i")) |
                      (bs[4] & (lower != "n")) | bs[5]; 

    reg [4:0] es; wire [4:0] nextes;
    assign nextes[0] = ~(isalpha | isspace);
    assign nextes[1] = es[0] & (lower == "e");
    assign nextes[2] = es[1] & (lower == "n");
    assign nextes[3] = es[2] & (lower == "d");
    assign nextes[4] = es[4] | (es[0] & (lower != "e")) | (es[1] & (lower != "n")) |
                      (es[2] & (lower != "d")) | es[3];
    
    reg [1:0] s;
    reg [31:0] cnt;
    assign result = (s == 2) ? 0 : 
                    (cnt == 0) ? 1 : 0;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            s <= 2'b00;
            bs <= 7'b0000001;
            es <= 5'b00001;
            cnt <= 32'd0;
        end
        else begin 
            case(s)
                0: begin
                    if(isalpha) begin
                        bs <= nextbs;
                        es <= nextes;
                        s <= 1;
                    end
                    else begin
                        s <= 0;
                        bs <= 7'b0000001;
                        es <= 5'b00001;
                    end
                end
                1: begin                    
                    if(isalpha) begin
						s <= 1;
                        bs <= nextbs;
                        es <= nextes;
                        if(bs == 7'b0010000 && lower == "n") cnt <= cnt + 1;
                        else if(bs == 7'b0100000) cnt <= cnt - 1;
                        else if(es == 5'b00100 && lower == "d") cnt <= cnt - 1;
                        else if(es == 5'b01000) cnt <= cnt + 1;              
                    end
                    else begin
						bs <= 7'b0000001;
                        es <= 5'b00001;
						if(cnt == -1 && es == 5'b01000) s <= 2;
						else s <= 0;     
                    end
                end
                2: begin 
                    s <= 2;
                end
                
            endcase

        end    
        
    end

endmodule