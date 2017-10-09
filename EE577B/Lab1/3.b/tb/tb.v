/////////////////////////////////////////////////////////////////
//       testbench: tb.v
/////////////////////////////////////////////////////////////////
`timescale 1ns/10ps
module tb;

reg  in1;
reg  in2;
wire #10 out0 = in1&in2;
wire out1;
assign #10 out1 = in1 & in2;
wire #10 out2;
assign out2 = in1 & in2;
initial
begin
in1=0;in2=0;
#20;
in1=1;in2=1;
#40;
in1=0;in2=1;
#20;
in1=1;in2=1;
#5;
in1=0;in2=1;
#20;
end
endmodule
