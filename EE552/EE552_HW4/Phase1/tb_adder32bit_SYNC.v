// Copyright (c) 2017, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Created by Ramy Tadros on 02/12/2017
// This is the synchronous test bench for phase 1

`timescale 1ns/10ps

`include "./../gscl45nm.v"
`include "./../adder16bit.netlist.v"
`include "./adder32bit_SYNC.v"

`define Tclk 6.5 //Clock period
`define halfTclk 3.25
module tb_SYNC;
	reg CLK;
	reg [31:0] a,b;
  reg cin;
  wire [7:0] z;
  wire cout;
  wire [31:0]s;
  integer input_a,input_b,input_cin,Result_s;
	integer counter=0;
  reg [31:0]results[8:0];
  integer pointer_in;
  integer pointer_out;
  reg pass;
	adder32bitSYNC DUT (.CLK(CLK), .a(a), .b(b), .cin(cin), .s(s), .cout(cout));
	initial
  begin
	CLK=0;
	while(1)
	begin
	#`halfTclk;
	CLK=~CLK;
	end
  end
	initial
  begin
	pointer_in = 0;
	pointer_out = 0;
	{a, b, cin} = 0;
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
		#`Tclk;
	end
  end

  //receive
  initial
  begin
    pass = 1;
	#10;
	#`Tclk;
	while(1)
	begin
		#`Tclk;
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
	//Use behavioral verilog to describe your testbench here

endmodule
