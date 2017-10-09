`include "/home/scf-12/ee552/proteus/pdk/proteus/svc2rtl.sv"
`E1OFN_M(2,16)
`E1OFN_M(2,1)
module Receive_P(e1of2_16.In in, e1of2_16.In P_in, e1of2_1.Out C1_P_req, e1of2_16.Out C1_P_data, e1of2_1.Out C2_P_req, e1of2_16.Out C2_P_data);
  parameter WIDTH = 8;
  parameter addrWIDTH = 4;
  parameter FL = 2;
  parameter BL = 4;
  logic [7:0]addr,mask;
  logic [15:0] P_data_in;
  logic [1:0] k;
  logic [7:0] j;
  always begin
    k=0;
    j=0;
    forever begin
      if(k==0) begin
        in.Receive(addr);
        in.Receive(mask);
        k=1;
      end
      else begin
        if(k==1)begin
          P_in.Receive(P_data_in);
          k=2;
        end
        else if(k==3)begin
          j=0;
          k=1;
        end
        else begin

          if(mask[7-j]==0)begin
            if(P_data_in[15-j]==0) begin
              C1_P_req.Send(1);
              C1_P_data.Send(P_data_in);
            end
            else begin
              C2_P_req.Send(1);
              C2_P_data.Send(P_data_in);
            end
            k=3;
          end
          j=j+1;
        end
      end
    end
  end

endmodule
