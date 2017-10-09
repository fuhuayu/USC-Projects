 `timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

module data_generator (interface state,interface in);
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  logic [1:0] s;
  logic i;
  logic [2:0] n=0;
  always
  begin 
    //add a display here to see when this module starts its main loop
    s=n[2:1];
	i=n[0];
	n<=n+1;
    #FL;
     
    //Communication action Send is about to start
    $display("Starting %m.Send @ %d", $time);
	fork
    state.Send(s);
	in.Send(i);
	join
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

module output_function_logic_tb;


  //Interface Vector instatiation: 4-phase bundled data channel
  Channel #(.WIDTH(2),.hsProtocol(P4PhaseBD)) intf  [2:0] (); 
  
  //instantiate test circuit
  
  data_generator  #(.WIDTH(2)) dg(intf[0],intf[1]);
  
  output_function_logic #(.WIDTH(2), .FL(2), .BL(8)) of(intf[0], intf[1],intf[2]);


  data_bucket #(.WIDTH(2)) db(intf[2]);

  

endmodule