module cpu_checker(
    input clk,
    input reset,
    input [7:0] char,
    input [15:0] freq,
    output [1:0] format_type,
    output [3:0] error_code
    );

    parameter YES = 1'b1;
    parameter N0 = 1'b0;
    
    reg [3:0] status;
    reg [3:0] deccnt;
    reg [3:0] hexcnt;
    reg type;      
    
    reg [15:0] tim;   
    reg [15:0] grf;  
    reg [31:0] pc;  
    reg [31:0] addr;  
    reg [3:0] error;

    wire isdec;
    wire ishex;
    wire hfreq;
    wire [7:0] todec;
    wire [7:0] tohex;

    assign isdec = (char >= "0" && char <= "9") ? 1'b1 : 1'b0; 
    assign ishex = (isdec == 1'b1) ? 1'b1 :
                 (char >= "a" && char <= "f") ? 1'b1 : 1'b0;
    assign todec = (isdec == YES) ? char - "0" : 0;
    assign tohex = (isdec == YES) ? char - "0" :
                   (ishex == YES) ? char - "a" + 10 : 0; 
    
    assign hfreq = (freq >> 1);

   
    assign format_type = (status != 4'd14) ? 2'b00 :
                         (type == 1'b0) ? 2'b01 : 2'b10; 
    assign error_code = (status == 4'd14) ? error : 4'b0000;
    //assign error_code = error;

    always @ (posedge clk) begin
        if(reset == 1'b1) begin
            status <= 4'd0;
            deccnt <= 4'd1;
            hexcnt <= 4'd1;
            type <= 1'b0;
            tim <= 16'd0;    
            grf <= 16'd0;    
            pc <= 32'd0;     
            addr <= 32'd0;   
            error <= 4'b0000;
        end
        else begin
            case(status)
                4'd0: begin
                    tim <= 16'd0;    
                    grf <= 16'd0;   
                    pc <= 32'd0;   
                    addr <= 32'd0;   
                    error <= 4'b0000;
                    if(char == "^") status <= 4'd1;
                    else status <= 4'd0;
                end
                4'd1: begin
                    grf <= 16'd0;   
                    pc <= 32'd0;   
                    addr <= 32'd0;   
                    error <= 4'b0000;
                    if(isdec == YES) begin
                        deccnt <= 4'd1;
                        status <= 4'd2;
                        tim <= (tim << 1) + (tim << 3) + todec;
                    end            
                    else if(char == "^") begin
                        tim <= 16'd0; 
                        status <= 4'd1;
                        type <= 1'b0;
                    end
                    else begin 
                        status <= 4'd0;
   
                    end
                end
                4'd2: begin
                    if(char == "@") status <= 4'd3;
                    else if(isdec == YES) begin
                        deccnt <= deccnt + 4'd1;
                        tim <= (tim << 1) + (tim << 3) + todec;
                        if(deccnt + 4'd1 > 4'd4) status <= 4'd0;                             
                        else status <= 4'd2;
                    end
                    else if(char == "^") begin
                        tim <= 16'd0; 
                    
                        status <= 4'd1;
                        type <= 1'b0;
                    end
                    else begin 
                        status <= 4'd0;
           
                    end
                end
                4'd3: begin
                    if((tim & (hfreq - 1)!=16'd0)) error <= error | 4'b0001;
                    if(ishex == YES) begin
                        hexcnt <= 4'd1;
                        status <= 4'd4;
                        pc <= (pc << 4) + tohex;
                    end
                    else if(char == "^") begin
                        tim <= 16'd0; 
              
                        status <= 4'd1;
                        type <= 1'b0;
                    end
                    else begin 
                       
                        status <= 4'd0;
         
                    end
                end
                4'd4: begin
                    if(ishex == YES) begin
                        hexcnt <= hexcnt + 4'd1;
                        pc <= (pc << 4) + tohex;
                        if(hexcnt + 4'd1 > 4'd8) status <= 4'd0;
                        else status <= 4'd4;
                    end
                    else if(char == ":") begin
                        if(hexcnt == 4'd8) status <= 4'd5;
                        else status <= 4'd0;
                    end
                    else if(char == "^") begin
                        tim <= 16'd0; 
                    
                        status <= 4'd1;
                        type <= 1'b0;
                    end
                    else begin 
                
                        status <= 4'd0;
                
                    end  
                end
                4'd5: begin
                    if(pc&2'b11 || pc<31'h0000_3000 || pc>31'h0000_4fff)
                        error <= error | 4'b0010;

                    if(char == " ") status <= 4'd5;
                    else if(char == "$") status <= 4'd6;
                    else if(char == 8'd42) status <= 4'd7;
                    else if(char == "^") begin
                        tim <= 16'd0; 
                
                        status <= 4'd1;
                        type <= 1'b0;
                    end
                    else begin 
            
                        status <= 4'd0;
                   
                    end
                end
                4'd6: begin
                    type <= 1'b0;
                    if(isdec == YES) begin
                        deccnt <= 4'd1;
                        status <= 4'd8;
                        grf <= (grf << 1) + (grf << 3) + todec;
                    end            
                    else if(char == "^") begin
                        tim <= 16'd0; 
                
                        status <= 4'd1;
                        type <= 1'b0;
                    end
                    else begin 
       
                        status <= 4'd0;
                   
                    end
                end
                4'd7: begin 
                    type <= 1'b1;
                    if(ishex == YES) begin
                        hexcnt <= 4'd1;
                        status <= 4'd9;
                        addr <= (addr << 4) + tohex;
                    end
                    else if(char == "^") begin
                        tim <= 16'd0; 
    
                        status <= 4'd1;
                        type <= 1'b0;
                    end
                    else begin 
      
                        status <= 4'd0;
    
                    end
                end
                4'd8: begin
                    if(char == " ") status <= 4'd10;
                    else if(char == "<") status <= 4'd11;
                    else if(isdec == YES) begin
                        deccnt <= deccnt + 4'd1;
                        grf <= (grf << 1) + (grf << 3) + todec;
                        if(deccnt + 4'd1 > 4'd4) status <= 4'd0;
                        else status <= 4'd8;
                    end
                    else if(char == "^") begin
                        tim <= 16'd0; 
            
                        status <= 4'd1;
            
                    end
                    else begin 
               
                        status <= 4'd0;
             
                    end
                end
                4'd9: begin 
                    if(hexcnt == 4'd8 && char == " ") status <= 4'd10;
                    else if(hexcnt == 4'd8 && char == "<") status <= 4'd11;
                    else if(ishex == YES) begin
                        hexcnt <= hexcnt + 4'd1;
                        addr <= (addr << 4) + tohex;
                        if(hexcnt + 4'd1 > 4'd8) status <= 4'd0;
                        else status <= 4'd9;
                    end
                    else if(char == "^") begin
                        tim <= 16'd0; 
                 
                        status <= 4'd1;
                        type <= 1'b0;
                    end
                    else begin 
          
                        status <= 4'd0;
            
                    end
                end
                4'd10: begin
                    if(char == " ") status <= 4'd10;
                    else if(char == "<") status<= 4'd11;
                    else if(char == "^") begin
                        tim <= 16'd0; 
       
                        status <= 4'd1;
                        type <= 1'b0;
                    end
                    else begin 
          
                        status <= 4'd0;
                     
                    end
                end
                4'd11: begin 
                    if(type==1'b0 && (grf<16'd0 || grf>16'd31))
                        error <= error | 4'b1000;
                    else if(type==1'b1 && (addr&2'b11 || addr<31'h0000_0000 || addr>31'h0000_2fff))
                        error <= error | 4'b0100;
                    if(char == "=") status <= 4'd12;
                    else if(char == "^") begin
                        tim <= 16'd0; 
              
                        status <= 4'd1;
                        type <= 1'b0;
                    end
                    else begin 
    
                        status <= 4'd0;
                
                    end
                end    
                4'd12: begin
                    if(char == " ") status <= 4'd12;
                    else if(ishex == YES) begin
                        hexcnt <= 4'd1;
                        status <= 4'd13;
                    end
                    else if(char == "^") begin
                        tim <= 16'd0; 
          
                        status <= 4'd1;
                        type <= 1'b0;
                    end
                    else begin 
     
                        status <= 4'd0;
            
                    end   
                end
                4'd13: begin
                    if(char == "#" && hexcnt == 4'd8) status <= 4'd14;
                    else if(ishex == YES) begin
                        hexcnt <= hexcnt +4'd1;
                        if(hexcnt + 4'd1 > 4'd8) status <= 4'd0;
                        else status <= 4'd13;
                    end    
                    else if(char == "^") begin
                        tim <= 16'd0; 
         
                        status <= 4'd1;
                        type <= 1'b0;
                    end
                    else begin 
      
                        status <= 4'd0;
               
                    end
                end    
                4'd14: begin
                    if(char == "^") begin
                        tim <= 16'd0; 
            
                        status <= 4'd1;
                        type <= 1'b0;
                    end
                    else begin 
         
                        status <= 4'd0;
             
                    end
                end
                default: begin 
  
                        status <= 4'd0;
                
                end

            endcase
        
        end

    end

endmodule