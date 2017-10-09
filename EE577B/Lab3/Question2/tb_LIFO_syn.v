module tb;
	parameter DEPTH = 3; 
	parameter WIDTH = 16;
	reg push=0,pop=0,clk=0;
	reg reset=0;
	reg [WIDTH-1:0] din=0;
	wire [WIDTH-1:0] dout;
	wire empty,full;
	integer counter=0;
	lifo #(DEPTH,WIDTH) fifo(push, pop, reset, clk,din, empty, full, dout);
	initial begin
		reset=1;
		#10;
		reset=0;
	end
	always
	begin
			#1 clk <= ~clk;
	end
	always @(negedge clk)
		begin
			counter<=counter+1;
			din<=counter;
			if(counter<30) begin
				push<=1;
			end
			else if(counter<40) pop<=1;
			else if(counter<60) push<=0;
			else begin
				pop<=~pop;
				push<=~push;
			end
		end

endmodule
		
		