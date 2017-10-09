`timescale 1ns/100ps
module data_generator (interface A);
  parameter WIDTH = 8;
  parameter FL = 4; //ideal environment
  logic [WIDTH-1:0] a,b;
  logic [WIDTH/2-1:0] Value=0;
  logic [1:0] op;
  integer fp,status;

  always begin
    Value = $random() % (2**(WIDTH/2));
    A.Send(Value);
    #FL;
  end
endmodule

module data_bucket(interface I);
    parameter WIDTH = 16;
    parameter BL = 0; //ideal environment
    logic [WIDTH-1:0] ReceiveValue = 0;
    always begin
      I.Receive(ReceiveValue);
      #BL;
    end
endmodule
module copy (interface L, interface R1, interface R2);

	parameter W = 16;
	logic [W-1:0] data = 0;

	always
	begin
		L.Receive(data);
		fork
			R1.Send(data);
			R2.Send(data);
		join
	end
endmodule
module full_buffer (interface L, interface R);

	parameter W = 16;
	logic [W-1:0] data = 0;

	always
	begin
		L.Receive(data);
		R.Send(data);
	end
endmodule
module linear_pipeline (interface L, interface R);

	parameter NUMBER_OF_BUF = 6;

	e1ofN_M #(.N(2), .M(16)) mid [NUMBER_OF_BUF-1:0]   ();

	genvar i;
	for (i=0;i<=NUMBER_OF_BUF;i++)
	begin
		if (i==0)
			full_buffer	#(.W(16))	fb	(L, mid[i]);
		else if (i==NUMBER_OF_BUF)
			full_buffer	#(.W(16))	fb	(mid[i-1], R);
		else
			full_buffer	#(.W(16))	fb	(mid[i-1], mid[i]);
	end
endmodule
module cosim_checker (interface L1, interface L2);

	parameter W = 16;

	reg signed [W-1:0] CSPReceiveValue = 0;
	reg signed [W-1:0] ProteusReceiveValue = 0;

	always
	begin
		#300;
		fork
			L1.Receive(CSPReceiveValue);
			L2.Receive(ProteusReceiveValue);
		join
		if (CSPReceiveValue != ProteusReceiveValue)
			$display("ERROR");
		else
			$display("CORRECT");

		$display("CSPReceiveValue = %d", CSPReceiveValue);
		$display("ProteusReceiveValue = %d", ProteusReceiveValue);
	end
endmodule
module hamming_dec_cosim_tb;

	parameter W = 16;

	reg _RESET ;

  e1ofN_M #(.N(2), .M(4)) A ();
  e1ofN_M #(.N(2), .M(4)) A_CSP ();
  e1ofN_M #(.N(2), .M(4)) A_RTL ();
  e1ofN_M #(.N(2), .M(8)) B ();
  e1ofN_M #(.N(2), .M(8)) B_CSP ();
  e1ofN_M #(.N(2), .M(8)) B_RTL ();
  e1ofN_M #(.N(2), .M(8)) B_CSP_mid ();
  e1ofN_M #(.N(2), .M(8)) B_RTL_mid ();
  e1ofN_M #(.N(2), .M(1)) C ();
  e1ofN_M #(.N(2), .M(1)) C_CSP ();
  e1ofN_M #(.N(2), .M(1)) C_RTL ();
  e1ofN_M #(.N(2), .M(1)) C_CSP_mid ();
  e1ofN_M #(.N(2), .M(1)) C_RTL_mid ();
	data_generator generator(A);
	copy		#(.W(8)) cpdgI1 (A, A_CSP, A_RTL);
	hamming_gen_csp_gold  u_hamming_csp(A_CSP,B_CSP);
	hamming_gen_cosim_wrapper u_hamming_rtl (A_RTL,B_RTL,_RESET);
	linear_pipeline #(.NUMBER_OF_BUF(6)) lp1 (.L(B_CSP), .R(B_CSP_mid));
	linear_pipeline #(.NUMBER_OF_BUF(6)) lp2 (.L(B_RTL), .R(B_RTL_mid));
	cosim_checker	#(.W(8))	cc	(.L1(B_CSP_mid), .L2(B_RTL_mid));
	initial
	begin : reset

		_RESET = 0;
		A_RTL.d_log= '0;
		B_RTL.e_log = '0;

		#400;

		_RESET =  1;
		B_RTL.e_log = '1;

	end

endmodule
