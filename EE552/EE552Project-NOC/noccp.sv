`timescale 1ns/1ns
import SystemVerilogCSP::*;
module NOC;
  parameter FL = 2;
  parameter BL = 4;
  parameter WIDTH = 4;
  parameter addrWIDTH = 4;
  Channel #(.WIDTH(WIDTH+addrWIDTH),.hsProtocol(P4PhaseBD)) intf  [61:0] ();

  Router #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router14(intf[0],intf[1],intf[2],intf[3],intf[4],intf[5]);

  Router #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router12(intf[2],intf[3],intf[6],intf[7],intf[8],intf[9]);
  Router #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router13(intf[4],intf[5],intf[10],intf[11],intf[12],intf[13]);

  Router #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router8(intf[6],intf[7],intf[14],intf[15],intf[16],intf[17]);
  Router #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router9(intf[8],intf[9],intf[18],intf[19],intf[20],intf[21]);
  Router #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router10(intf[10],intf[11],intf[22],intf[23],intf[24],intf[25]);
  Router #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router11(intf[12],intf[13],intf[26],intf[27],intf[28],intf[29]);

  Router #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router0(intf[14],intf[15],intf[30],intf[31],intf[32],intf[33]);
  Router #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router1(intf[16],intf[17],intf[34],intf[35],intf[36],intf[37]);
  Router #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router2(intf[18],intf[19],intf[38],intf[39],intf[40],intf[41]);
  Router #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router3(intf[20],intf[21],intf[42],intf[43],intf[44],intf[45]);
  Router #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router4(intf[22],intf[23],intf[46],intf[47],intf[48],intf[49]);
  Router #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router5(intf[24],intf[25],intf[50],intf[51],intf[52],intf[53]);
  Router #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router6(intf[26],intf[27],intf[54],intf[55],intf[56],intf[57]);
  Router #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) router7(intf[28],intf[29],intf[58],intf[59],intf[60],intf[61]);
  genvar i;
  generate
  for(i=30;i<62;i=i+2)
    Client #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH),.FL(FL),.ADDR((i-30)/2)) client(intf[i],intf[i+1]);
  endgenerate
endmodule //NOC
