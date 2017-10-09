//Written by Arash Saifhashemi
//Edited by Mehrdad
//EE552, Department of Electrical Engineering
//University of Southern California
//Spring 2011
`timescale 1ns/100ps

module data_generator (interface R);

	parameter W = 16;	
	reg signed [W-1:0] SendValue = 0;

	initial
	begin
	        #500;	
		forever
		begin
			SendValue = SendValue + 1;		
			R.Send(SendValue);
			$display("Send: %d", SendValue);
		end
	end
endmodule

module data_generatorOneBit (interface R);

	parameter W = 1;	
	reg unsigned [W-1:0] SendValue = 1;

	initial
	begin
	        #500;	
		forever
		begin
			//SendValue = ~SendValue ;		
			R.Send(SendValue);
			$display("Send control: %d", SendValue);
		end
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

module acc_cosim_tb;

	parameter W = 16;

	reg _RESET ;
	
	e1ofN_M #(.N(2), .M(16)) A ();
	e1ofN_M #(.N(2), .M(16)) A_CSP();
	e1ofN_M #(.N(2), .M(16)) A_RTL();
	e1ofN_M #(.N(2), .M(16)) Sum_CSP();
	e1ofN_M #(.N(2), .M(16)) Sum_RTL();	

        e1ofN_M #(.N(2), .M(16)) Sum_CSP_mid();
        e1ofN_M #(.N(2), .M(16)) Sum_RTL_mid();
  
	data_generator	#(.W(16)) dgI1 (.R(A));
	copy		#(.W(16)) cpdgI1 (.L(A), .R1(A_CSP), .R2(A_RTL));

	
	acc_csp_gold		u_acc_csp	(.A(A_CSP), .Sum(Sum_CSP));
		
	acc_cosim_wrapper u_acc_rtl (.A(A_RTL), .Sum(Sum_RTL) , ._RESET(_RESET));
	
	linear_pipeline #(.NUMBER_OF_BUF(6)) lp1 (.L(Sum_CSP), .R(Sum_CSP_mid));
	linear_pipeline #(.NUMBER_OF_BUF(6)) lp2 (.L(Sum_RTL), .R(Sum_RTL_mid));
	
	cosim_checker	#(.W(16))	cc	(.L1(Sum_CSP_mid), .L2(Sum_RTL_mid));
	
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
