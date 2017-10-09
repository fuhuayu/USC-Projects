// Copyright (c) 2017, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Created by Humei Cheng on 02/07/2017
// This is a structural 16-bit adder using NCSU 45nm (free pdk)

module adder16bit ( a, b, cin, s, cout );
  input [15:0] a;
  input [15:0] b;
  output [15:0] s;
  input cin;
  output cout;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15;

  FAX1 U1 ( .A(a[15]), .B(b[15]), .C(n1), .YC(cout), .YS(s[15]) );
  FAX1 U2 ( .A(a[14]), .B(b[14]), .C(n2), .YC(n1), .YS(s[14]) );
  FAX1 U3 ( .A(a[13]), .B(b[13]), .C(n3), .YC(n2), .YS(s[13]) );
  FAX1 U4 ( .A(a[12]), .B(b[12]), .C(n4), .YC(n3), .YS(s[12]) );
  FAX1 U5 ( .A(a[11]), .B(b[11]), .C(n5), .YC(n4), .YS(s[11]) );
  FAX1 U6 ( .A(a[10]), .B(b[10]), .C(n6), .YC(n5), .YS(s[10]) );
  FAX1 U7 ( .A(a[9]), .B(b[9]), .C(n7), .YC(n6), .YS(s[9]) );
  FAX1 U8 ( .A(a[8]), .B(b[8]), .C(n8), .YC(n7), .YS(s[8]) );
  FAX1 U9 ( .A(a[7]), .B(b[7]), .C(n9), .YC(n8), .YS(s[7]) );
  FAX1 U10 ( .A(a[6]), .B(b[6]), .C(n10), .YC(n9), .YS(s[6]) );
  FAX1 U11 ( .A(a[5]), .B(b[5]), .C(n11), .YC(n10), .YS(s[5]) );
  FAX1 U12 ( .A(a[4]), .B(b[4]), .C(n12), .YC(n11), .YS(s[4]) );
  FAX1 U13 ( .A(a[3]), .B(b[3]), .C(n13), .YC(n12), .YS(s[3]) );
  FAX1 U14 ( .A(a[2]), .B(b[2]), .C(n14), .YC(n13), .YS(s[2]) );
  FAX1 U15 ( .A(a[1]), .B(b[1]), .C(n15), .YC(n14), .YS(s[1]) );
  FAX1 U16 ( .A(b[0]), .B(cin), .C(a[0]), .YC(n15), .YS(s[0]) );
endmodule

