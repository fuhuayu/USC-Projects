`timescale 1ns/1ns
import SystemVerilogCSP::*;
module NOC;
  parameter FL = 4;
  parameter BL = 2;
  parameter WIDTH = 8;
  parameter addrWIDTH = 8;
  parameter TOP = 0;
  Channel #(.WIDTH(WIDTH+addrWIDTH),.hsProtocol(P4PhaseBD)) intf  [61:0] ();
  integer r[60:0];
  integer s[60:0];
  Router #(.TOP(1),.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router14(intf[0],intf[1],intf[2],intf[3],intf[4],intf[5]);

  Router #(.TOP(TOP),.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router12(intf[2],intf[3],intf[6],intf[7],intf[8],intf[9]);
  Router #(.TOP(TOP),.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router13(intf[4],intf[5],intf[10],intf[11],intf[12],intf[13]);

  Router #(.TOP(TOP),.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router8(intf[6],intf[7],intf[14],intf[15],intf[16],intf[17]);
  Router #(.TOP(TOP),.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router9(intf[8],intf[9],intf[18],intf[19],intf[20],intf[21]);
  Router #(.TOP(TOP),.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router10(intf[10],intf[11],intf[22],intf[23],intf[24],intf[25]);
  Router #(.TOP(TOP),.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router11(intf[12],intf[13],intf[26],intf[27],intf[28],intf[29]);

  Router #(.TOP(TOP),.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router0(intf[14],intf[15],intf[30],intf[31],intf[32],intf[33]);
  Router #(.TOP(TOP),.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router1(intf[16],intf[17],intf[34],intf[35],intf[36],intf[37]);
  Router #(.TOP(TOP),.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router2(intf[18],intf[19],intf[38],intf[39],intf[40],intf[41]);
  Router #(.TOP(TOP),.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router3(intf[20],intf[21],intf[42],intf[43],intf[44],intf[45]);
  Router #(.TOP(TOP),.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router4(intf[22],intf[23],intf[46],intf[47],intf[48],intf[49]);
  Router #(.TOP(TOP),.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router5(intf[24],intf[25],intf[50],intf[51],intf[52],intf[53]);
  Router #(.TOP(TOP),.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router6(intf[26],intf[27],intf[54],intf[55],intf[56],intf[57]);
  Router #(.TOP(TOP),.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router7(intf[28],intf[29],intf[58],intf[59],intf[60],intf[61]);
  genvar i;
  generate
  for(i=30;i<62;i=i+2)
    Client #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH),.FL(FL),.ADDR((i-30)/2)) client(intf[i],intf[i+1],s[i],r[i]);
  endgenerate
  Calc c(s[30],s[32],s[34],s[36],s[38],s[40],s[42],s[44],s[46],s[48],s[50],s[52],s[54],s[56],s[58],s[60],
    r[30],r[32],r[34],r[36],r[38],r[40],r[42],r[44],r[46],r[48],r[50],r[52],r[54],r[56],r[58],r[60]);
endmodule //NOC
