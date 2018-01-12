`include "/home/scf-12/ee552/proteus/pdk/proteus/svc2rtl.sv"
module Receive_C2_csp_gold(interface in, interface C2_in, interface C1_C2_req, interface C1_C2_data, interface P_C2_req, interface P_C2_data);
parameter WIDTH = 8;
parameter addrWIDTH = 4;
parameter FL = 2;
parameter BL = 4;
logic [7:0]addr,mask;
logic [15:0] C2_data_in;
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
      C2_in.Receive(C2_data_in);
      if((C2_data_in[15:8]&mask)==addr) begin
        C1_C2_req.Send(1);
        C1_C2_data.Send(C2_data_in);
      end
      else begin
        P_C2_req.Send(1);
        P_C2_data.Send(C2_data_in);
      end
    end
  end
end
endmodule // Receive_C
