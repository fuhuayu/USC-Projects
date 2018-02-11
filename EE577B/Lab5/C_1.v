//faulty

module mult (a_in, b_in, y);
    parameter WIDTH = 2;
	input [WIDTH-1:0] a_in, b_in;
	output[2*WIDTH-1:0] y;
    wire [2*WIDTH-1:0] y_temp;

        // Function to be performed
        //Y = A * B;
     assign y_temp = a_in*b_in;
     assign y[2*WIDTH-1:1] = y_temp[2*WIDTH-1:1];
     assign y[0] = a_in[0]+b_in[0];
endmodule
