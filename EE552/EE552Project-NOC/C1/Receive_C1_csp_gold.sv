`include "/home/scf-12/ee552/proteus/pdk/proteus/svc2rtl.sv"
module Receive_C1_csp_gold(interface in, interface C1_in, interface C2_C1_req, interface C2_C1_data, interface P_C1_req, interface P_C1_data);
  parameter WIDTH = 8;
  parameter addrWIDTH = 4;
  parameter FL = 2;
  parameter BL = 4;
  logic [7:0]addr,mask;
  logic [15:0] C1_data_in;
  logic j;
  always begin
    j=0;
    forever begin
      if(j==0) begin
        in.Receive(addr);
        in.Receive(mask);
        j=1;
      end
      else begin
        C1_in.Receive(C1_data_in);
        if((C1_data_in[15:8]&mask)==addr) begin
          C2_C1_req.Send(1);
          C2_C1_data.Send(C1_data_in);
        end
        else begin
          P_C1_req.Send(1);
          P_C1_data.Send(C1_data_in);
        end
      end
    end
  end
endmodule // Receive_C1
