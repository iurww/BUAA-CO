module E_MDU (
    input clk,
    input reset,

    input [31:0] A,
    input [31:0] B,
    input [3:0] MDUop,

    output busy,
    output [31:0] MDUresult
);

    reg [31:0] hi_temp, lo_temp, hi, lo;
    reg [3:0] status;
    
    //1 mult,2 multu,3 div,4 divu,5 mfhi,6 mflo,7 mthi,8 mtlo
    //wire start = (MDUop > 0 && MDUop < 5);

    assign busy = (status != 0);
    assign MDUresult = (MDUop == 5) ? hi :
                       (MDUop == 6) ? lo : 0;

    always @(posedge clk) begin
        if(reset) begin
            status <= 0;
            hi_temp <= 0;
            lo_temp <= 0;
            hi <= 0;
            lo <= 0; 
        end
        else begin
            if(status == 0) begin
                if(MDUop == 1) begin
                    {hi_temp, lo_temp} <= $signed(A) * $signed(B);
                    status <= 5;
                end
                else if(MDUop == 2) begin
                    {hi_temp, lo_temp} <= A * B;
                    status <= 5;
                end
                else if(MDUop == 3) begin
                    hi_temp <= $signed(A) % $signed(B);
                    lo_temp <= $signed(A) / $signed(B);
                    status <= 10;
                end
                else if(MDUop == 4) begin
                    hi_temp <= A % B;
                    lo_temp <= A / B;
                    status <= 10;
                end
                else if(MDUop == 7) begin
                    hi <= A;
                end
                else if(MDUop == 8) begin
                    lo <= A;
                end
                else if(MDUop == 9) begin
                    {hi_temp, lo_temp} <= $signed({hi, lo}) + $signed(A) * $signed(B);
                    status <= 5;
                end
                else if(MDUop == 10) begin
                    {hi_temp, lo_temp} <= {hi, lo} + A * B;
                    status <= 5;
                end
                else if(MDUop == 11) begin
                    {hi_temp, lo_temp} <= $signed({hi, lo}) - $signed(A) * $signed(B);
                    status <= 5;
                end
                else if(MDUop == 12) begin
                    {hi_temp, lo_temp} <= {hi, lo} - A * B;
                    status <= 5;
                end
            end
            else if(status == 1) begin
                hi <= hi_temp;
                lo <= lo_temp;
                status <= status - 1;
            end
            else status <= status - 1;
        end
    end
    
    
endmodule