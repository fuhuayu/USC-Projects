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

//Sample full buffer module
module pCell (interface Hi,Ho,Pi,Po,Si,So) ;
  parameter WIDTH = 4;
  logic [WIDTH-1:0] y=0,h=0;
  logic p,s,s_,nw,i=0;
  always
  begin
	if(i==0)
		begin
			i=1;
			Pi.Receive(p);
			Po.Send(p);
		end
	else
		begin
			Si.Receive(s);
			if(s==1) 
				begin
					s_=1;
					nw=0;
					p=1;
					Hi.Receive(y);
					Po.Send(p);
				end
			else
				begin
					if(s_==1)	
						begin
							if(nw==0)
								begin
									nw=1;
									Hi.Receive(h);
									if(y==h) p=1;
									else p=0;
									Po.Send(p);
								end
							else
								begin
									So.Send(s_);
									s_<=0;
									Ho.Send(h);
									Hi.Receive(h);
									Pi.Receive(p);
									if(p==1)
										begin
											if(y!=h) p=0;
										end
									else
										p=0;
									Po.Send(p);
								end
						end
					else
						begin
							So.Send(s_);
							Ho.Send(h);
							Hi.Receive(h);
							Pi.Receive(p);
							if(p==1)
								begin
									if(y!=h) p=0;
								end
							else
								p=0;
							Po.Send(p);
						end
				end
		end
	
  end
endmodule
module data_generator (interface r);
  parameter FL = 0; //ideal environment
  logic SendValue=1;
  always
  begin 
    //add a display here to see when this module starts its main loop
    
    
    #FL;
     
    //Communication action Send is about to start
    $display("Starting %m.Send @ %d", $time);
    r.Send(SendValue);
    //Communication action Send is finished
    $display("Finished %m.Send @ %d", $time);
  end
endmodule
module data_bucket (interface r);
  parameter WIDTH = 1;
  parameter BL = 0; //ideal environment
  logic [WIDTH-1:0] ReceiveValue = 0;
  
  //Variables added for performance measurements
  real cycleCounter=0, //# of cycles = Total number of times a value is received
       timeOfReceive=0, //Simulation time of the latest Receive 
       cycleTime=0; // time difference between the last two receives
  real averageThroughput=0, averageCycleTime=0, sumOfCycleTimes=0;
  always
  begin
	//$display("Start module data_bucket and time is %d", $time);	
    //Save the simulation time when Receive starts
    timeOfReceive = $time;
    r.Receive(ReceiveValue);
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
	//$display("End module data_bucket and time is %d", $time);
  end

endmodule
//top level module instantiating data_generator, reciever, and the interface
module palindrome(interface H, S , P) ;
  parameter N = 4;
  Channel #(.WIDTH(4),.hsProtocol(P4PhaseBD)) intfH  [N-1:0] (); 
  Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) intfS  [N-1:0] (); 
  Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) intfP  [N-1:0] (); 
  pCell p1(H,intfH[0],intfP[0],P,S,intfS[0]);
  genvar i;
	generate for (i = 0; i < N-1; i = i + 1) begin
		pCell pp(intfH[i],intfH[i+1],intfP[i+1],intfP[i],intfS[i],intfS[i+1]);
	end endgenerate
  data_generator dg(intfP[N-1]);
  data_bucket #(.WIDTH(4)) dbH(intfH[N-1]);
  data_bucket #(.WIDTH(1)) dbS(intfS[N-1]);
  // use genvar and generate to instantiate N pcells
  // for the last pcell add proper bit bucket/gen to avoid deadlock
		
endmodule
