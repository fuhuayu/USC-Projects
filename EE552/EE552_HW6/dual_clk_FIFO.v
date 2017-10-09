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

module dual_clk_FIFO (rclk, wclk, reset, wen,ren, data_in, empty_bar, full_bar, data_out);

parameter DEPTH_P2 = 5; 
parameter WIDTH = 8;

input [WIDTH-1:0] data_in;
input wen, ren;
input reset, rclk,wclk;

output [WIDTH-1:0] data_out;
output empty_bar, full_bar;
wire [WIDTH-1:0] data_out;
wire empty_bar, full_bar;
wire wr_en,rd_en;
wire [DEPTH_P2-1:0] wr_ptr2_bin, rd_ptr2_bin;
wire [DEPTH_P2-1:0] wr_ptr_bin, rd_ptr_bin;
wire [DEPTH_P2-1:0] old_wr_ptr_bin, old_rd_ptr_bin;
wire [DEPTH_P2-1:0] old_wr_ptr_bin_p1, old_rd_ptr_bin_p1;
wire [DEPTH_P2-1:0] wr_ptr_bin_p1, rd_ptr_bin_p1;
wire [DEPTH_P2-1:0] wr_ptr_p1, rd_ptr_p1;
reg [DEPTH_P2-1:0] wr_ptr=0, rd_ptr=0;
reg [WIDTH-1:0] mem [2**DEPTH_P2-1:0];
reg [DEPTH_P2-1:0] wr_ptr1=0, rd_ptr1=0;
reg [DEPTH_P2-1:0] wr_ptr2=0, rd_ptr2=0;
reg [DEPTH_P2-1:0] old_wr_ptr=0, old_rd_ptr=0;
reg FULL=0, EMPTY=1;
//pre_encoding
assign wr_en = wen & full_bar;
assign rd_en = ren & empty_bar;
gray2bin gb1(rd_ptr2,rd_ptr2_bin);
gray2bin gb2(wr_ptr2,wr_ptr2_bin);
gray2bin gb3(rd_ptr,rd_ptr_bin);
gray2bin gb4(wr_ptr,wr_ptr_bin);
gray2bin gb5(old_rd_ptr,old_rd_ptr_bin);
gray2bin gb6(old_wr_ptr,old_wr_ptr_bin);
assign wr_ptr_bin_p1=wr_ptr_bin+1;
assign rd_ptr_bin_p1=rd_ptr_bin+1;
assign old_wr_ptr_bin_p1=old_wr_ptr_bin+1;
assign old_rd_ptr_bin_p1=old_rd_ptr_bin+1;
bin2gray bg1(wr_ptr_bin_p1,wr_ptr_p1);
bin2gray bg2(rd_ptr_bin_p1,rd_ptr_p1);

 always @(posedge wclk)
 	begin
		if(wr_en) mem[wr_ptr] <= data_in;
		rd_ptr1<=rd_ptr;
		rd_ptr2<=rd_ptr1;
		FULL<=(wr_ptr==rd_ptr2)&&((old_wr_ptr_bin_p1==rd_ptr2_bin)||FULL);
		if(wr_en)
		begin
		wr_ptr<=wr_ptr_p1;
		old_wr_ptr<=wr_ptr;
		end
 	end
 always @(posedge rclk)
	begin
		wr_ptr1<=wr_ptr;
		wr_ptr2<=wr_ptr1;
		EMPTY<=(wr_ptr2==rd_ptr)&&((old_rd_ptr_bin_p1==wr_ptr2_bin)||EMPTY);
		if(rd_en) 
		begin
		rd_ptr<=rd_ptr_p1;
		old_rd_ptr<=rd_ptr;
		end
	end
 always @(posedge reset)
	begin
		if(reset) begin
 			rd_ptr <= {DEPTH_P2{1'b0}};
 			wr_ptr <= {DEPTH_P2{1'b0}};
			EMPTY=1;
			FULL=0;
 		end
	end


assign full_bar = ~FULL;
assign empty_bar = ~EMPTY;
assign data_out = (rd_en)?mem[rd_ptr]:{WIDTH{1'bx}};
	    
endmodule 
