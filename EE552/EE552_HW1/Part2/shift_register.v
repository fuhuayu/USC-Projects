`define Load  0
`define RotateLeft 1 
`define RotateRight  2
`define ShiftRight 3 
module shift_register (clk, cmd, par_in, ser_in, data_out,rst);
parameter WIDTH = 8;
	input clk, ser_in, rst;
	input [1:0] cmd;
	input [WIDTH-1:0] par_in;   
	output [WIDTH-1:0]  data_out;
	reg [WIDTH-1:0]  reg1;
always @(posedge clk or posedge rst)
	begin
	if(rst==1'b1)
		reg1<=8'h00;
	else
	begin
		if (cmd == `Load)
			reg1<=par_in;
		else if(cmd == `RotateLeft)
			reg1<={reg1[WIDTH-2:0],reg1[WIDTH-1]};
		else if (cmd == `RotateRight)
			reg1<={reg1[0],reg1[WIDTH-1:1]};
		else if(cmd == `ShiftRight)
			reg1<={ser_in,reg1[WIDTH-1:1]};
	end
	
	end
assign data_out=reg1;
endmodule