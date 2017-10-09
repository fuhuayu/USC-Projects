 `timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;
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