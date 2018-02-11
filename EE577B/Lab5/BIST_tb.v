/////////////////////////////////
///
///		tb.v
///
///
///
/////////////////////////////////


`timescale 1ns/10ps
module tb;

reg reset;
reg clk;
reg [1:0]a_in;
reg [1:0]b_in;
reg Testmode;
wire [3:0]y;
wire Testcomplete;
wire Testgood;
wire [1:0]T_A;
wire [1:0]T_B;

BIST b(reset, clk, a_in, b_in,y, Testmode,
			Testcomplete, Testgood, T_A, T_B);
integer f;
initial
	begin
		//fp = $fopen("/home/scf-02/qiangxue/ee577b/lab5//tb/pattern_g.out","r");
		f = $fopen("C_BIST.out","w");
		$fwrite(f, "This result is generated for the faulty version\n");
		clk = 0;
		reset = 1;
		a_in = 2'b00;
		b_in = 2'b00;
		Testmode = 0;
		#10
		reset = 0;
		Testmode = 1;
		#50
		$stop;
	end
always
	#1 clk = ~clk;
always@(negedge clk)
	begin
		if( Testmode == 1)
			begin
				if (Testgood == 0 && Testcomplete ==0)
					begin
						$fwrite(f, "The input vector that detects the fault is %b and %b\n", T_A, T_B);
						$fwrite(f, "The signature for the  faulty output is %b\n", y );
					end
			end
	end

endmodule
