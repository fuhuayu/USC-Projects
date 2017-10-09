/////////////////////////////////////////////////////////////////
//       testbench: tb.v
/////////////////////////////////////////////////////////////////
`timescale 1ns/10ps
module tb;
reg in;
reg a,b,c,d,e,f;
initial
begin
in=0;
#2;
in=1;
#3;
in=0;
#5;
in=1;
#5;
in=0;
#15;
end
always@(*)
begin
a = in;
b<=in;
c=#4in;
d<=#4in;
#4 e = in;
#4 f <= in;
end
endmodule
