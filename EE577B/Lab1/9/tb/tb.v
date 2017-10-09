/////////////////////////////////////////////////////////////////
//       testbench: tb.v
/////////////////////////////////////////////////////////////////
`timescale 1ns/10ps
module tb;
//------------Output Ports--------------
wire t_clk1,t_clk2,t_clk3,t_clk4;
//------------Input Ports---------------
reg clk1,clk2,clk3,clk4;
reg[1:0]  t_sel;
//-------------------------------------
CLK_MUX clkmux(t_sel,clk1,clk2,clk3,clk4,t_clk1,t_clk2,t_clk3,t_clk4);
initial
begin
clk1=0;
clk2=0;
clk3=0;
clk4=0;
t_sel=0;
#50;
t_sel=1;
#50;
t_sel=2;
#50;
t_sel=3;
#50;
$stop;
end

always  #10 clk1=~clk1;
always  #6.25 clk2=~clk2;
always  #2.17 clk3=~clk3;
always  #1 clk4=~clk4;
endmodule
