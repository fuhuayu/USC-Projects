// Copyright (c) 2014, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Created by Dylan Hand on 07/28/2014
// Modified by Huimei Cheng on 02/28/2017
// Synchronous to Asynchronous Converter
`timescale 1ns/10ps
class SimpleRand;
    rand logic [64:0] data;
endclass

module s2a( CLK , RESET , out_req , out_ack , out_Ereq, out_Eack, out_data );
	input CLK, RESET;
	input out_ack, out_Ereq;
	output reg [64:0] out_data;
	output reg out_req = 0;
	output reg out_Eack = 0;
	SimpleRand rand_data;
	string IN_VEC_FILE = "input_vector.txt";
	reg state = 0;
	reg ext_state = 0;
	reg [32:0] goldenvalue;
	integer i,vecfile, status;

	initial	begin
		  if (1) begin
			rand_data = new();
			vecfile=$fopen(IN_VEC_FILE,"w");
			for (i=1;i<10004;i++) begin
				if (rand_data.randomize()) begin
					out_data = rand_data.data;
					$fdisplayb(vecfile,out_data);
				end
				else
					$display("Randomization failed! data=%h", rand_data.data);
			end
			$fclose(vecfile);
		end
		vecfile = $fopen(IN_VEC_FILE,"r");
		status = $fscanf(vecfile, "%b\n", out_data);
		#10000000 $finish;
	end

	always	begin
		if ($feof(vecfile))
			#10;
		else if (RESET == 0)
		begin
			wait (RESET == 1);
		end
		else
		begin
			status = $fscanf(vecfile, "%b\n", out_data);
			out_req = ~state; // Makes it 1
			wait (out_Ereq == ~ext_state); // Waits for it to be 1
			out_Eack = ~ext_state; // Makes it 1
			ext_state = ~ext_state;
			wait (out_ack == ~state); // Waits for 1
			state = ~state;
			goldenvalue = out_data[64:33] + out_data[32:1] + out_data[0];
			tb_BLADE.golden.push_back(goldenvalue);
//			tb_BLADE.timeForwardStart.push_back($realtime);
//			$display("input: %h, golden data: %h, time is %t",out_data, goldenvalue, $realtime);
		end
	end

endmodule
