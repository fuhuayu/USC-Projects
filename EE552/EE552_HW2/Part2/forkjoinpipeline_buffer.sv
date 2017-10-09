`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

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

module add (interface left1,interface left2, interface right);
  parameter FL = 2;
  parameter BL = 4;
  parameter WIDTH = 8;
  logic [WIDTH-2:0] a;
  logic [WIDTH-4:0] b;
  logic [WIDTH-1:0] ndata;
  always
  begin
    //add a display here to see when this module starts its main loop
    fork
    left1.Receive(a);
	left2.Receive(b);
	join
	ndata=a+b;
    #FL; //Forward Latency: Delay from recieving inputs to send the results forward
    right.Send(ndata);
    #BL;//Backward Latency: Delay from the time data is delivered to the time next input can be accepted
  end
endmodule

module copy (interface left,interface right1, interface right2);
  parameter FL = 2;
  parameter BL = 4;
  parameter WIDTH = 8;
  logic [WIDTH-1:0] data;

  always
  begin
    //add a display here to see when this module starts its main loop
    left.Receive(data);
    #FL; //Forward Latency: Delay from recieving inputs to send the results forward
    fork
	right1.Send(data);
	right2.Send(data);
	join
    #BL;//Backward Latency: Delay from the time data is delivered to the time next input can be accepted
  end
endmodule

module shift (interface left, interface right);
  parameter FL = 2;
  parameter BL = 4;
  parameter WIDTH = 8;
  logic [WIDTH-1:0] data;
  logic [WIDTH:0] ndata;
  always
  begin
    //add a display here to see when this module starts its main loop
    
    left.Receive(data);
	ndata=data<<1;
    #FL; //Forward Latency: Delay from recieving inputs to send the results forward
    right.Send(ndata);
    #BL;//Backward Latency: Delay from the time data is delivered to the time next input can be accepted
  end
endmodule
module buffer (interface left, interface right);
  parameter FL = 2;
  parameter BL = 4;
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
module fork_join_pipeline;


  //Interface Vector instatiation: 4-phase bundled data channel
  Channel #(.WIDTH(12),.hsProtocol(P4PhaseBD)) intf  [9:0] (); 
  
  //instantiate test circuit
  
  data_generator  #(.WIDTH(8)) dg(intf[0]);
  copy #(.WIDTH(8), .FL(2), .BL(4)) cp(intf[0], intf[1],intf[2]);
  shift #(.WIDTH(8), .FL(2), .BL(4)) s0(intf[1], intf[3]);
  shift #(.WIDTH(9), .FL(2), .BL(4)) s1(intf[3], intf[4]);
  shift #(.WIDTH(10), .FL(2), .BL(4)) s2(intf[4], intf[5]);
  shift #(.WIDTH(8), .FL(2), .BL(4)) s3(intf[2], intf[6]);
  buffer #(.WIDTH(9), .FL(2), .BL(4)) b0(intf[6], intf[7]);
  buffer #(.WIDTH(9), .FL(2), .BL(4)) b1(intf[7], intf[8]);
  add #(.WIDTH(12), .FL(2), .BL(4)) add1(intf[5], intf[8],intf[9]);


  data_bucket #(.WIDTH(12)) db(intf[9]);

  initial 
     #40 $stop;

endmodule