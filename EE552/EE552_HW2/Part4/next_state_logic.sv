 `timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;
module next_state_logic (interface state,interface in, interface nstate);
  parameter FL = 2;
  parameter BL = 4;
  parameter WIDTH = 8;
  logic [1:0] s,ns;
  logic i;
  always
  begin
    //add a display here to see when this module starts its main loop
    fork
    state.Receive(s);
	in.Receive(i);
	join
	case(s)
		0:	begin
				if(i==1) ns=1;
				else ns=s;
			end
		1:	begin
				if(i==0) ns=2;
				else ns=s;
			end
		2:	begin
				if(i==1) ns=3;
				else ns=0;
			end
		3:	begin
				if(i==1) ns=1;
				else ns=2;
			end
	endcase
	#FL; 
    nstate.Send(ns);
    #BL;
  end
endmodule