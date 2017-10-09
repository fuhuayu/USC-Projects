`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;
module state_memory (interface left, interface right);
  parameter FL = 2;
  parameter BL = 4;
  parameter WIDTH = 8;
  logic [WIDTH-1:0] data=0;
  always
  begin
    //add a display here to see when this module starts its main loop
    
    right.Send(data);
    #BL;//Backward Latency: Delay from the time data is delivered to the time next input can be accepted
	left.Receive(data);
    #FL; //Forward Latency: Delay from recieving inputs to send the results forward
  end
endmodule