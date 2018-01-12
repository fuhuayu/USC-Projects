`timescale 1ns/1ns
import SystemVerilogCSP::*;
module Router_tb;
  Channel #(.WIDTH(8),.hsProtocol(P4PhaseBD)) intf  [5:0] ();
  Client #(.WIDTH(8),.addrWIDTH(4),.FL(2),.ADDR(4'b0000)) c0(intf[0],intf[1]);
  Client #(.WIDTH(8),.addrWIDTH(4),.FL(2),.ADDR(4'b0001)) c1(intf[2],intf[3]);
  Client #(.WIDTH(8),.addrWIDTH(4),.FL(2),.ADDR(4'b0010)) c2(intf[4],intf[5]);
  Router #(.WIDTH(8), .FL(2), .BL(4)) router(intf[4],intf[5],intf[0],intf[1],intf[2],intf[3]);
endmodule // Router_tb
