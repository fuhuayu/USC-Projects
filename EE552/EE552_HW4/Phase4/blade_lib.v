// Copyright (c) 2014, University of Southern California, all rights reserved
// EE552 (Prof. Peter Beerel) - Spring2017 - Homework 4
// Created by Matheus Trevisan Moreira and Dylan Hand
// blade_lib.v

`timescale 1ns/10ps

primitive u_c2 (Q, A, B);

output Q;
input A, B;
reg Q;

table

//A	B	: Q	:Q+1
0	0	: ?	: 0 ;
1	1	: ?	: 1 ;
0	1	: ?	: - ; 
1	0	: ?	: - ;
?	X	: ?	: - ; 
X	?	: ?	: - ; 

endtable
endprimitive


primitive u_c1u2 (Q, A, B);

output Q;
input A, B;
reg Q;

table

//A	B	: Q	:Q+1
0	0	: ?	: 0 ;
1	1	: ?	: 1 ;
0	1	: ?	: - ; 
1	0	: ?	: 0 ;
?	X	: ?	: - ; 
X	1	: ?	: - ; 
?   0   : ? : 0 ;

endtable
endprimitive


primitive u_c3 (Q, A, B, C);

output Q;
input A, B, C;
reg Q;

table

//A	B	C	: Q	: Q+1
0	0	0	: ?	: 0 ;
0	0	1	: ?	: - ;
0	1	0	: ?	: - ;
0	1	1	: ?	: - ;
1	0	0	: ?	: - ;
1	0	1	: ?	: - ;
1	1	0	: ?	: - ;
1	1	1	: ?	: 1 ;
X	?	?	: ? : - ;
?	X	?	: ? : - ;
?	?	X	: ? : - ;

endtable
endprimitive




primitive u_c3u4 (Q, A, B, C, D);

output Q;
input A, B, C, D;
reg Q;

table

//A	B	C	D	: Q	: Q+1
0	0	0	0	: ?	: 0 ;
0	0	0	1	: ?	: - ;
0	0	1	0	: ?	: 0 ;
0	0	1	1	: ?	: 1 ;
0	1	0	0	: ?	: 0 ;
0	1	0	1	: ?	: 1 ;
0	1	1	0	: ?	: 0 ;
0	1	1	1	: ?	: 1 ;
1	0	0	0	: ?	: 0 ;
1	0	0	1	: ?	: 1 ;
1	0	1	0	: ?	: 0 ;
1	0	1	1	: ?	: 1 ;
1	1	0	0	: ?	: 0 ;
1	1	0	1	: ?	: 1 ;
1	1	1	0	: ?	: 0 ;
1	1	1	1	: ?	: 1 ;
X	?	?	1	: ? : - ;
?	X	?	1	: ? : - ;
?	?	X	1	: ? : - ;
?	?	?	X	: ? : - ;
?   ?   ?   0   : ? : 0 ;

endtable
endprimitive


primitive u_filterG0 (G0, R0, R1);

output G0;
input R0, R1;

table

//A	B	:Q+1
0	0	: 0 ;
0	1	: 0 ;
1	0	: 1 ;
1	1	: 0 ; 

endtable
endprimitive

primitive u_filterG1 (G1, R0, R1);

output G1;
input R0, R1;

table

//A	B	:Q+1
0	0	: 0 ;
0	1	: 1 ;
1	0	: 0 ;
1	1	: 0 ; 

endtable
endprimitive

`celldefine

module BLADE_CE1CK2X4 (O, A, CK);
input A, CK;
output O;
u_c1u2 i1 (qi, A, CK);
buf i2 (O, qi);
specify
        (posedge A => (O +: 1'b1)) = (0.05,0.05);
        (CK => O) = (0.05,0.05);
endspecify
endmodule
       
`endcelldefine

`celldefine

module BLADE_CE2X4 (O, A, B);
input A, B;
output O;
u_c2 i1 (qi, A, B);
buf i2 (O, qi);
specify
        (A => O) = (0.05,0.05);
        (B => O) = (0.05,0.05);
endspecify
endmodule
       
`endcelldefine

`celldefine

module BLADE_CE1CK4X4 (O, A, B, C, CK);
input A, B, C, CK;
output O;
u_c3u4 i1 (qi, A, B, C, CK);
buf i2 (O, qi);
specify
        (posedge A => (O +: 1'b1)) = (0.05,0.05);
        (posedge B => (O +: 1'b1)) = (0.05,0.05);
        (posedge C => (O +: 1'b1)) = (0.05,0.05);
        (CK => O) = (0.05,0.05);
endspecify
endmodule
       
`endcelldefine

`celldefine

module BLADE_CE3X4 (O, A, B, C);
input A, B, C;
output O;
u_c3 i1 (qi, A, B, C);
buf i2 (O, qi);
specify
        (A => O) = (0.05,0.05);
        (B => O) = (0.05,0.05);
        (C => O) = (0.05,0.05);
endspecify
endmodule
       
`endcelldefine

`celldefine

module BLADE_FILTER2X4 (G0, G1, R0, R1);
input R0, R1;
output G0, G1;
u_filterG0 i1 (G0, R0, R1);
u_filterG1 i2 (G1, R0, R1);
specify
(R0 => G0) = (0.05,0.05);
(R0 => G1) = (0.05,0.05);
(R1 => G0) = (0.05,0.05);
(R1 => G1) = (0.05,0.05);
endspecify
endmodule
       
`endcelldefine
