// Copyright (c) 2014, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Created by Dylan Hand
// pcontroller behavioral
`timescale 1ns/10ps
module pcontroller(
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
    parameter CLK_WIDTH = 0.1;
    parameter SAMP_DELAY = 0.1;
    parameter DELAY_E = 0.1;

    reg b, goD, goML, goLM, edo, edi;
	int fp;

    initial
    begin
        {Lack, Rreq, LEreq, REack, clk, sample} = 0;
        {edo, goLM, goML, goD} = 0;
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
            LEreq = 1;
            wait(LEack);
            goLM = 1;
            wait(goML);
            Lack = 1;
            wait(~Lreq);
            LEreq = 0;
            wait(~LEack);
            goLM = 0;
            wait(~goML);
            Lack = 0;
        end
    end

    // Controller R
    always
    begin
        wait (rst == 1);
        forever
        begin
            wait(goLM && ~Rack);
            {goD,Rreq} = 2'b11;
            fork
            begin
                wait(REreq && Err1);
                //{goML, edo} = 2'b11;
                edo = 1;
                wait(edi);
                {REack, goD, edo} = 3'b100;
                wait(~Err1 && ~edi);
            end
            begin
                wait(REreq && Err0);
                //{REack, goML, goD} = 3'b110;
                {REack, goD} = 2'b10;
                wait(~Err0);
            end
            join_any
			disable fork;
            wait(~goLM && Rack);
            {goD, Rreq} = 2'b10;
            fork
            begin
                wait(~REreq && Err1);
                //{goML, edo} = 2'b01;
                edo = 1;
                wait(edi);
                {REack, goD, edo} = 3'b000;
                wait(~Err1 && ~edi);
            end
            begin
                wait(~REreq && Err0);
                //{REack, goML, goD} = 3'b000;
                {REack, goD} = 2'b00;
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
            clk = 1;
            wait(b);
            //{sample, clk} = 2'b10;
            {goML, sample, clk} = 3'b011;
            #SAMP_DELAY {goML, sample, clk} = 3'b110;
            wait(~goD);
            sample = 0;
            wait(~b && goD);
            clk = 1;
            wait(b);
            {goML, sample, clk} = 3'b111;
            #SAMP_DELAY {goML, sample, clk} = 3'b010;
            wait(~goD);
            sample = 0;
            wait(~b);
        end
    end

    // Delay lines
    always @(clk, sample)
    begin
         b <= #(CLK_WIDTH-SAMP_DELAY) (clk | sample);
    end

    always @(edo)
    begin
        edi <= #DELAY_E edo;
    end
endmodule
