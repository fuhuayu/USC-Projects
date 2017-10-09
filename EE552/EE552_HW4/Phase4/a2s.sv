// Copyright (c) 2014, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Created by Dylan Hand on 07/28/2014
// Modified by Huimei Cheng on 02/28/2017
// Asynchronous to Synchronous Converter
`timescale 1ns/10ps
module a2s( RESET , in_req , in_ack , in_Ereq , in_Eack , in_data , out_data );
input RESET;
input [32:0] in_data;
input in_req, in_Eack;
output [32:0] out_data;
output reg in_ack = 0;
output reg in_Ereq = 0;

real errorRate, timeStart, timeReceive, iRecvTime, iCycleTime, avgCycleTime, sumRecvTime = 0;
real avgForwardTime, sumForwardTime, timeCurrent, timeForward, timeForwardStart, timeForwardEnd;
int cycleCount, iCycleCount = 0;

reg state = 0;
reg ext_state = 0;
reg [32:0] goldenvalue;
int errorCount = 0;

assign out_data = in_data;

	always
	begin
		if (RESET == 0)
		begin
			wait (RESET == 1);
		end
		else
		begin
			timeStart = $realtime;
			cycleCount += 1;
			iCycleCount += 1;
			wait (in_req == ~state); // Wait for 1
			in_Ereq = ~ext_state; // Send a 1
			wait (in_Eack == ~ext_state); // WAit for 1
			ext_state = ~ext_state;
			in_ack = ~state;
			state = ~state;
			if (cycleCount > 1)
			begin
				timeCurrent = $realtime;
				timeReceive = timeCurrent - timeStart;
				timeForwardStart = tb_BLADE.timeForwardStart.pop_front();
				timeForwardEnd = tb_BLADE.timeForwardEnd.pop_front();
				timeForward = timeForwardEnd - timeForwardStart;
//				timeForward = tb_BLADE.timeForwardEnd.pop_front() - tb_BLADE.timeForwardStart.pop_front();
				sumRecvTime += timeReceive;
				iRecvTime += timeReceive;
				sumForwardTime += timeForward;
				avgCycleTime = sumRecvTime / (cycleCount-1);
				iCycleTime = iRecvTime / (iCycleCount-1);
				avgForwardTime = sumForwardTime / (cycleCount-1);
				goldenvalue = tb_BLADE.golden.pop_front();
				if (goldenvalue !== in_data) begin
				$display("Cycle: %d Datapath mis-match(Error number: %d)!",     cycleCount, errorCount);
                                $display("Cycle: %d\tAsync:\t%b", cycleCount, in_data);
                                $display("Cycle: %d\tGolden:\t%b", cycleCount, goldenvalue);
                                errorCount++;
				end
				if (iCycleCount == 9999) begin
// Put statistical results
					$display("Average Cycle Time: %g , Instantaneous Cycle Time: %g , Average Forward Time: %g", avgCycleTime, iCycleTime, avgForwardTime);
					if (errorCount == 0)
						$display("Simulation ends with no mismatch!");
					else
						$display("Simulation ends with %d mismatchs!", errorCount);
					$finish;
				end
			end
		end
	end
endmodule
