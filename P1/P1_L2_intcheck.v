module intcheck (
    input clk,
    input reset,
    input [7:0] in,
    output out
);
    wire isdigit, isvalid, isspace;
    assign isdigit = (in >= "0" && in <= "9") ? 1 : 0;
    assign isvalid = (in >= "0" && in <= "9") ? 1 : 
                     (in >= "a" && in <= "z") ? 1 :
                     (in >= "A" && in <= "Z") ? 1 :
                     (in == 8'd95) ? 1 : 0;
    assign isspace = (in == 8'd9 || in == 8'd32 || in == 8'd0);
    
    reg [4:0] sint;   wire [4:0] nextsint;
    assign nextsint[0] = ~isvalid;
    assign nextsint[1] = sint[0] & (in == "i");
    assign nextsint[2] = sint[1] & (in == "n");
    assign nextsint[3] = sint[2] & (in == "t");   
    assign nextsint[4] = sint[4] | (sint[0] & in != "i") | (sint[1] & in != "n") |
                         (sint[2] & in != "t") | sint[3];
    
    reg [3:0] s; 
    assign out = (s == 8) ? 1 : 0;

    always @(posedge clk) begin
        if(reset) begin
            s <= 0;
            sint <= 4'b0001;
        end
        else begin
            case(s)
                0: begin
                    if(in == "i") s <= 1;
                    else if(isspace || in == ";") s <= 0;
                    else s <= 9;
                end
                1: begin
                    if(in == "n") s <= 2;
                    else if(in == ";") s <= 0;
                    else s <= 9;  
                end
                2: begin
                    if(in == "t") s <= 3;
                    else if(in == ";") s <= 0;
                    else s <= 9;  
                end
                3: begin
                    sint <= 5'b00001;
                    if(in == " ") s <= 4;
                    else if(in == ";") s <= 0;
                    else s <= 9;  
                end
                4: begin
                    if(!isdigit && isvalid) begin
                        sint <= nextsint;
                        s <= 5;
                    end
                    else if(isspace) begin
                        sint <= 5'b00001;
                        s <= 4;
                    end
                    else if(in == ";") s <= 0;
                    else s <= 9;  
                end
                5: begin
                    if(isvalid) begin
                        sint <= nextsint;
                        s <= 5;
                    end
                    else if(isspace) begin
                        if(sint == 5'b01000) begin
                            sint <= 5'b00001;
                            s <= 9;
                        end
                        else s <= 6;
                    end
                    else if(in == ",") begin
                        if(sint == 5'b01000) s <= 9;
                        else 
                            begin sint <= 5'b00001; s <= 7; end
                    end
                    else if(in == ";") begin
                        if(sint != 5'b01000) s <= 8; 
                        else s <= 0;
                    end
                    else s <= 9;
                end
                6: begin
                    if(isspace) s <= 6;
                    else if(in == ",") begin
                        if(sint == 5'b01000) s <= 9;
                        else 
                            begin sint <= 5'b00001; s <= 7; end
                    end
                    else if(in == ";") begin
                        if(sint != 5'b01000) s <= 8; 
                        else s <= 0;
                    end
                    else s <= 9;
                end 
                7: begin
                    if(isspace) begin
                        sint <= 5'b00001;
                        s <= 4;
                    end
                    else if(!isdigit && isvalid) begin
                        sint <= nextsint;
                        s <= 5;
                    end
                    else if(in == ";") s <= 0;
                    else s <= 9;
                end 
                8: begin
                    if(in == "i") s <= 1;
                    else if(isspace) s <= 0;
                    else if(in == ";") s <= 0;
                    else s <= 9;
                end
                9: begin
                    if(in == ";") s <= 0;
                    else s <= 9;
                end
            endcase
        end 
    end
    
endmodule