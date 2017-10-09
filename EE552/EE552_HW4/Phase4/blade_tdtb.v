// Copyright (c) 2014, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Created by Danlei Chen, Guan Wang, Zhe Liu, Fei Huang, Dylan Hand
// blade_tdtb.v

`define DELAY_PERIOD 10
`define DELAY_RESET 1'b0
`timescale 1ns/10ps
module small_delay_line(in,out);
parameter DELAY = `DELAY_PERIOD;
input in;
output out;
reg out;

always @(in)
begin
	out <= #DELAY in;//Transport delay_line
end

endmodule

module BLADE_TDTB_OPTX8(CLK, D, Q, X);
`ifdef SYNTHESIS
	parameter DELAY_PERIOD = 1;
	parameter XOR_DELAY = 1;
`else
	parameter DELAY_PERIOD = 0.020;
	parameter XOR_DELAY = 0.012;
`endif
	input D, CLK;
	output reg Q;
	output X;
	wire delayOut;

`ifdef REC_SLACK
// Fei: Add you recording code here!
	real time_data;
   real time_clk;
   integer output_file;
   integer cyc_num;
   real clk_period;
   real d_slack;
   reg flag;
   string temp_filename;
   integer length;
   string filename;

	initial begin
      temp_filename = $psprintf("REC_%m");
      length = temp_filename.len();
      filename = {temp_filename.substr(0,length-1),".txt"};

      output_file = $fopen(filename, "w");
   end

   always @(D) begin
      time_data = $realtime;
      flag = 1;
   end

   always @(posedge CLK) begin
      clk_period = $realtime - time_clk;
      time_clk = $realtime;
      if (flag == 1) begin
      	d_slack = time_clk - time_data;
         if (d_slack <= clk_period)
            $fwrite(output_file, "%g\n", d_slack);   //Ver for Matlab
         else
            $fwrite(output_file, "%g\n", clk_period);   //Ver for Matlab
         flag = 0;
      end
      else begin
         $fwrite(output_file, "%g\n", clk_period); //Ver for Matlab
      end
   end
`endif


	always @(CLK, D)
	begin
		if (CLK == 1)
			Q <= D;
	end

//	always @(D)
//	begin
//		if (CLK == 1)
//			$display("%m : Error occured!");
//	end

	small_delay_line #(.DELAY(DELAY_PERIOD)) dl(D, delayOut);
	xorGate #(.DELAY(XOR_DELAY)) x(D, delayOut, X);
endmodule

module BLADE_TDTBR_OPTX8(CLK, RN, D, Q, X);
`ifdef SYNTHESIS
	parameter DELAY_PERIOD = 1;
	parameter XOR_DELAY = 1;
`else
	parameter DELAY_PERIOD = 0.020;
	parameter XOR_DELAY = 0.012;
`endif
	input D, CLK, RN;
	output reg Q;
	output X;
	wire delayOut;

`ifdef REC_SLACK
// Fei: Add you recording code here!
	real time_data;
   real time_clk;
   integer output_file;
   integer cyc_num;
   real clk_period;
   real d_slack;
   reg flag;
   string temp_filename;
   integer length;
   string filename;

   initial begin
      temp_filename = $psprintf("REC_%m");
      length = temp_filename.len();
      filename = {temp_filename.substr(0,length-1),".txt"};

      output_file = $fopen(filename, "w");
   end

   always @(D) begin
      time_data = $realtime;
      flag = 1;
   end

   always @(posedge CLK) begin
      clk_period = $realtime - time_clk;
      time_clk = $realtime;
      if (flag == 1) begin
         d_slack = time_clk - time_data;
         if (d_slack <= clk_period)
            $fwrite(output_file, "%g\n", d_slack);   //Ver for Matlab
         else
            $fwrite(output_file, "%g\n", clk_period);   //Ver for Matlab
         flag = 0;
      end
      else begin
         $fwrite(output_file, "%g\n", clk_period); //Ver for Matlab
     	end
   end
`endif

	always @(CLK, RN, D)
	begin
		if (RN == 0)
			Q <= #0.02 0;
		else if (CLK == 1)
			Q <= #0.02 D;
	end

//	always @(D)
//	begin
//		if (CLK == 1)
//			$display("%m : Error occured!");
//	end

	small_delay_line #(.DELAY(DELAY_PERIOD)) dl(D, delayOut);
	xorGate #(.DELAY(XOR_DELAY)) x(D, delayOut, X);
endmodule
