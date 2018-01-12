`timescale 1ns/100ps
module data_generator (interface A,interface B);
  parameter WIDTH = 16;
  parameter FL = 4; //ideal environment
  logic [WIDTH-1:0] a,b;
  logic [WIDTH/2-1:0] Value=0;
  logic [1:0] op;
  integer fp,status;

  always begin
    Value = $random() % (2**(WIDTH));
    A.Send(Value);
    Value = $random() % (2**(WIDTH));
    B.Send(Value);
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
module Receive_P_cosim_tb;

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
  e1ofN_M #(.N(2), .M(1)) D ();
  e1ofN_M #(.N(2), .M(1)) D_CSP ();
  e1ofN_M #(.N(2), .M(1)) D_RTL ();
  e1ofN_M #(.N(2), .M(1)) D_CSP_mid ();
  e1ofN_M #(.N(2), .M(1)) D_RTL_mid ();
  e1ofN_M #(.N(2), .M(1)) E ();
  e1ofN_M #(.N(2), .M(1)) E_CSP ();
  e1ofN_M #(.N(2), .M(1)) E_RTL ();
  e1ofN_M #(.N(2), .M(1)) E_CSP_mid ();
  e1ofN_M #(.N(2), .M(1)) E_RTL_mid ();
	data_generator generator(A,B);
	copy		#(.W(16)) cpdgI1 (A, A_CSP, A_RTL);
  copy		#(.W(16)) cpdgI2 (B, B_CSP, B_RTL);
	Ini_csp_gold  u_Ini_csp(A_CSP,B_CSP,C_CSP,D_CSP,E_CSP);
	Ini_cosim_wrapper u_Ini_rtl (A_RTL,B_RTL,C_RTL,D_RTL,E_RTL,_RESET);
	linear_pipeline #(.NUMBER_OF_BUF(6)) lp1 (.L(E_CSP), .R(E_CSP_mid));
	linear_pipeline #(.NUMBER_OF_BUF(6)) lp2 (.L(E_RTL), .R(E_RTL_mid));
  linear_pipeline #(.NUMBER_OF_BUF(6)) lp3 (.L(C_CSP), .R(C_CSP_mid));
  linear_pipeline #(.NUMBER_OF_BUF(6)) lp4 (.L(C_RTL), .R(C_RTL_mid));
  linear_pipeline #(.NUMBER_OF_BUF(6)) lp5 (.L(D_CSP), .R(D_CSP_mid));
  linear_pipeline #(.NUMBER_OF_BUF(6)) lp6 (.L(D_RTL), .R(D_RTL_mid));
	cosim_checker	#(.W(16))	cc	(.L1(C_CSP_mid), .L2(C_RTL_mid));
  cosim_checker	#(.W(16))	ccc	(.L1(D_CSP_mid), .L2(D_RTL_mid));
  cosim_checker	#(.W(16))	cccc	(.L1(E_CSP_mid), .L2(E_RTL_mid));
	initial
	begin : reset

		_RESET = 0;
		A_RTL.d_log= '0;
    B_RTL.d_log= '0;
		C_RTL.e_log = '0;
    D_RTL.e_log = '0;
    E_RTL.e_log = '0;
		#400;

		_RESET =  1;
		C_RTL.e_log = '1;
    D_RTL.e_log = '1;
    E_RTL.e_log = '1;
	end

endmodule
