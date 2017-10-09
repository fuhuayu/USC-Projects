// Copyright (c) 2014, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Created by Dylan Hand on 10/13/2014
// Modified by Huimei Cheng on 02/28/2017
// Blade pipestage
`timescale 1ns/10ps
module pipeline( RESET , in_data, in_req , in_ack, in_Ereq, in_Eack , out_req , out_ack , out_Ereq, out_Eack, out_data );
	parameter WIDTH = 8;
	parameter LENGTH = 4;
	input RESET;
	input [WIDTH-1:0] in_data;
	input in_req, in_Eack, out_ack, out_Ereq;
	output reg [WIDTH-1:0] out_data;
	output wire out_req, out_Eack, in_ack, in_Ereq;

	wire [WIDTH-1:0] databus [LENGTH:0];
	wire [LENGTH:0] req, ack, Ereq, Eack;

	assign databus[0] = in_data;
	assign req[0] = in_req;
	assign in_ack = ack[0];
	assign in_Ereq = Ereq[0];
	assign Eack[0] = in_Eack;
	always @(databus[LENGTH]) begin
		out_data<= databus[LENGTH];//
	end
	//assign out_data = databus[LENGTH];
	assign out_req = req[LENGTH];
	assign ack[LENGTH] = out_ack;
	assign Ereq[LENGTH] = out_Ereq;
	assign out_Eack = Eack[LENGTH];

	always @(out_req)
	begin
		tb_BLADE.timeForwardStart.push_back($realtime);
	end

	genvar i;
	generate
		for (i = 0; i < LENGTH; i=i+1)
			pipestage #(.WIDTH(WIDTH)) ps ( RESET , databus[i], req[i], ack[i], Ereq[i], Eack[i], req[i+1], ack[i+1], Ereq[i+1], Eack[i+1], databus[i+1] );
	endgenerate

endmodule

module pipeline2( RESET , in_data, in_req , in_ack, in_Ereq, in_Eack , out_req , out_ack , out_Ereq, out_Eack, out_data );
   parameter WIDTH = 8;
   parameter LENGTH = 4;
   input RESET;
   input [WIDTH-1:0] in_data;
   input in_req, in_Eack, out_ack, out_Ereq;
   output reg [WIDTH-1:0] out_data;
   output wire out_req, out_Eack, in_ack, in_Ereq;

   wire [WIDTH-1:0] databus [LENGTH:0];
   wire [LENGTH:0] req, ack, Ereq, Eack;

   assign databus[0] = in_data;
   assign req[0] = in_req;
   assign in_ack = ack[0];
   assign in_Ereq = Ereq[0];
   assign Eack[0] = in_Eack;

	assign out_data = databus[LENGTH];
	assign out_req = req[LENGTH];
   assign ack[LENGTH] = out_ack;
   assign Ereq[LENGTH] = out_Ereq;
   assign out_Eack = Eack[LENGTH];

	pipestage2 #(.WIDTH(WIDTH)) ps ( RESET , databus[0], req[0], ack[0], Ereq[0], Eack[0], req[1], ack[1], Ereq[1], Eack[1], databus[1] );
   genvar i;
   generate
      for (i = 1; i < LENGTH; i=i+1)
         pipestage #(.WIDTH(WIDTH)) ps ( RESET , databus[i], req[i], ack[i], Ereq[i], Eack[i], req[i+1], ack[i+1], Ereq[i+1], Eack[i+1], databus[i+1] );
   endgenerate

	always @(in_req)
	begin
		tb_BLADE.timeForwardEnd.push_back($realtime);
	end
endmodule

module pipestage( RESET , in_data, in_req , in_ack, in_Ereq, in_Eack , out_req , out_ack , out_Ereq, out_Eack, out_data );
	parameter WIDTH = 8;
	input RESET;
	input [WIDTH-1:0] in_data;
	input in_req, in_Eack, out_ack, out_Ereq;
	output reg [WIDTH-1:0] out_data;
	output wire out_req, out_Eack, in_ack, in_Ereq;

	wire Err0, Err1, sample, clk;

	pcontroller pipe_ctrl( 	.Lreq(in_req), .Lack(in_ack), .LEreq(in_Ereq), .LEack(in_Eack),
							.Rreq(out_req), .Rack(out_ack), .REreq(out_Ereq), .REack(out_Eack),
							.clk(clk), .sample(sample), .Err0(Err0), .Err1(Err1), .rst(RESET) );

	assign Err0 = sample;
	always @(clk, in_data)
	begin
		if (clk == 1)
			out_data <= in_data;
	end
endmodule


module pipestage2( RESET , in_data, in_req , in_ack, in_Ereq, in_Eack , out_req , out_ack , out_Ereq, out_Eack, out_data );
   parameter WIDTH = 8;
   input RESET;
   input [WIDTH-1:0] in_data;
   input in_req, in_Eack, out_ack, out_Ereq;
   output reg [WIDTH-1:0] out_data;
   output wire out_req, out_Eack, in_ack, in_Ereq;

   wire Err0, Err1, sample, clk;

   pcontroller #(0.0,00,00) pipe_ctrl(  .Lreq(in_req), .Lack(in_ack), .LEreq(in_Ereq), .LEack(in_Eack),
                     .Rreq(out_req), .Rack(out_ack), .REreq(out_Ereq), .REack(out_Eack),
                     .clk(clk), .sample(sample), .Err0(Err0), .Err1(Err1), .rst(RESET) );

   assign Err0 = sample;

   always @(clk, in_data)
   begin
      if (clk == 1)
         out_data <= in_data;
   end
endmodule
