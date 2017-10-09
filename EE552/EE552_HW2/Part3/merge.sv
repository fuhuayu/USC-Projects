`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

module data_generator (interface r1,interface r2,interface r3);
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  logic [2*WIDTH-1:0] SendValue=0;
  logic [1:0]sel=2;
  always
  begin 
    //add a display here to see when this module starts its main loop
    SendValue = $random() % (2**(2*WIDTH));
    #FL;
     
    //Communication action Send is about to start
    $display("Starting %m.Send @ %d", $time);
	if(sel==1)
		begin
			fork;
			r1.Send(sel);
			r2.Send(SendValue[2*WIDTH-1:WIDTH]);
			join;
			sel=2;
		end
	else
		begin
			fork;
			r1.Send(sel);
			r3.Send(SendValue[WIDTH-1:0]);
			join;
			sel=1;
		end
    //Communication action Send is finished
    $display("Finished %m.Send @ %d", $time);
  end
endmodule
module data_bucket (interface r);
  parameter WIDTH = 8;
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
module merge (interface inPort1,interface inPort2,interface controlPort, interface right);
  parameter FL = 2;
  parameter BL = 4;
  parameter WIDTH = 8;
  logic [WIDTH-1:0] data;
  logic [1:0] c;


  always
  begin
	controlPort.Receive(c);
	#FL;
	if(c==1)
		begin
			inPort1.Receive(data);
			#FL;
			right.Send(data);
			#BL;
		end
	else if(c==2)
		begin
			inPort2.Receive(data);
			#FL;
			right.Send(data);
			#BL;
		end
		
  end
endmodule

module merge_test;


  //Interface Vector instatiation: 4-phase bundled data channel
  Channel #(.WIDTH(8),.hsProtocol(P4PhaseBD)) intf  [3:0] (); 
  
  //instantiate test circuit
  
  data_generator  #(.WIDTH(8)) dg(intf[0],intf[1],intf[2]);
  merge #(.WIDTH(8), .FL(2), .BL(8)) cp(intf[1], intf[2],intf[0],intf[3]);


  data_bucket #(.WIDTH(8)) db(intf[3]);

  initial 
     #40 $stop;

endmodule