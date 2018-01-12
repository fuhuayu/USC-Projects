`timescale 1ns/1ns
import SystemVerilogCSP::*;
module ArbiterMerge_tb;
  Channel #(.WIDTH(8),.hsProtocol(P4PhaseBD)) intf  [2:0] ();
  data_generator g1(intf[0]);
  data_generator g2(intf[1]);
  ArbiterMerge M(intf[0],intf[1],intf[2]);
  data_bucket db(intf[2]);
endmodule // ArbiterMergb
