
module fsm ( clk, rst, X, Y );
  output [1:0] Y;
  input clk, rst, X;
  wire   current_state_1_, n11, n12, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10,
         n13;

  XNOR2X1 U6 ( .A(current_state_1_), .B(Y[0]), .Y(n3) );
  AOI21X1 U7 ( .A(Y[0]), .B(n9), .C(rst), .Y(n11) );
  OAI21X1 U9 ( .A(n1), .B(n2), .C(n10), .Y(Y[1]) );
  AOI22X1 U10 ( .A(Y[0]), .B(current_state_1_), .C(n13), .D(n2), .Y(n5) );
  DFFPOSX1 current_state_reg_1_ ( .D(n8), .CLK(clk), .Q(current_state_1_) );
  DFFPOSX1 current_state_reg_0_ ( .D(n7), .CLK(clk), .Q(Y[0]) );
  BUFX2 U12 ( .A(n11), .Y(n7) );
  OR2X1 U13 ( .A(n3), .B(rst), .Y(n12) );
  INVX1 U14 ( .A(n12), .Y(n8) );
  AND2X1 U15 ( .A(X), .B(n1), .Y(n4) );
  INVX1 U16 ( .A(n4), .Y(n9) );
  BUFX2 U17 ( .A(n5), .Y(n10) );
  OR2X1 U18 ( .A(current_state_1_), .B(Y[0]), .Y(n6) );
  INVX1 U19 ( .A(n6), .Y(n13) );
  INVX1 U20 ( .A(X), .Y(n2) );
  INVX1 U21 ( .A(current_state_1_), .Y(n1) );
endmodule

