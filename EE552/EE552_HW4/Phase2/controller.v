// Copyright (c) 2017, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Created by Yang Zhang on 01/20/2017
// Modified by Yang Zhang on 02/13/2017
// Modifier by Ramy Tadros on 02/17/2017
// This is the Click Controller for BD design
`timescale 1ns/10ps
`define local_clk_width 0.2
`define forward_l_click 0.1 //Controller FL
`define backward_l_click 0.4 //Controller BL

module controller (reset, a_req, a_ack, b_req, b_ack, dff_clk);
input reset, a_req, b_ack;
output a_ack, b_req, dff_clk;
reg dff_con;
wire dff_clk_buf;
wire dff_clk_con;
wire a_ack_buf;
wire [30:0]connection;
assign dff_clk_buf = ~a_req & a_ack_buf & b_ack | (a_req & ~a_ack_buf & ~b_ack);
assign dff_clk = dff_clk_buf;
assign #`backward_l_click a_ack = dff_con;
assign #`local_clk_width a_ack_buf = dff_con;
assign #`forward_l_click b_req = dff_con;
assign dff_clk_con =  dff_clk_buf ;

always@(posedge dff_clk_con, posedge reset)
begin
	if(reset)
		dff_con <= 0;
	else
	begin
		dff_con <= ~dff_con;
	end
end
endmodule
