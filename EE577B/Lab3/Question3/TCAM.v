module TCAM(reset, clk, DIN, EN, WE, match, match_addr); 
parameter DEPTH=8;
parameter WIDTH=8;
input reset,clk,EN,WE;
input[(WIDTH*2)-1:0] DIN;
output reg match;
output reg[2:0] match_addr;
reg [(WIDTH*2)-1:0] mem [DEPTH-1:0];
reg [2:0] rank [DEPTH-1:0];
reg [2:0] matchN [DEPTH-1:0];
reg [2:0] N;
reg [2:0] last;
reg m;
integer i,j;
always @(posedge clk,posedge reset) begin
	if(reset) begin
		for(i=0;i<DEPTH;i=i+1) begin
			rank[i]<=i;
			mem[i]<=0;
			matchN[i]<=0;
		end
		match<=0;
		match_addr<=0;
		m<=0;
	end
	else if(EN) begin
		if(m)begin
			match<=1;
			match_addr<=j;
			m<=0;
			rank[j]<=0;
			for(i=0;i<DEPTH;i=i+1)begin
				if(rank[j]>rank[i])begin
					rank[i]<=rank[i]+1;
				end
			end
		end
		else begin
			match<=0;
			match_addr<=0;
			if(WE) begin
				for(i=0;i<DEPTH;i=i+1) begin
					if(rank[i]==DEPTH-1) last=i;
					rank[i]<=rank[i]+1;
				end
				mem[last]<={DIN[15:8]&DIN[7:0],DIN[7:0]};
				N=0;
				for(j=0;j<DEPTH;j=j+1)begin
					N=N+DIN[j];
				end
				matchN[last]<=N;
			end
			else begin
				N=0;
				for(i=0;i<DEPTH;i=i+1) begin
					if(mem[i][15:8]==(DIN[15:8]&mem[i][7:0]))begin
						$display("mem%b,and%b,din%b",mem[i][15:8],(DIN[15:8]&mem[i][7:0]),DIN[15:8]);
						m<=1;
						if(N<matchN[i])begin
							N=matchN[i];
							j=i;
						end
					end
				end
			end
		end
	end
	else m<=0;
end

endmodule