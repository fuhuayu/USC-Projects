/////////////////////////////////////////////////////////////////
//       testbench: tb.v
/////////////////////////////////////////////////////////////////
`timescale 1ns/10ps
module tb;
//------------Output Ports--------------
wire[35:0] out;
//------------Input Ports---------------
reg[31:0]  in;
reg  clk;
reg  rst;
integer file;
//-------------------------------------
CRC crc(in,clk,rst,out);
initial
begin
file = $fopen("CRC.out");
clk=0;
rst=1;
#8;
rst=0;
in=32'h12345678;
#4;
in=32'h87654321;
#4;
in=32'hABCDEF12;
#4;
$fclose(file);
$finish;
end
always @ ( posedge clk ) begin
#0.1;
$fdisplay(file, "At time %f ns, rst=%d, in=%b, out=%b", $realtime, rst, in, out);
end
always
  #2 clk=~clk;
endmodule
