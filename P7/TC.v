`timescale 1ns / 1ps
`define IDLE 2'b00
`define LOAD 2'b01
`define CNT  2'b10
`define INT  2'b11

`define ctrl   mem[0]
`define preset mem[1]
`define count  mem[2]
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:43:39 12/28/2017 
// Design Name: 
// Module Name:    TC 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module TC(
    input clk,                // 时钟信号
    input reset,              // 同步复位信号
    input [31:2] Addr,        // 待写入寄存器编号
    input WE,                 // 写使能信号
    input [31:0] Din,         // 待写入数据
    output [31:0] Dout,       // 寄存器读出数据
    output IRQ                // 是否产生计时器中断
    );

	reg [1:0] state;
	reg [31:0] mem [2:0];
	
	reg _IRQ;
	assign IRQ = `ctrl[3] & _IRQ;
	
	assign Dout = mem[Addr[3:2]];
	
	wire [31:0] load = Addr[3:2] == 0 ? {28'h0, Din[3:0]} : Din;
	
	integer i;
	always @(posedge clk) begin
		if(reset) begin
			state <= 0; 
			for(i = 0; i < 3; i = i+1) mem[i] <= 0;
			_IRQ <= 0;
		end
		else if(WE) begin
			// $display("%d@: *%h <= %h", $time, {Addr, 2'b00}, load);
			mem[Addr[3:2]] <= load;
		end
		else begin
			case(state)
				`IDLE : if(`ctrl[0]) begin
					state <= `LOAD;
					_IRQ <= 1'b0;
				end
				`LOAD : begin
					`count <= `preset;
					state <= `CNT;
				end
				`CNT  : 
					if(`ctrl[0]) begin
						if(`count > 1) `count <= `count-1;
						else begin
							`count <= 0;
							state <= `INT;
							_IRQ <= 1'b1;
						end
					end
					else state <= `IDLE;
				default : begin
					if(`ctrl[2:1] == 2'b00) `ctrl[0] <= 1'b0;
					else _IRQ <= 1'b0;
					state <= `IDLE;
				end
			endcase
		end
	end

endmodule
