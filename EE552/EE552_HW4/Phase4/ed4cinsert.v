// Copyright (c) 2014, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Created by Dylan Hand and Danlei Chen
// ed4cinsert.v
`timescale 1ns/10ps
module ortree(in, out);
	parameter WIDTH = 4;
	parameter DELAY = 0.10;
	input [WIDTH-1:0] in;
	output out;

	assign  out = |in;
endmodule

module andtree(in, out);
	parameter WIDTH = 4;
	parameter DELAY = 0.10;
	input [WIDTH-1:0] in;
	output out;

	assign  out = &in;
endmodule

module xorGate(in1, in2, out);
parameter DELAY = 0;
	input in1, in2;
	output out;
	reg out;

	always @(in1, in2)
	begin
`ifdef SYNTHESIS
		if(in1 == in2) out <= 0;
`else
		if(in1 === in2) out <= #DELAY 0;
`endif
		else out <= #DELAY 1;
	end

endmodule

module transition_detector(d, tdOut);
`ifdef SYNTHESIS
	parameter DELAY_PERIOD = 1;
`else
	parameter DELAY_PERIOD = 0.08;
`endif

	input d;
	output tdOut;
	wire tdOut, delayOut;

	delay_line #(.DELAY(DELAY_PERIOD)) dl(d, delayOut);
	xorGate x(d, delayOut, tdOut);
endmodule
