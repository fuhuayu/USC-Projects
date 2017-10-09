//Written by Arash Saifhashemi
//Modified By Mehrdad Najibi
////SystemVerilogCSP Interfaces based on Bundled Data Handshaking Protocols
//EE552, Department of Electrical Engineering
//University of Southern California
//Spring 2011
//Version 1.00

`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

//Sample data_generator module
module data_generator (interface r);
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  logic [WIDTH-1:0] SendValue=0;
  always
  begin 
    //add a display here to see when this module starts its main loop
    
    SendValue = $random() % (2**WIDTH);
    #FL;
     
    //Communication action Send is about to start
    $display("Starting %m.Send @ %d", $time);
    r.Send(SendValue);
    //Communication action Send is finished
    $display("Finished %m.Send @ %d", $time);
  end
endmodule

//Sample data_bucket module
module token_buffer(interface left, interface right);
	parameter WIDTH=8;
	parameter SendValue=8'b0;
	parameter FL = 2;
	parameter BL = 4;
	logic [WIDTH-1:0] d;
	//Variables added for performance measurements
	real cycleCounter=0, //# of cycles = Total number of times a value is received
       timeOfReceive=0, //Simulation time of the latest Receive 
       cycleTime=0; // time difference between the last two receives
	real averageThroughput=0, averageCycleTime=0, sumOfCycleTimes=0;
	
	
	initial
		begin
			right.Send(SendValue);
		end
	
	always
		begin
			$display("*** %m and time is %d", $time);	
			//Save the simulation time when Receive starts
			timeOfReceive = $time;
			$display("Start receiveing in module %m. Simulation time =%t", $time);
			left.Receive(d);
			$display("Finished receiving in module %m. Simulation time =%t", $time);
			#FL;
			right.Send(d);
			#BL;
			cycleCounter += 1;		
			//Measuring throughput: calculate the number of Receives per unit of time  
			//CycleTime stores the time it takes from the begining to the end of the always block
			cycleTime = $time - timeOfReceive;
			averageThroughput = cycleCounter/$time;
			sumOfCycleTimes += cycleTime;
			averageCycleTime = sumOfCycleTimes / cycleCounter;
			$display("Execution cycle= %d, Cycle Time= %d, 
			Average CycleTime=%f, Average Throughput=%f", cycleCounter, cycleTime, 
			averageCycleTime, averageThroughput);
		end
endmodule

//Sample full buffer module
module full_buffer (interface left, interface right);
  parameter FL = 2;
  parameter BL = 6;
  parameter WIDTH = 8;
  logic [WIDTH-1:0] data;
  always
  begin
    //add a display here to see when this module starts its main loop
    
    left.Receive(data);
    #FL; //Forward Latency: Delay from recieving inputs to send the results forward
    right.Send(data);
    #BL;//Backward Latency: Delay from the time data is delivered to the time next input can be accepted
  end
endmodule

//top level module instantiating data_generator, reciever, and the interface
module ring_buffer_10;
	parameter X=9;//N;
	parameter Y=9;

  //Interface Vector instatiation: 4-phase bundled data channel
  Channel #(.hsProtocol(P4PhaseBD)) intf  [29:0] (); 
  
  //instantiate test circuit
  
  genvar i,j;
  generate 
	for (i=0;i<X;i=i+1) 
		token_buffer #(.WIDTH(8), .FL(2), .BL(8)) TB(intf[i],intf[i+1]);
  endgenerate
  
  generate
	for (j=X;j<Y;j=j+1)
		full_buffer #(.WIDTH(8), .FL(2), .BL(8)) FB(intf[j], intf[j+1]);
  endgenerate
  
		full_buffer #(.WIDTH(8), .FL(2), .BL(8)) FB29(intf[Y], intf[0]);

  


endmodule
