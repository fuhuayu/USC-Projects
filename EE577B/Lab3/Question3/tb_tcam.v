module tb;
	reg clk=0;
	reg reset=0,EN=0,WE=0;
	reg [15:0] DIN=0;
	wire [2:0] match_addr;
	wire match;
	integer counter,c1=0;
	TCAM tcam(reset, clk, DIN, EN, WE, match, match_addr); 
	initial begin
		reset=1;
		#10;
		reset=0;
		counter=16'b1010101011000000;
	end
	always
	begin
			#1 clk <= ~clk;
	end
	always @(negedge clk)
		begin
			c1<=c1+1;
			counter<=counter+16'b0000000100000001;
			DIN<=counter;
			if(c1<30) begin
				EN<=1;
				WE<=1;
			end
			else begin
				WE<=0;
				EN<=(c1%4==0)?0:1;
			end
		end

endmodule
		
		