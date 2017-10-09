 `timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;
module output_function_logic (interface state,interface in, interface out);
  parameter FL = 2;
  parameter BL = 4;
  parameter WIDTH = 8;
  logic [1:0] s;
  logic i,o=0;
  always
  begin
    //add a display here to see when this module starts its main loop
    fork
    state.Receive(s);
	in.Receive(i);
	join
	case(s)
		3:	begin
				if(i==1) o=1;
			end
		default: o=0;
	endcase
    #FL; //Forward Latency: Delay from recieving inputs to send the results forward
    out.Send(o);
    #BL;//Backward Latency: Delay from the time data is delivered to the time next input can be accepted
  end
endmodule