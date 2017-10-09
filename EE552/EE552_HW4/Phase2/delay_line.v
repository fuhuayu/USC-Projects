// Copyright (c) 2017, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Author: Dylan Hand
// Modified by Ramy Tadros on 02/13/2017
// This is a behavioral delay line
`timescale 1ns/10ps
module delay_line (in,out);
	parameter DELAY = 0;
	input in;
	output out;
	reg out;

	always @(in)
		begin
			out <= #DELAY in; //Transport delay_line
		end

endmodule
