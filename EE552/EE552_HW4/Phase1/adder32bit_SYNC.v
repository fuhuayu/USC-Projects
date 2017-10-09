// Copyright (c) 2017, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Created by Ramy Tadros on 02/12/2017
// Modified by Ramy Tadros on 02/28/2017
// This is a 1-stage synchronous 32-bit adder

module adder32bitSYNC (CLK, a, b, cin, s, cout);
	input CLK;
	input [0:31] a, b;
	wire [0:31] af,bf,sf;
	wire cinf,coin,coutf;
	input cin;
	output [0:31] s;
	output cout;
	DFFPOSX1 dff1 (CLK, cinf, cin);
	genvar i;
	generate for (i = 0; i < 32; i = i + 1) begin
		DFFPOSX1 dffa (CLK, af[i], a[i]);
		DFFPOSX1 dffb (CLK, bf[i], b[i]);
	end endgenerate
	adder16bit adder1 ( af[0:15], bf[0:15], coin, sf[0:15],  coutf);
	adder16bit adder2 ( af[16:31], bf[16:31], cinf, sf[16:31],  coin);
	//Use structural verilog to build the adder here
	genvar j;
	generate for (j = 0; j < 32; j = j + 1) begin
		DFFPOSX1 dffs (CLK, s[j], sf[j]);
	end endgenerate
	DFFPOSX1 dff2 (CLK, cout, coutf);
endmodule
