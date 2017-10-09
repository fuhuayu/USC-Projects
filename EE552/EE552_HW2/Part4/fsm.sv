 `timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;
module fsm (interface in, interface out);
  Channel #(.WIDTH(2),.hsProtocol(P4PhaseBD)) intf  [5:0] (); 
  copy #(.WIDTH(2), .FL(2), .BL(8)) cpin(in, intf[0],intf[1]);
  state_memory #(.WIDTH(2), .FL(2), .BL(8)) sm(intf[2], intf[3]);
  copy #(.WIDTH(2), .FL(2), .BL(8)) cpst(intf[3], intf[4],intf[5]);
  output_function_logic #(.WIDTH(1), .FL(2), .BL(8)) of(intf[4],intf[0],out);
  next_state_logic #(.WIDTH(1), .FL(2), .BL(8)) ns(intf[5],intf[1],intf[2]);
  
endmodule