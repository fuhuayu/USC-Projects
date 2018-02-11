/////////////////////////////////
///
///		BIST.v
///
///
///
/////////////////////////////////

module BIST(input  reset, input clk, input [1:0]a_in, input [1:0]b_in, output [3:0]y,
	input Testmode, output reg Testcomplete, output Testgood, output [1:0] T_A, output [1:0] T_B);
	reg [3:0] counter;
	wire [1:0] signature;
	wire [1:0] inA,inB;
	reg comp;
	mult fault(inA,inB,y);
	assign signature = inA*inB;
	assign inA = Testmode? T_A:a_in;
	assign inB = Testmode? T_B:b_in;
	assign Testgood = (signature == y);
	assign T_A=counter[3:2];
	assign T_B=counter[1:0];
always@(posedge clk)
	begin
		if(reset) begin
			counter<=0;
			end
		else begin
			if(Testmode & (counter<15))begin
				counter<=counter+1;
			end
			Testcomplete<=(counter==15);
		end
	end

endmodule
