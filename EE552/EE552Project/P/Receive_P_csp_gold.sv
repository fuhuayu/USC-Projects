`include "/home/scf-12/ee552/proteus/pdk/proteus/svc2rtl.sv"
module Receive_P_csp_gold(interface in, interface P_in, interface C1_P_req, interface C1_P_data, interface C2_P_req, interface C2_P_data);
  parameter WIDTH = 8;
  parameter addrWIDTH = 4;
  parameter FL = 2;
  parameter BL = 4;
  logic [addrWIDTH-1:0]addr,mask;
  logic [addrWIDTH+WIDTH-1:0] P_data_in;
  logic [1:0] k;
  logic [addrWIDTH-1:0] j;
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
          if(mask[addrWIDTH-1-j]==0)begin
            if(P_data_in[addrWIDTH+WIDTH-1-j]==0) begin
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
