/////////////////////////////////////////////////////////////////
//       testbench: tb.v
/////////////////////////////////////////////////////////////////
`timescale 1ns/10ps
module tb;
wire AND1, AND2, AND3, AND4, AND5;
reg  A_in;
reg  B_in;
andmodule And(A_in,B_in,AND1, AND2, AND3, AND4, AND5);
initial
begin
A_in=0; B_in=0;
#4;
A_in=1; B_in=1;
#3;
A_in=1; B_in=0;
#3;
A_in=1; B_in=1;
#1;
A_in=0; B_in=1;
#6;
end
endmodule
