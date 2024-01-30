module cpu_checker(
    input clk,
    input reset,
    input [7:0] char,
    output [1:0] format_type
    );

    parameter YES = 1'b1;
    parameter N0 = 1'b0;
    
    reg [3:0] status;
    reg [3:0] deccnt;
    reg [3:0] hexcnt;
    reg type;      
    wire isdec;
    wire ishex;

    assign isdec = (char >= "0" && char <= "9") ? 1'b1 : 1'b0; 
    assign ishex = (isdec == 1'b1) ? 1'b1 :
                 (char >= "a" && char <= "f") ? 1'b1 : 1'b0;
    
   
    assign format_type = (status != 4'd14) ? 2'b00 :
                         (type == 1'b0) ? 2'b01 : 2'b10; 
    

    always @ (posedge clk) begin
        if(reset == 1'b1) begin
            status <= 4'd0;
            deccnt <= 4'd1;
            hexcnt <= 4'd1;
            type <= 1'b0;
        end
        else begin
            case(status)
                4'd0: begin
                    if(char == "^") status <= 4'd1;
                    else status <= 4'd0;
                end
                4'd1: begin
                    if(isdec == YES) begin
                        deccnt <= 4'd1;
                        status <= 4'd2;
                    end            
                    else if(char == "^") status <= 4'd1;
                    else status <= 4'd0;
                end
                4'd2: begin
                    if(char == "@") status <= 4'd3;
                    else if(isdec == YES) begin
                        deccnt <= deccnt + 4'd1;
                        if(deccnt + 4'd1 > 4'd4) status <= 4'd0;
                        else status <= 4'd2;
                    end
                    else if(char == "^") status <= 4'd1;
                    else status <= 4'd0;
                end
                4'd3: begin
                    if(ishex == YES) begin
                        hexcnt <= 4'd1;
                        status <= 4'd4;
                    end
                    else if(char == "^") status <= 4'd1;
                    else status <= 4'd0;
                end
                4'd4: begin
                    if(ishex == YES) begin
                        hexcnt <= hexcnt + 4'd1;
                        if(hexcnt + 4'd1 > 4'd8) status <= 4'd0;
                        else status <= 4'd4;
                    end
                    else if(char == ":") begin
                        if(hexcnt == 4'd8) status <= 4'd5;
                        else status <= 4'd0;
                    end
                    else if(char == "^") status <= 4'd1;
                    else status <= 4'd0;   
                end
                4'd5: begin
                    if(char == " ") status <= 4'd5;
                    else if(char == "$") status <= 4'd6;
                    else if(char == "*") status <= 4'd7;
                    else if(char == "^") status <= 4'd1;
                    else status <= 4'd0;
                end
                4'd6: begin
                    type <= 1'b0;
                    if(isdec == YES) begin
                        deccnt <= 4'd1;
                        status <= 4'd8;
                    end            
                    else if(char == "^") status <= 4'd1;
                    else status <= 4'd0;
                end
                4'd7: begin 
                    type <= 1'b1;
                    if(ishex == YES) begin
                        hexcnt <= 4'd1;
                        status <= 4'd9;
                    end
                    else if(char == "^") status <= 4'd1;
                    else status <= 4'd0;
                end
                4'd8: begin
                    if(char == " ") status <= 4'd10;
                    else if(char == "<") status <= 4'd11;
                    else if(isdec == YES) begin
                        deccnt <= deccnt + 4'd1;
                        if(deccnt + 4'd1 > 4'd4) status <= 4'd0;
                        else status <= 4'd8;
                    end
                    else if(char == "^") status <= 4'd1;
                    else status <= 4'd0;
                end
                4'd9: begin 
                    if(hexcnt == 4'd8 && char == " ") status <= 4'd10;
                    else if(hexcnt == 4'd8 && char == "<") status <= 4'd11;
                    else if(ishex == YES) begin
                        hexcnt <= hexcnt + 4'd1;
                        if(hexcnt + 4'd1 > 4'd8) status <= 4'd0;
                        else status <= 4'd9;
                    end
                    else if(char == "^") status <= 4'd1;
                    else status <= 4'd0;
                end
                4'd10: begin
                    if(char == " ") status <= 4'd10;
                    else if(char == "<") status<= 4'd11;
                    else if(char == "^") status <= 4'd1;
                    else status <= 4'd0;
                end
                4'd11: begin 
                    if(char == "=") status <= 4'd12;
                    else if(char == "^") status <= 4'd1;
                    else status <= 4'd0;
                end    
                4'd12: begin
                    if(char == " ") status <= 4'd12;
                    else if(ishex == YES) begin
                        hexcnt <= 4'd1;
                        status <= 4'd13;
                    end
                    else if(char == "^") status <= 4'd1;
                    else status <= 4'd0;    
                end
                4'd13: begin
                    if(char == "#" && hexcnt == 4'd8) status <= 4'd14;
                    else if(ishex == YES) begin
                        hexcnt <= hexcnt +4'd1;
                        if(hexcnt + 4'd1 > 4'd8) status <= 4'd0;
                        else status <= 4'd13;
                    end    
                    else if(char == "^") status <= 4'd1;
                    else status <= 4'd0;
                end    
                4'd14: begin
                    if(char == "^") status <= 4'd1;
                    else status <= 4'd0;
                end
                default: status <= 4'd0;

            endcase
        
        end

    end

endmodule