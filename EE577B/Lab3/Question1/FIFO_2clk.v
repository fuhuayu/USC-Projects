module bin2gray (bin,gray);
	parameter SIZE = 5;
	input [SIZE-1:0] bin;
	output [SIZE-1:0] gray;
	reg [SIZE-1:0] gray;
	always @(bin)
		gray = (bin >> 1) ^ bin;
endmodule
module gray2bin (gray,bin);
	parameter SIZE = 5;
	input [SIZE-1:0] gray;
	output [SIZE-1:0] bin;
	reg [SIZE-1:0] bin;
	integer i;
	always @(gray)
		for (i=0; i<SIZE; i=i+1)
			bin[i] = ^(gray >> i);
endmodule

module dual_clk_FIFO (rclk, wclk, reset, put,get, data_in, empty_bar, full_bar, data_out);

parameter DEPTH = 5; 
parameter WIDTH = 8;

input [WIDTH-1:0] data_in;
input put, get;
input reset, rclk,wclk;

output [WIDTH-1:0] data_out;
output empty_bar, full_bar;
wire [WIDTH-1:0] data_out;
wire empty_bar, full_bar;
wire wr_en,rd_en;
wire [DEPTH-1:0] wr_ptr_ss_bin, rd_ptr_ss_bin,diff;
wire [DEPTH-1:0] wr_ptr_bin, rd_ptr_bin;
wire [DEPTH-1:0] old_wr_ptr_bin, old_rd_ptr_bin;
wire [DEPTH-1:0] old_wr_ptr_bin_p1, old_rd_ptr_bin_p1;
wire [DEPTH-1:0] wr_ptr_bin_p1, rd_ptr_bin_p1;
wire [DEPTH-1:0] wr_ptr_p1, rd_ptr_p1;
reg [DEPTH-1:0] wr_ptr=0, rd_ptr=0;
reg [WIDTH-1:0] mem [2**(DEPTH-1)-1:0];
reg [DEPTH-1:0] wr_ptr_s=0, rd_ptr_s=0;
reg [DEPTH-1:0] wr_ptr_ss=0, rd_ptr_ss=0;
reg FULL=0, EMPTY=1;
//pre_encoding
assign wr_en = put & full_bar;
assign rd_en = get & empty_bar;
gray2bin #(DEPTH) gb1(rd_ptr_ss,rd_ptr_ss_bin);
gray2bin #(DEPTH) gb2(wr_ptr_ss,wr_ptr_ss_bin);
gray2bin #(DEPTH) gb3(rd_ptr,rd_ptr_bin);
gray2bin #(DEPTH) gb4(wr_ptr,wr_ptr_bin);
assign wr_ptr_bin_p1=wr_ptr_bin+1;
assign rd_ptr_bin_p1=rd_ptr_bin+1;
bin2gray #(DEPTH) bg1(wr_ptr_bin_p1,wr_ptr_p1);
bin2gray #(DEPTH) bg2(rd_ptr_bin_p1,rd_ptr_p1);
assign diff=wr_ptr_bin-rd_ptr_ss_bin;
 always @(posedge wclk)
 	begin 
		rd_ptr_s<=rd_ptr;
		rd_ptr_ss<=rd_ptr_s;
		
		FULL<=(diff)>=(2**(DEPTH-1));
		if(wr_en)
		begin
		FULL<=(diff+1)>=(2**(DEPTH-1));
		mem[wr_ptr_bin[DEPTH-2:0]] <= data_in;
		wr_ptr<=wr_ptr_p1;
		end
 	end
 always @(posedge rclk)
	begin
		wr_ptr_s<=wr_ptr;
		wr_ptr_ss<=wr_ptr_s;
		EMPTY<=wr_ptr_ss==rd_ptr;
		if(rd_en) 
		begin
		EMPTY<=wr_ptr_ss_bin==rd_ptr_bin_p1;
		rd_ptr<=rd_ptr_p1;
		end
	end
 always @(posedge reset)
	begin
		if(reset) begin
 			rd_ptr =0;
 			wr_ptr =0;
			wr_ptr_s=0; 
			rd_ptr_s=0;
			wr_ptr_ss=0; 
			rd_ptr_ss=0;
			EMPTY=1;
			FULL=0;
 		end
	end


assign full_bar = ~FULL;
assign empty_bar = ~EMPTY;
assign data_out = (rd_en)?mem[rd_ptr_bin[DEPTH-2:0]]:0;
	    
endmodule 
