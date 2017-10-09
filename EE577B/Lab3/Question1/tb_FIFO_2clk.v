module tb;
	parameter DEPTH = 4; 
	parameter WIDTH = 16;
	reg wen;
	reg ren;
	reg rclk=0;
	reg wclk=0;
	reg reset=0;
	reg [WIDTH-1:0] data_in=0;
	wire [WIDTH-1:0] data_out;
	dual_clk_FIFO #(DEPTH,WIDTH) fifo(rclk, wclk, reset, wen,ren, data_in, empty_bar, full_bar, data_out);
	
	
	always
		begin
			#25 wclk = ~wclk;
		end
	always
	begin
		#5 rclk = ~rclk;
	end
	always @(negedge wclk)
		begin
			if(full_bar)
			begin 
				data_in=data_in+1;
				wen=1;
			end
			else wen=0;
		end
	always @(negedge rclk)
		begin
			if(empty_bar) ren=1;
			else ren=0;
		end
	
endmodule
		
		