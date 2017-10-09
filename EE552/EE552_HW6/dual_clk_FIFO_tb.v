module tb_empty;
	reg wen;
	reg ren;
	reg rclk=0;
	reg wclk=0;
	reg reset=0;
	reg [7:0] data_in=0;
	wire [7:0] data_out;
	dual_clk_FIFO fifo(rclk, wclk, reset, wen,ren, data_in, empty_bar, full_bar, data_out);
	
	
	always
		begin
		if($time<1000)
			#5 wclk = ~wclk;
		else
			#2.5 wclk = ~wclk;
		end
	always
	begin
		if($time<1000)
			#2 rclk = ~rclk;
		else
			#10 rclk = ~rclk;
	end
	always @(posedge wclk)
		begin
			if(full_bar)
			begin 
				data_in=data_in+1;
				wen=1;
			end
			else wen=0;
		end
	always @(posedge rclk)
		begin
			if(empty_bar) ren=1;
			else ren=0;
		end
	
endmodule
		
		