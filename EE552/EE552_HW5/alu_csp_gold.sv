`include "svc2rtl.sv"
`E1OFN_M(2,16)
module alu_csp_gold (interface OP,interface A,interface B,interface Y,interface Z);
  logic [OP.W-1:0] op;
  logic [A.W-1:0] a;
  logic [B.W-1:0] b;
  logic [Y.W-1:0] y;
  logic [Z.W-1:0] z;
  parameter WIDTH = 16;
	always begin
		OP.Receive(op);
    case(op)
      2'b00:begin
              fork
                A.Receive(a);
                B.Receive(b);
              join
              z=a^b;
              Z.Send(z);
            end
      2'b01:begin
              fork
                A.Receive(a);
                B.Receive(b);
              join
              z=a+b;
              Z.Send(z);
            end
      2'b10:begin
              A.Receive(a);
              y={a[WIDTH-3:0],a[WIDTH-1],a[WIDTH-2]};
              Y.Send(y);
            end
      2'b11:begin
              B.Receive(b);
              y={a[WIDTH-1],a[WIDTH-1],a[WIDTH-1:2]};
              Y.Send(y);
            end
      endcase
	end
endmodule
