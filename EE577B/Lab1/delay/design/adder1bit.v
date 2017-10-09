//////////////////////////////////////////////////////////////////////
//     design: adder1bit.v
//////////////////////////////////////////////////////////////////////

module andmodule(A, B, AND1, AND2, AND3, AND4, AND5);
input A, B;
output  AND1, AND2, AND3, AND4, AND5;
reg AND1, AND2, AND3, AND4;
always @ (A or B)
		#4 AND1=A&B;
always @ (A or B)
		#4 AND2<=A&B;
always @ (A or B)
		AND3=#4 A&B;
always @ (A or B)
		AND4<=#4 A&B;
assign #4 AND5 = A&B;
endmodule // adder1bit
