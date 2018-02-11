//fault free
// Multiply Unit
// Y = A * B

module mult (a_in, b_in, y);
    parameter WIDTH = 2;
	input [WIDTH-1:0] a_in, b_in;
	output[2*WIDTH-1:0] y;
	
     assign y = a_in*b_in;
endmodule


