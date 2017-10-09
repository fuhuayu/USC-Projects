// Copyright (c) 2014, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Created by Dylan Hand
// qflop_beh.v
`timescale 1ns/10ps
module Q_Flop(CLK, D, Q, Qbar);
	input CLK, D;
	output Q, Qbar;
	reg Q, Qbar;

	always @(CLK)
	begin
		if (CLK == 1)
		begin
			Q <= D;
			Qbar <= ~D;
		end
		else
		begin
			Q <= 0;
			Qbar <= 0;
		end
	end
endmodule
