/////////////////////////////////////////////////////////////////
//       testbench: tb.v
/////////////////////////////////////////////////////////////////
`timescale 1ns/10ps
module tb;
//------------Output Ports--------------
wire match;
//------------Input Ports---------------
reg  in;
reg  clk;
reg  rst;
integer file;
//-------------------------------------
seq_detect fsm(in, clk, rst, match);
initial
begin
file = $fopen("seq_detec.out");
clk=0;
rst=1;
#12.5;
rst=0;
in=1;
#2.5;
in=0;
#2.5;
in=1;
#2.5;
in=0;
#2.5;
in=1;
#2.5;
in=1;
#2.5;
in=1;
#2.5;
in=0;
#2.5;
in=1;
#2.5;
in=1;
#2.5;
in=1;
#2.5;
in=0;
#2.5;
in=1;
#2.5;
in=1;
#2.5;
in=1;
#2.5;
in=0;
#2.5;
in=0;
#2.5;
in=1;
#2.5;
in=1;
#2.5;
$fclose(file);
   $finish;
end
always @ ( posedge clk ) begin
#0.1;
$fdisplay(file, "At time %f ns, rst=%d, clk=%d, in=%d, match=%d", $realtime, rst, clk, in, match);
end
always
  #1.25 clk=~clk;
endmodule
