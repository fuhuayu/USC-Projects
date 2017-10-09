// Copyright (c) 2014, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Created by Dylan Hand
// controller_beh_delay.sv
`timescale 1ns/10ps
module controller_edl(
    output reg Lack,
    output reg Rreq,
    output reg LEreq,
    output reg REack,
    output reg clk,
    output reg sample,
    input Lreq,
    input Rack,
    input LEack,
    input REreq,
    input Err1,
    input Err0,
    input rst
);

    parameter SAMP_DELAY = 0;
    parameter DELTA = 1.8;
    parameter CLK_WIDTH = SAMP_DELAY + DELTA;

    reg b, goD, goML, goLM, edo, edi;
	int fp;
	string name;

    initial
    begin
        {Lack, Rreq, LEreq, REack, clk, sample} = 0;
        {edo, goLM, goML, goD} = 0;
		$sformat(name, "%m.txt");
//		fp = $fopen(name,"w");
    end
/*
	always @(Err0, Err1)
	begin
		if (Err1 == 1)
			$fwrite(fp,"1\n");
		else if (Err0 == 1)
			$fwrite(fp,"0\n");
	end
*/
    // Controller L
    always
    begin
        wait (rst == 1);
        forever
        begin
            wait(Lreq);
            #(0.000) LEreq = 1;
            wait(LEack);
            #(0.000) goLM = 1;
            wait(goML);
            #(0.000) Lack = 1;
            wait(~Lreq);
            #(0.000) LEreq = 0;
            wait(~LEack);
            #(0.000) goLM = 0;
            wait(~goML);
            #(0.000) Lack = 0;
        end
    end

    // Controller R
    always
    begin
        wait (rst == 1);
        forever
        begin
            wait(goLM && ~Rack);
            #(0.000) {goD,Rreq} = 2'b11;
            fork
            begin
                wait(REreq && Err1);
                //{goML, edo} = 2'b11;
                #(0.000) edo = 1;
                wait(edi);
                #(0.000) {REack, goD, edo} = 3'b100;
                wait(~Err1 && ~edi);
            end
            begin
                wait(REreq && Err0);
                //{REack, goML, goD} = 3'b110;
                #(0.000) {REack, goD} = 2'b10;
                wait(~Err0);
            end
            join_any
			disable fork;
            wait(~goLM && Rack);
            #(0.000) {goD, Rreq} = 2'b10;
            fork
            begin
                wait(~REreq && Err1);
                //{goML, edo} = 2'b01;
                #(0.000) edo = 1;
                wait(edi);
                #(0.000) {REack, goD, edo} = 3'b000;
                wait(~Err1 && ~edi);
            end
            begin
                wait(~REreq && Err0);
                //{REack, goML, goD} = 3'b000;
                #(0.000) {REack, goD} = 2'b00;
                wait(~Err0);
            end
            join_any
			disable fork;
        end
    end

    // Controller D
    always
    begin
        wait (rst == 1);
        forever
        begin
            wait(goD);
            #(0.000) clk = 1;
            wait(b);
            //{sample, clk} = 2'b10;
            #(0.000) {goML, sample, clk} = 3'b011;
            #SAMP_DELAY {goML, sample, clk} = 3'b110;
            wait(~goD);
            #(0.000) sample = 0;
            wait(~b && goD);
            #(0.000) clk = 1;
            wait(b);
            #(0.000) {goML, sample, clk} = 3'b111;
            #SAMP_DELAY {goML, sample, clk} = 3'b010;
            wait(~goD);
            #(0.000) sample = 0;
            wait(~b);
        end
    end

    // Delay lines
    always @(clk, sample)
    begin
		if (clk == 1 && sample == 0)
	 	    b <= #(CLK_WIDTH-SAMP_DELAY) (clk | sample);
		else if (clk == 0 && sample == 0)
			b <= 0;
    end

    always @(edo)
    begin
		if (edo)
        	edi <= #DELTA edo;
		else
			edi <= 0;
    end
endmodule

module controller(
    output reg Lack,
    output reg Rreq,
    output reg LEreq,
    output reg REack,
    output reg clk,
    output reg sample,
    input Lreq,
    input Rack,
    input LEack,
    input REreq,
    input Err1,
    input Err0,
    input rst
);
    parameter SAMP_DELAY = 0;
    parameter DELTA = 3;
    parameter CLK_WIDTH = SAMP_DELAY+DELTA;

    reg b, goD, goML, goLM, edo, edi;
	int fp;
	string name;

    initial
    begin
        {Lack, Rreq, LEreq, REack, clk, sample} = 0;
        {edo, goLM, goML, goD} = 0;
		$sformat(name, "%m.txt");
//		fp = $fopen(name,"w");
    end
/*
	always @(Err0, Err1)
	begin
		if (Err1 == 1)
			$fwrite(fp,"1\n");
		else if (Err0 == 1)
			$fwrite(fp,"0\n");
	end
*/
    // Controller L
    always
    begin
        wait (rst == 1);
        forever
        begin
            wait(Lreq);
            #(0.000) LEreq = 1;
            wait(LEack);
            #(0.000) goLM = 1;
            wait(goML);
            #(0.000) Lack = 1;
            wait(~Lreq);
            #(0.000) LEreq = 0;
            wait(~LEack);
            #(0.000) goLM = 0;
            wait(~goML);
            #(0.000) Lack = 0;
        end
    end

    // Controller R
    always
    begin
        wait (rst == 1);
        forever
        begin
            wait(goLM && ~Rack);
            #(0.000) {goD,Rreq} = 2'b11;
            wait(REreq);
            #(0.000) {REack, goD} = 2'b10;
            wait(~goLM && Rack);
            #(0.000) {goD, Rreq} = 2'b10;
            wait(~REreq);
            #(0.000) {REack, goD} = 2'b00;
        end
    end

    // Controller D
    always
    begin
        wait (rst == 1);
        forever
        begin
            wait(goD);
            #(0.000) clk = 1;
            wait(b);
            //{sample, clk} = 2'b10;
            #(0.000) {goML, clk} = 2'b10;
            wait(~goD);
            wait(~b && goD);
            #(0.000) clk = 1;
            wait(b);
            #(0.000) {goML, clk} = 2'b00;
            wait(~goD);
            wait(~b);
        end
    end

    // Delay lines
    always @(clk)
    begin
         b <= #(CLK_WIDTH) (clk);
    end

endmodule
