`include "/home/scf-12/ee552/proteus/pdk/proteus/svc2rtl.sv"
`E1OFN_M(2,16)

module acc (e1of2_16.In A,e1of2_16.Out Sum);
	logic [A.W-1:0] a; 
	logic[Sum.W-1 :0] sum;
        parameter WIDTH = 16;	
	always begin
		sum= 0;				//Resumet value
		forever begin
			A.Receive(a);
			sum= sum + a;
			Sum.Send(sum);
		end
	end
endmodule
