`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;
module data_generatorA (interface r);
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  logic [WIDTH-1:0] SendValue=0;
  always
  begin 
    SendValue = 8'b00110010;
    #FL;
    r.Send(SendValue);
  end
endmodule
module data_generatorB (interface r);
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  logic [WIDTH-1:0] SendValue=0;
  always
  begin 
    SendValue = 8'b00011110;
    #FL;
    r.Send(SendValue);
  end
endmodule
module merge (interface a, interface b, interface c, interface d);
  parameter FL = 2;
  parameter BL = 8;
  parameter WIDTH = 8;
  logic [WIDTH-1:0] data;
  logic [1:0] data2;
  always
	begin
	 c.Receive(data2);
	 if (data2==2'b01)
	begin 	 
	 a.Receive(data);
	 #FL;
	end
	if (data2==2'b10)
	 begin
	 b.Receive (data);
	 #FL;
	 end
	 d.Send(data);
	 #BL;
	 end
endmodule
module split (interface left, interface sel, interface right1, interface right2);
  parameter FL = 2;
  parameter BL = 8;
  parameter WIDTH = 8;
  logic [WIDTH-1:0] data;
  logic [1:0] data2;
  always
  begin
  left.Receive(data);
  sel.Receive(data2);
  if (data2==2'b01)
  right1.Send(data);
  if (data2==2'b10)
  right2.Send(data);
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
	$display("*** %m %d",$time); 
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
module copy (interface left, interface right1, interface right2);
  parameter FL = 2;
  parameter BL = 8;
  parameter WIDTH = 8;
  logic [WIDTH-1:0] data;
  always
  begin
    left.Receive(data);
    #FL; //Forward Latency: Delay from recieving inputs to send the results forward
	fork
    right1.Send(data);
	right2.Send(data);
	join    
	#BL;//Backward Latency: Delay from the time data is delivered to the time next input can be accepted
  end
endmodule

module copy4 (interface left, interface right1, interface right2,interface right3, interface right4);
  parameter FL = 2;
  parameter BL = 8;
  parameter WIDTH = 8;
  logic [WIDTH-1:0] data;
  always
  begin
    left.Receive(data);
    #FL; //Forward Latency: Delay from recieving inputs to send the results forward
	fork
    right1.Send(data);
	right2.Send(data);
	right3.Send(data);
	right4.Send(data);
	join    
	#BL;//Backward Latency: Delay from the time data is delivered to the time next input can be accepted
  end
endmodule
module compare (interface a, interface b, interface c);
  parameter FL = 2;
  parameter BL = 8;
  parameter WIDTH = 8;
  logic [WIDTH-1:0] A;
  logic [WIDTH-1:0] B;
  logic [1:0] data2;
  always
	begin
		a.Receive(A);
		b.Receive(B);
		if (A!=B)
		begin
		data2=2'b10;
		c.Send (data2);
		end
		if (A==B)
		begin
		data2=2'b01;
		c.Send (data2);
		end
	end
endmodule
module token_buffer (interface left, interface right);
  parameter FL = 2;
  parameter BL = 8;
  parameter WIDTH = 8;
  parameter init = 2'b01;
  logic [WIDTH-1:0] data;
  initial
  begin
  right.Send(init);
  end
	always
	begin
		left.Receive(data);

		#FL; //Forward Latency: Delay from recieving inputs to send the results forward

		right.Send(data);

		#BL;//Backward Latency: Delay from the time data is delivered to the time next input can be accepted
	end
endmodule
module larger (interface B, interface A, interface result);
  parameter FL = 2;
  parameter BL = 8;
  parameter WIDTH = 8;
  logic [WIDTH-1:0] a;
  logic [WIDTH-1:0] b;
  logic [1:0] data2;
  always
  begin
  A.Receive(a);
  B.Receive(b);
  if (a>b)
  begin
  data2=2'b01;
  result.Send(data2);
  end
  if (a<b)
  begin
  data2=2'b10;
  result.Send(data2);
  end
  end
 endmodule
module sub (interface left1, interface left2, interface right);
  parameter FL = 2;
  parameter BL = 8;
  parameter WIDTH = 8;
  logic [WIDTH-1:0] data1;
  logic [WIDTH-1:0] data2;
  logic [WIDTH-1:0] data;
  always
  begin
		fork
		left1.Receive(data1);
		left2.Receive(data2);
		join
		#FL;
		data = data1-data2;
		right.Send(data);
		#BL;
	end
endmodule
module mux (interface left1, interface left2, interface sel, interface right);
  parameter FL = 2;
  parameter BL = 8;
  parameter WIDTH = 8;
  logic [WIDTH-1:0] data1;
  logic [WIDTH-1:0] data2;
  logic [1:0] data3;
  always
  begin
  left1.Receive(data1);
  left2.Receive(data2);
  sel.Receive(data3);
  if (data3==2'b10)
  right.Send(data1);
  if (data3==2'b01)
  right.Send(data2);
  end
  endmodule
module prob7;


  //Interface Vector instatiation: 4-phase bundled data channel
  Channel #(.hsProtocol(P4PhaseBD)) intf  [34:0] (); 
  data_generatorA  #(.WIDTH(8)) dg1(intf[0]);
  data_generatorB  dg2(intf[5]);
  merge m1(intf[0],intf[33],intf[14], intf[34]);
  merge m2(intf[5],intf[32],intf[13],intf[24]);
  split s1(intf[1],intf[12],intf[2],intf[3]);
  split s2(intf[6],intf[11],intf[15],intf[16]);
  data_bucket db1(intf[2]);
  data_bucket db2(intf[15]);
  copy c1(intf[24],intf[6],intf[7]);
  copy c2(intf[8],intf[9],intf[10]);
  copy c3(intf[25],intf[13],intf[14]);
  copy4 c4(intf[16],intf[17],intf[20],intf[22],intf[30]);
  copy4 c5(intf[3],intf[18],intf[21],intf[28],intf[29]);
  copy c6(intf[19],intf[26],intf[27]);
  copy c7(intf[10],intf[11],intf[12]);
  copy c8(intf[34],intf[1],intf[4]);
  compare cp(intf[4],intf[7],intf[8]);
  token_buffer tb(intf[9],intf[25]);
  larger lg(intf[17],intf[18],intf[19]);
  sub sb1(intf[20],intf[21],intf[23]);
  sub sb2(intf[29],intf[30],intf[31]);
  mux mx1(intf[23],intf[22],intf[26],intf[32]);
  mux mx2(intf[28],intf[31],intf[27],intf[33]);
  
  
 

endmodule