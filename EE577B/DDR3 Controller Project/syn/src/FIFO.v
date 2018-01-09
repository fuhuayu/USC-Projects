module FIFO (clk, reset, data_in, put, get, data_out, empty, full, fillcount);

parameter DEPTH_P2 = 5;
parameter WIDTH = 8;

input [WIDTH-1:0] data_in;
input put, get;
input reset, clk;

output [WIDTH-1:0] data_out;
output empty, full;
output [DEPTH_P2:0] fillcount; //if it is full,we need onemore bit
wire [WIDTH-1:0] data_out;
wire empty, full;

reg [DEPTH_P2:0] fillcount; //if it is full,we need onemore bit
reg [DEPTH_P2-1:0] wr_ptr, rd_ptr;
reg [WIDTH-1:0] mem [2**DEPTH_P2-1:0];

reg [WIDTH-1:0] data_reg;

always @(posedge clk)
  begin
    if(reset)
	  begin
	    wr_ptr <= 0;
		  rd_ptr <= 0;
		  fillcount <= 0;
	  end
	else
	  begin
      data_reg <= data_out;
      if(!full && put && !empty && get) begin
        mem[wr_ptr]<=data_in;
        wr_ptr<=wr_ptr+1;
        rd_ptr<=rd_ptr+1;
      end else if (!full && put) begin
        mem[wr_ptr]<=data_in;
        wr_ptr<=wr_ptr+1;
        fillcount<=fillcount+1;
      end else if (!empty && get) begin
        rd_ptr<=rd_ptr+1;
        fillcount<=fillcount-1;
      end
	  end
  end

assign full = fillcount[DEPTH_P2];
assign empty = (fillcount == 0);
assign data_out = (empty)? data_reg : mem[rd_ptr];


endmodule
