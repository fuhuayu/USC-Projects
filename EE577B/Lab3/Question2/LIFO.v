module lifo(push, pop, reset, clk,din, empty, full, dout);
parameter DEPTH_P2=8;
parameter WIDTH=16;
input push, pop, reset, clk;
input[WIDTH-1:0] din;
output reg empty;
output wire full;
output reg[WIDTH-1:0] dout;
reg [WIDTH-1:0] mem [2**(DEPTH_P2)-1:0];
reg[DEPTH_P2-1:0] ptr;
wire we,re;
assign we=(~full)&push&(~pop);
assign re=(~empty)&(~push)&(pop);
always@(posedge clk)
begin
	if(reset) begin
		ptr<=0;
		empty<=1;
	end
	else begin
		if(we) begin
			if(empty) begin
				mem[ptr]<=din;
				empty<=0;
			end
			else begin
				mem[ptr+1]<=din;
				ptr<=ptr+1;
			end
		end
		if(re) begin
			dout<=mem[ptr];
			if(ptr==0) empty<=1;
			else ptr<=ptr-1;
		end
	end
end
assign full=ptr==((2**DEPTH_P2)-1);
endmodule




