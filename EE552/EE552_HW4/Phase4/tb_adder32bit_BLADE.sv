// Copyright (c) 2017, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Created by Humei Cheng on 01/21/2017
// Modified by Humei Cheng on 02/09/2017
// Modified by Ramy Tadros on 02/13/2017
// Modified by Huimei Cheng on 02/28/2017
// This is the BLADE test bench for phase 4
`timescale 1ns/10ps
`define CLOCK_PERIOD 5ns
`define HALF_PERIOD `CLOCK_PERIOD/2
`include "./../gscl45nm.v"
`include "./../adder16bit.netlist.v"
`include "./../Phase2/delay_line.v"
`include "./s2a.sv"
`include "./a2s.sv"
`include "./pcontroller_beh.sv"
`include "./pipeline.sv"
`include "./controller_beh_delay.sv"
`include "./controller_token_beh_delay.sv"
`include "./ed4cinsert.v"
`include "./blade_tdtb.v"
`include "./blade_lib.v"
`include "./qflop_beh.v"

`include "adder32bit_BLADE.v"

module tb_BLADE;
    reg [32:0] golden [$];
    real timeForwardStart [$];
    real timeForwardEnd [$];
    reg clk_async;
    always #(`HALF_PERIOD) clk_async = ~clk_async;
    // We need a reset
    reg RESET;
    initial
    begin
	RESET = 0; // Active low
	clk_async = 1;
        #100;
	RESET = 1;
    end

    // We need a generator

	wire [31:0] a,b,s;
	wire cin,cout;
	wire [64:0] datapath_pipeline_in;
	wire [32:0] datapath_pipeline_out, datapath_out;

	s2a s2a_ch1 ( .CLK(clk_async), .RESET(RESET),
        .out_data(datapath_pipeline_in),
        .out_req( p_in_req ),
        .out_Ereq( p_in_Ereq ),
        .out_Eack( p_in_Eack ),
        .out_ack( p_in_ack )
        );

	pipeline #(.WIDTH(65)) p_in (.RESET(RESET),.in_req(p_in_req),.in_ack(p_in_ack),.in_Ereq(p_in_Ereq),.in_Eack(p_in_Eack),.out_req( ch1_req ), .out_ack( ch1_ack ), .out_Ereq( ch1_Ereq ),.out_Eack( ch1_Eack ), .in_data( datapath_pipeline_in ),.out_data( {a,b,cin} ));

	adder32bitBLADE U_ASYNC ( ._RESET(RESET)
	,.a(a),.b(b),.cin(cin),.cout(cout),.s(s),
        .ch1_req ( ch1_req ) ,
        .ch1_Ereq ( ch1_Ereq ) ,
        .ch1_Eack ( ch1_Eack ) ,
        .ch1_ack ( ch1_ack ) ,
        .ch2_req ( ch2_req ) ,
        .ch2_Ereq ( ch2_Ereq ) ,
        .ch2_Eack ( ch2_Eack ) ,
        .ch2_ack ( ch2_ack )
		);

	pipeline2 #(.WIDTH(33)) p_out2 ( .RESET(RESET), .in_req( ch2_req ), .in_ack( ch2_ack ),.in_Ereq( ch2_Ereq ), .in_Eack( ch2_Eack ),.out_req( p_out2_req ), .out_ack( p_out2_ack ), .out_Ereq( p_out2_Ereq ),.out_Eack( p_out2_Eack),.out_data( datapath_pipeline_out ),.in_data( {cout,s} ));

	a2s a2s_ch2 ( .RESET(RESET),
        .in_data( datapath_pipeline_out ),
        .in_req( p_out2_req ),
        .in_Ereq( p_out2_Ereq ),
        .in_Eack( p_out2_Eack ),
        .in_ack( p_out2_ack ),
        .out_data( datapath_out ) );
endmodule
