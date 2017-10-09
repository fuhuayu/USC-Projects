/////////////////////////////////////////////////////////////////
//       testbench: tb.v
/////////////////////////////////////////////////////////////////
`timescale 1ns/100ps
module tb;
//------------Output Ports--------------
wire[3:0] grant_vector;
//------------Input Ports---------------
reg[3:0]  req_vector;
reg  clk;
reg  enable,reset;
//-------------------------------------
arbiter_LRU4 lru4(grant_vector, req_vector, enable , clk, reset);
initial
begin
clk=0;
reset=1;
enable=0;
req_vector=4'b1010;
#4;
reset=0;
enable=0;
req_vector=4'b1110;
#4;
reset=0;
enable=1;
req_vector=4'b1111;
#4;
reset=0;
enable=1;
req_vector=4'b1000;
#4;
reset=0;
enable=1;
req_vector=4'b1011;
#4;
reset=0;
enable=1;
req_vector=4'b0111;
#4;
reset=0;
enable=0;
req_vector=4'b1110;
#4;
reset=1;
enable=0;
req_vector=4'b1011;
#4;
reset=0;
enable=1;
req_vector=4'b1100;
#4;
reset=0;
enable=1;
req_vector=4'b1100;
#4;
reset=0;
enable=1;
req_vector=4'b1010;
#4;
reset=0;
enable=1;
req_vector=4'b1111;
#4;
reset=0;
enable=1;
req_vector=4'b1110;
#4;
   $finish;
end
always
  #2 clk=~clk;
endmodule
