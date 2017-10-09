//Add `timescale properly
`timescale 1ns/1ns

module buffer_non_blocking (out, in); 
input in;
output out;
reg out;
parameter DELAY1=7;
parameter DELAY2=2;
always @(in)
	begin
		#DELAY1 out=#DELAY2 in;
	end
endmodule
