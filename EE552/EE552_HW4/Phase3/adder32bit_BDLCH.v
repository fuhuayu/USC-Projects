// Copyright (c) 2017, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Created by Ramy Tadros on 02/12/2017
// Modified by Ramy Tadros on 02/28/2017
// This is a 1-stage asynchronous BD FF 32-bit adder
`timescale 1ns/10ps
`define delay_line_T 5.2 //The delay line delay

module adder32bitBDLCH (reset, Lreq, Lack, Rreq, Rack, a, b, cin, s, cout);

	input Lreq, Rack, cin, reset;
	input [0:31] a,b;
	output Lack, Rreq;
	output cout;
	output [0:31] s;
	wire [0:31] af,bf,sf;
	wire [0:15] aff,bff,sff;
	wire cinf,coin,coutf,coinf;
	//Use structural Verilog to build the pipeline

	wire clk1, clk2,req1,req2,req3,ack1,ack2;
	controller c1 (reset, Lreq, Lack, req1, ack1, clk1);
	delay_line #(.DELAY(`delay_line_T)) dl (req1,req2);
	controller c2 (reset, req2, ack1, req3, ack2, clk2);
	delay_line #(.DELAY(`delay_line_T)) d2 (req3,req4);
	controller c3 (reset, req4, ack2, Rreq, Rack, clk3);

	LATCH l1 (cin, clk1, cinf);
	genvar i;
	generate for (i = 0; i < 32; i = i + 1) begin
		LATCH la (a[i],clk1,af[i]);
		LATCH lb (b[i],clk1,bf[i]);
	end endgenerate
	adder16bit adder1 ( af[16:31], bf[16:31], cinf, sff,  coin);

	LATCH l2 (coin, clk2, coinf);
	generate for (i = 0; i < 16; i = i + 1) begin
		LATCH laa (af[i],clk2,aff[i]);
		LATCH lbb (bf[i],clk2,bff[i]);
		LATCH ls (sff[i],clk2,sf[i+16]);
	end endgenerate
	//Use structural verilog to build the adder here

	adder16bit adder2 ( aff, bff, coinf, sf[0:15],  coutf);
	genvar j;
	generate for (j = 0; j < 32; j = j + 1) begin
		LATCH lss (sf[j],clk3, s[j]);
	end endgenerate
	LATCH l3 (coutf,clk3, cout);
endmodule
