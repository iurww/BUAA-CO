module expr (
    input clk,
    input clr,
    input [7:0] in,
    output out
);
    wire isdigit, isop;
    assign isdigit = (in >= "0" && in <= "9") ? 1 : 0;
    assign isop = (in == "+" || in == "*") ? 1 : 0;

    reg [3:0] s;
    wire [3:0] nexts;    
    assign nexts[0] =  ~(isdigit | isop); 
    assign nexts[1] = (s[0] & isdigit) | (s[2] & isdigit);
    assign nexts[2] = s[1] & isop;
    assign nexts[3] = s[3] | (s[1] & isdigit) | (s[2] & isop) | (s[0] & isop);

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
    
    assign out = (s == 4'b0010) ? 1 : 0;
    
endmodule