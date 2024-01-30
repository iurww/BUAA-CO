module string2 (
    input clk,
    input clr,
    input [7:0] in,
    output out
);
    wire isdigit, isop, isl, isr;
    assign isdigit = (in >= "0" && in <= "9") ? 1 : 0;
    assign isop = (in == "+" || in == "*") ? 1 : 0;
    assign isl = (in == "(") ? 1 : 0;
    assign isr = (in == ")") ? 1 : 0;

    reg [6:0] s;
    wire [6:0] nexts;    
    assign nexts[0] = ~(isdigit | isop | isl | isr); 
    assign nexts[1] = (s[0] & isdigit) | (s[2] & isdigit) | (s[4] & isr);
    assign nexts[2] = (s[1] & isop);
    assign nexts[3] = (s[0] & isl) | (s[2] & isl);
    assign nexts[4] = (s[3] & isdigit) | (s[5] & isdigit);
    assign nexts[5] = (s[4] & isop);
    assign nexts[6] = (s[0] & (isop | isr)) | (s[1] & (isr | isdigit | isr)) |
                      (s[2] & (isop | isr)) | (s[3] & (isl | isop | isr)) |
                      (s[4] & (isl | isdigit)) | (s[5] & (isl | isop | isr)) | s[6];
                        
    initial begin
       s <= 4'b0001;
    end
    
    always @(posedge clk, posedge clr) begin
        if(clr) begin 
            s <= 4'b0001;
        end 
        else begin 
            s <= nexts;
        end    
    end
    
    assign out = (s == 7'b0000010) ? 1 : 0;
    
endmodule