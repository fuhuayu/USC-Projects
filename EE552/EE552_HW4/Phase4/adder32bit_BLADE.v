// Copyright (c) 2017, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Created by Ramy Tadros on 02/13/2017
// This is a 2-stage asynchronous BLADE 32-bit adder
`define delay_line_T 3.4
`timescale 1ns/10ps
module adder32bitBLADE ( a, b, cin, cout, s, _RESET, ch1_req, ch1_Eack, ch2_ack,
        ch2_Ereq, ch1_ack, ch1_Ereq, ch2_req, ch2_Eack );

  input [31:0] a;
  input [31:0] b;
  output [31:0] s;
  input cin, _RESET, ch1_req, ch1_Eack, ch2_ack, ch2_Ereq;
  output cout, ch1_ack, ch1_Ereq, ch2_req, ch2_Eack;
  wire w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11;
  wire clk1,clk2,clk3,clk21,clk22,clk211,clk222,qfclk;
  wire err0,err1,D1,D2,Q1,Q2,Q1bar,Q2bar;
  wire [0:5] x;
  wire [0:31] af,bf,sf;
	wire [0:15] aff,bff,sff;
  //Use structural Verilog to build the pipeline

  token_controller tc (.LEreq(ch1_Ereq),.LEack(ch1_Eack),.Lack(ch1_ack),.Lreq(ch1_req),.rst(_RESET),
  .REreq(w1),.REack(w2),.Rack(w3),.Rreq(w4),.Err1(err1), .Err0(err0),.clk(clk1));
  delay_line #(.DELAY(`delay_line_T)) dl (w4,w5);
  controller_edl ced(.LEreq(w1),.LEack(w2),.Lack(w3),.Lreq(w5),.rst(_RESET),
  .REreq(w6),.REack(w7),.Rack(w8),.Rreq(w9),.clk(clk2),.Err1(err1), .Err0(err0),.sample(qfclk));
  CLKBUF1 clkb1(clk21,clk2);
  CLKBUF1 clkb2(clk211,clk21);
  CLKBUF1 clkb3(clk22,clk2);
  CLKBUF1 clkb4(clk222,clk22);
  delay_line #(.DELAY(`delay_line_T)) d2 (w9,w10);
  controller ct (.LEreq(w6),.LEack(w7),.Lack(w8),.Lreq(w10),.rst(_RESET),
  .REreq(ch2_Ereq),.REack(ch2_Eack),.Rack(ch2_ack),.Rreq(w11),.Err1(err1), .Err0(err0),.clk(clk3));
  delay_line #(.DELAY(`delay_line_T)) d3 (w11,ch2_req);

	LATCH l1 (cin, clk1, cinf);
	genvar i;
	generate for (i = 0; i < 32; i = i + 1) begin
		LATCH la (a[i],clk1,af[i]);
		LATCH lb (b[i],clk1,bf[i]);
	end endgenerate
	adder16bit adder1 ( af[16:31], bf[16:31], cinf, sff,  coin);

	BLADE_TDTB_OPTX8 edlcout (clk2, coin, coinf, x[5]);
	generate for (i = 0; i < 16; i = i + 1) begin
		LATCH laa (af[i],clk2,aff[i]);
		LATCH lbb (bf[i],clk2,bff[i]);
	end endgenerate
  generate for (i = 0; i < 11; i = i + 1) begin
		LATCH ls (sff[i],clk2,sf[i+16]);
	end endgenerate
  genvar k;
	generate
		for (k=11; k<16; k=k+1)
		begin
			BLADE_TDTB_OPTX8 edls (clk2, sff[k], sf[k+16], x[k-11]);
		end
	endgenerate
  BLADE_CE1CK4X4 C1 (D1, x[0], x[1], x[2], clk211);
	BLADE_CE1CK4X4 C2 (D2, x[3], x[4], x[5], clk222);
	//Use structural verilog to build the adder here
  Q_Flop	QF1	(qfclk, D1, Q1, Q1bar);
	Q_Flop	QF2	(qfclk, D2, Q2, Q2bar);
  assign err1=Q1|Q2;
  assign err0=Q1bar&Q2bar;
	adder16bit adder2 ( aff, bff, coinf, sf[0:15],  coutf);
	genvar j;
	generate for (j = 0; j < 32; j = j + 1) begin
		LATCH lss (sf[j],clk3, s[j]);
	end endgenerate
	LATCH l3 (coutf,clk3, cout);
endmodule
