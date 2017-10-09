`timescale 1ns/1fs
import SystemVerilogCSP::*;
module PipelineArbiter (interface R1, interface R2, interface W1);
	logic d;
  always begin
		forever begin
	    wait((R1.status != idle)||(R2.status != idle));
	    if ((R1.status != idle) && (R2.status != idle)) begin
	      if ({$random}%2==0) begin                     // Both ports have tokens: select randomly
	        R1.Receive(d);  W1.Send(0);
	      end
	      else  begin
	        R2.Receive(d);  W1.Send(1);
	      end
	    end
	    else if (R1.status != idle) begin  // Only R1 has a token
	      R1.Receive(d);  W1.Send(0);
	      end
	    else begin // Only R2 has a token
	      R2.Receive(d);  W1.Send(1);
	    end
		end
  end
endmodule


module merge (interface inPort1,interface inPort2,interface controlPort, interface right);
  parameter FL = 2;
  parameter BL = 4;
  parameter WIDTH = 8;
  logic [WIDTH-1:0] data;
  logic c;


  always begin
		forever begin
			controlPort.Receive(c);
			if(c==0)
				begin
					inPort1.Receive(data);
					right.Send(data);
				end
			else if(c==1)
				begin
					inPort2.Receive(data);
					right.Send(data);
				end
		end
  end
endmodule
module ArbiterMerge (interface A_req,interface B_req,interface A_data, interface B_data,interface C_data);
  parameter FL = 2;
  parameter BL = 4;
  parameter WIDTH = 8;
  Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) W ();
  PipelineArbiter  PA(A_req, B_req,W);
  merge #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) M(A_data, B_data,W,C_data);
endmodule
