module mult (a,b,out); 
input [1:0] a;
input [1:0] b;
output [3:0] out;	
wire w1,w2,w3,w4;
andgate a1(a[0],b[0],out[0]);
andgate a2(a[1],b[0],w1);
andgate a3(a[0],b[1],w2);
andgate a4(a[1],b[1],w3);
xorgate x1(w1,w2,out[1]);
andgate a5(w1,w2,w4);
xorgate	x2(w4,w3,out[2]);
andgate a6(w4,w3,out[3]);
endmodule