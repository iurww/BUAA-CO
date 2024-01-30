// cpu_checker.v
module cpu_check(
    input clk,
    input reset,
    input [7:0] char,
    output [1:0] format_type
    );

parameter INIT_STATUS = 4'd0;
parameter INIT_DECIMAL_REG = 3'd1;
parameter DECIMAL_TOP = 3'd4;
parameter INIT_HEX_REG = 4'd1;
parameter HEX_TOP = 4'd8;
parameter INIT_TYPE_REG = 1'b0;
parameter YES = 1'b1;
parameter NO = 1'b0;

reg [3:0] status = INIT_STATUS;             // FSM status
reg [2:0] decimalReg = INIT_DECIMAL_REG;    // Counter of the decimal number bits
reg [3:0] hexReg = INIT_HEX_REG;            // Counter of the hexadecima number bits
reg typeReg = INIT_TYPE_REG;                // Recorder of the cpu_info type, 0 for registers, 1 for memory

wire digit = (char >= "0" && char <= "9") ? YES : NO;
wire hexdigit = (digit == YES) ? YES :
                (char >= "a" && char <= "f") ? YES : NO;

assign format_type = (status != 4'd14) ? 2'b00 :
                     (typeReg == 1'b0) ? 2'b01 : 2'b10;

always @(posedge clk) begin
    if (reset == YES) begin    // If reset, reset all the registers.
        status <= INIT_STATUS;
        decimalReg <= INIT_DECIMAL_REG;
        hexReg <= INIT_HEX_REG;
        typeReg <= INIT_TYPE_REG;
    end
    else begin
        case (status)
            4'd0: begin         // Status 0: reading nothing
                if (char == "^") status <= 4'd1;
                else status <= INIT_STATUS;
            end
            4'd1: begin         // Status 1: reading "^"
                if (digit == YES) begin
                    decimalReg <= INIT_DECIMAL_REG;
                    status <= 4'd2;
                end
                else if (char == "^") status <= 4'd1;
                else status <= INIT_STATUS;
            end
            4'd2: begin         // Status 2: reading decimal number time
                if (char == "@") status <= 4'd3;
                else if (digit == YES) begin
                    decimalReg <= decimalReg + 3'b1;
                    if (decimalReg + 3'b1 <= DECIMAL_TOP) status <= 4'd2;
                    else status <= INIT_STATUS;
                end
                else if (char == "^") status <= 4'd1;
                else status <= INIT_STATUS;
            end
            4'd3: begin         // Status 3: reading "@"
                if (hexdigit == YES) begin
                    hexReg <= INIT_HEX_REG;
                    status <= 4'd4;
                end
                else if (char == "^") status <= 4'd1;
                else status <= INIT_STATUS;
            end
            4'd4: begin         // Status 4: reading hexadecimal number PC
                if (char == ":") begin
                    if (hexReg == HEX_TOP) status <= 4'd5;
                    else status <= INIT_STATUS;
                end
                else if (hexdigit == YES) begin
                    hexReg <= hexReg + 4'b1;
                    if (hexReg + 4'b1 <= HEX_TOP) status <= 4'd4;
                    else status <= INIT_STATUS;
                end
                else if (char == "^") status <= 4'd1;
                else status <= INIT_STATUS;
            end
            4'd5: begin         // Status 5: reading ":", with or without space
                if (char == "$") status <= 4'd6;
                else if (char == " ") status <= 4'd5;
                else if (char == "*") status <= 4'd7;
                else if (char == "^") status <= 4'd1;
                else status <= INIT_STATUS;
            end
            4'd6: begin         // Status 6: reading "$"
                typeReg <= 1'b0;
                if (digit == YES) begin
                    decimalReg <= INIT_DECIMAL_REG;
                    status <= 4'd8;
                end
                else if (char == "^") status <= 4'd1;
                else status <= INIT_STATUS;
            end
            4'd7: begin         // Status 7: reading "*"
                typeReg <= 1'b1;
                if (hexdigit == YES) begin
                    hexReg <= INIT_HEX_REG;
                    status <= 4'd9;
                end
                else if (char == "^") status <= 4'd1;
                else status <= INIT_STATUS;
            end
            4'd8: begin         // Status 8: reading decimal number grf
                if (char == " ") status <= 4'd10;
                else if (char == "<") status <= 4'd11;
                else if (digit == YES) begin
                    decimalReg <= decimalReg + 3'b1;
                    if (decimalReg + 3'b1 <= DECIMAL_TOP) status <= 4'd8;
                    else status <= INIT_STATUS;
                end
                else if (char == "^") status <= 4'd1;
                else status <= INIT_STATUS;
            end
            4'd9: begin         // Status 9: reading hexadecimal number addr
                if (char == " " || char == "<") begin
                    if (hexReg == HEX_TOP) begin
                        if (char == " ") status <= 4'd10;
                        else status <= 4'd11;
                    end
                    else status <= INIT_STATUS;
                end
                else if (hexdigit == YES) begin
                    hexReg <= hexReg + 4'b1;
                    if (hexReg + 4'b1 <= HEX_TOP) status <= 4'd9;
                    else status <= INIT_STATUS;
                end
                else if (char == "^") status <= 4'd1;
                else status <= INIT_STATUS;
            end
            4'd10: begin        // Status 10: reading space after grf or after addr
                if (char == "<") status <= 4'd11;
                else if (char == " ") status <= 4'd10;
                else if (char == "^") status <= 4'd1;
                else status <= INIT_STATUS;
            end
            4'd11: begin        // Status 11: reading "<"
                if (char == "=") status <= 4'd12;
                else if (char == "^") status <= 4'd1;
                else status <= INIT_STATUS;
            end
            4'd12: begin        // Status 12: reading "=", with or without space
                if (hexdigit == YES) begin
                    hexReg <= INIT_HEX_REG;
                    status <= 4'd13;
                end
                else if (char == " ") status <= 4'd12;
                else if (char == "^") status <= 4'd1;
                else status <= INIT_STATUS;
            end
            4'd13: begin        // Status 13: reading hexadecimal number data
                if (char == "#") begin
                    if (hexReg == HEX_TOP) status <= 4'd14;
                    else status <= INIT_STATUS;
                end
                else if (hexdigit == YES) begin
                    hexReg <= hexReg + 4'b1;
                    if (hexReg + 4'b1 <= HEX_TOP) status <= 4'd13;
                    else status <= INIT_STATUS;
                end
                else if (char == "^") status <= 4'd1;
                else status <= INIT_STATUS;
            end
            4'd14: begin		// Status 14: reading "#"
                if (char == "^") status <= 4'd1;
                else status <= INIT_STATUS;
            end
            default: status <= INIT_STATUS;
        endcase
    end
end

endmodule
