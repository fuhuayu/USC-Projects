//Don't forget to add `timescale here
`timescale 1ns/1ns

module buffer_blocking (out, in); 
input in;
output out;
reg out;		
parameter DELAY1=3;
parameter DELAY2=5;
always @(in)
	begin
		#DELAY1 out=#DELAY2 in;
	end
endmodule
