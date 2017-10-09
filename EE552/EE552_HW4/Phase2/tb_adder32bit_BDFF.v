// Copyright (c) 2017, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Created by Yang Zhang on 01/20/2017
// Modified by Ramy Tadros on 02/13/2017
// This is the asynchronous BD FF test bench for phase 2

`timescale 1ns/10ps
`include "./../gscl45nm.v"
`include "./../adder16bit.netlist.v"
`include "./controller.v"
`include "./delay_line.v"
`include "./adder32bit_BDFF.v"

module tb_BDFF;
  reg [31:0] a,b;
  reg cin;
  reg L_REQ, R_ACK, reset;
  wire L_ACK, R_REQ;
  wire [7:0] z;
  wire cout;
  wire [31:0]s;
  integer input_a,input_b,input_cin,Result_s;

  reg [31:0]results[8:0];
  integer pointer_in;
  integer pointer_out;
  integer counter=0;
  reg pass;

  adder32bitBDFF DUT (.reset(reset), .Lreq(L_REQ), .Lack(L_ACK), .Rreq(R_REQ), .Rack(R_ACK), .a(a), .b(b), .cin(cin), .s(s), .cout(cout));

  //send
  initial
  begin
	reset = 1;
	pointer_in = 0;
	pointer_out = 0;
	L_REQ = 0;
	{a, b, cin} = 0;
	#5 reset = 0;
	#10;
	while(1)
	begin
		a = $random();
		b = $random();
		cin = $random();

		results[pointer_in] = a;
		results[pointer_in+1] = b;
		results[pointer_in+2] = cin;
		pointer_in = (pointer_in + 3)%9;
		#`forward_l_click;
		L_REQ = ~L_REQ;
		wait(L_ACK == L_REQ);
		#`backward_l_click;
	end
  end

  //receive
  initial
  begin
    pass = 1;
    R_ACK = 0;
	#10;

	while(1)
	begin
		wait(R_ACK != R_REQ);
		#`delay_line_T;
		$display("Input a, b and cin are %h, %h and %h; s and cout are %h %h; counter=%d", results[pointer_out],results[pointer_out+1],results[pointer_out+2],s,cout,counter);

		if(results[pointer_out]+results[pointer_out+1]+results[pointer_out+2] == {15'b0,cout,s})
		begin
			$display ("Correct Result");
		end
		else
		begin
			$display("Incorrect Result");
			pass = 0;
		end
		pointer_out = (pointer_out + 3)%9;
    counter=counter+1;
		#0.1;
		R_ACK = ~R_ACK;
	end
  end

  initial
  begin

	wait(counter==10001);
	if(pass == 0)
	begin
		$display("Test Failed");
	end
	else
	begin
		$display("Test Passed");
	end
	$stop;


  end



endmodule
