`timescale 1ns/100ps
module data_generator (interface OP, interface A, interface B);
  parameter WIDTH = 16;
  parameter FL = 4; //ideal environment
  logic [WIDTH-1:0] a,b;
  logic [1:0] op;
  integer fp,status;
  initial
  begin
      fp = $fopen("pattern.txt","r");
  end
  always begin
    if($feof(fp)) $stop;
    status = $fscanf(fp,"%b %d %d \n", op, a, b);
    case(op)
      2'b00:begin
              OP.Send(op);
              A.Send(a);
              B.Send(b);
            end
      2'b01:begin
              OP.Send(op);
              A.Send(a);
              B.Send(b);
            end
      2'b10:begin
              OP.Send(op);
              A.Send(a);
            end
      2'b11:begin
              OP.Send(op);
              B.Send(b);
            end
    endcase
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
module alu_cosim_tb;

	parameter W = 16;

	reg _RESET ;

	e1ofN_M #(.N(2), .M(16)) OP ();
	e1ofN_M #(.N(2), .M(16)) OP_CSP();
	e1ofN_M #(.N(2), .M(16)) OP_RTL();
  e1ofN_M #(.N(2), .M(16)) A ();
	e1ofN_M #(.N(2), .M(16)) A_CSP();
	e1ofN_M #(.N(2), .M(16)) A_RTL();
  e1ofN_M #(.N(2), .M(16)) B ();
	e1ofN_M #(.N(2), .M(16)) B_CSP();
	e1ofN_M #(.N(2), .M(16)) B_RTL();
	e1ofN_M #(.N(2), .M(16)) Y_CSP();
	e1ofN_M #(.N(2), .M(16)) Y_RTL();
  e1ofN_M #(.N(2), .M(16)) Y_CSP_mid();
  e1ofN_M #(.N(2), .M(16)) Y_RTL_mid();
  e1ofN_M #(.N(2), .M(16)) Z_CSP();
	e1ofN_M #(.N(2), .M(16)) Z_RTL();
  e1ofN_M #(.N(2), .M(16)) Z_CSP_mid();
  e1ofN_M #(.N(2), .M(16)) Z_RTL_mid();
	data_generator generator(.OP(OP),.A(A),.B(B));
	copy		#(.W(2)) cpdgI1 (.L(OP), .R1(OP_CSP), .R2(OP_RTL));
  copy		#(.W(16)) cpdgI2 (.L(A), .R1(A_CSP), .R2(A_RTL));
  copy		#(.W(16)) cpdgI3 (.L(B), .R1(B_CSP), .R2(B_RTL));
	alu_csp_gold  u_alu_csp(.OP(OP_CSP), .A(A_CSP), .B(B_CSP), .Y(Y_CSP), .Z(Z_CSP));
	alu_cosim_wrapper u_alu_rtl (.OP(OP_RTL), .A(A_RTL), .B(B_RTL), .Y(Y_RTL), .Z(Z_RTL), ._RESET(_RESET));

	linear_pipeline #(.NUMBER_OF_BUF(6)) lp1 (.L(Y_CSP), .R(Y_CSP_mid));
	linear_pipeline #(.NUMBER_OF_BUF(6)) lp2 (.L(Y_RTL), .R(Y_RTL_mid));
  linear_pipeline #(.NUMBER_OF_BUF(6)) lp3 (.L(Z_CSP), .R(Z_CSP_mid));
	linear_pipeline #(.NUMBER_OF_BUF(6)) lp4 (.L(Z_RTL), .R(Z_RTL_mid));
	cosim_checker	#(.W(16))	cc	(.L1(Y_CSP_mid), .L2(Y_RTL_mid));
  cosim_checker	#(.W(16))	cc1	(.L1(Z_CSP_mid), .L2(Z_RTL_mid));
	initial
	begin : reset

		_RESET = 0;
		A_RTL.d_log= '0;
		Sum_RTL.e_log = '0;

		#400;

		_RESET =  1;
		Sum_RTL.e_log = '1;

	end

endmodule
