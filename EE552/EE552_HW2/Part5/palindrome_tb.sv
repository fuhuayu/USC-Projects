//Written by MehrdadNajibi 
////SystemVerilogCSP Interfaces based on Bundled Data Handshaking Protocols
//EE552, Department of Electrical Engineering
//University of Southern California
//Spring 2011
//Version 1.00

`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;


module tb_palindrome;

Channel #(.hsProtocol(P4PhaseBD),.WIDTH(4))  H();
Channel #(.hsProtocol(P4PhaseBD), .WIDTH(1)) P();
Channel #(.hsProtocol(P4PhaseBD), .WIDTH(1)) S();

logic p;
palindrome #(4) pTester (.H(H),.P(P),.S(S));
integer fp;

initial
begin
  fp = $fopen("Palindrome.dump","w");
  
  P.Receive(p);
  
  #1; fork H.Send(4'h4);P.Receive(p);S.Send(1); join
  $fdisplay(fp, "4 p=%d",p);

  #1; fork H.Send(4'ha);P.Receive(p);S.Send(0); join
  $fdisplay(fp, "4a p=%d",p);

  #1; fork H.Send(4'ha);P.Receive(p);S.Send(0); join
  $fdisplay(fp, "4aa p=%d",p);

  #1; fork H.Send(4'h4);P.Receive(p);S.Send(0); join
  $fdisplay(fp, "4aa4 p=%d",p);

  #1; fork H.Send(4'hb);P.Receive(p);S.Send(0);join
  $fdisplay(fp, "4aa4b p=%d",p);

  #1; fork H.Send(4'ha);P.Receive(p);S.Send(1);join
  $fdisplay(fp, "a p=%d",p);

  #1; fork H.Send(4'hb);P.Receive(p);S.Send(0);join
  $fdisplay(fp, "ab p=%d",p);

  #1; fork H.Send(4'h0);P.Receive(p);S.Send(0);join
  $fdisplay(fp, "ab0 p=%d",p);

  #1; fork H.Send(4'ha);P.Receive(p);S.Send(0);join
  $fdisplay(fp, "ab0a p=%d",p);

  #1; fork H.Send(4'h0);P.Receive(p);S.Send(0);join
  $fdisplay(fp, "ab0a0 p=%d",p);

  #1; fork H.Send(4'hb);P.Receive(p);S.Send(0);join
  $fdisplay(fp, "ab0a0b p=%d",p);

  #1; fork H.Send(4'ha);P.Receive(p);S.Send(0); join
  $fdisplay(fp, "ab0a0ba p=%d",p);

  #1; fork H.Send(4'ha);P.Receive(p);S.Send(1);join
  $fdisplay(fp, "a p=%d",p);

  #1; fork H.Send(4'ha);P.Receive(p);S.Send(0);join
  $fdisplay(fp, "aa p=%d",p);

  #1; fork H.Send(4'ha);P.Receive(p);S.Send(0);join
  $fdisplay(fp, "aaa p=%d",p);

end

endmodule  
