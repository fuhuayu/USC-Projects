// Copyright (c) 2017, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Created by Ramy Tadros on 02/12/2017
// Modified by Ramy Tadros on 02/28/2017
// This is a 1-stage asynchronous BD FF 32-bit adder
`timescale 1ns/10ps
`define delay_line_T 6.5 //The delay line delay

module adder32bitBDFF (reset, Lreq, Lack, Rreq, Rack, a, b, cin, s, cout);

	input Lreq, Rack, cin, reset;
	input [0:31] a,b;
	output Lack, Rreq;
	output cout;
	output [0:31] s;
	wire [0:31] af,bf,sf;
	wire cinf,coin,coutf;
	//Use structural Verilog to build the pipeline

	wire clk1, clk2,req1,req2,ack;
	controller c1 (reset, Lreq, Lack, req1, ack, clk1);
	delay_line #(.DELAY(`delay_line_T)) dl (req1,req2);
	controller c2 (reset, req2, ack, Rreq, Rack, clk2);

	DFFPOSX1 dff1 (clk1, cinf, cin);
	genvar i;
	generate for (i = 0; i < 32; i = i + 1) begin
		DFFPOSX1 dffa (clk1, af[i], a[i]);
		DFFPOSX1 dffb (clk1, bf[i], b[i]);
	end endgenerate
	adder16bit adder1 ( af[0:15], bf[0:15], coin, sf[0:15],  coutf);
	adder16bit adder2 ( af[16:31], bf[16:31], cinf, sf[16:31],  coin);
	//Use structural verilog to build the adder here
	genvar j;
	generate for (j = 0; j < 32; j = j + 1) begin
		DFFPOSX1 dffs (clk2, s[j], sf[j]);
	end endgenerate
	DFFPOSX1 dff2 (clk2, cout, coutf);
endmodule
