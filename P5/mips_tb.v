`timescale 1ns / 1ps


module mips_tb;

	// Inputs
	reg clk;
	reg reset;

	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk(clk), 
		.reset(reset)
	);
	
   always #2 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;

		#20;
		reset = 0;
        
		// Add stimulus here

	end
      
endmodule

