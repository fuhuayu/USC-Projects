`include "/home/scf-12/ee552/proteus/pdk/proteus/svc2rtl.sv"
module Ini_csp_gold(interface C1_in, interface C2_in,interface out1, interface out2, interface out3);
  parameter FL = 2;
  parameter BL = 4;
  parameter TOP=0;
  logic [15:0] receive1,receive2;
  logic [7:0]addr,mask,xaddr;
  logic [1:0] k;
  logic [4:0]i;
  always begin
    i=0;
    k=0;
    forever begin
      if(k==0) begin
        C1_in.Receive(receive1);
        C2_in.Receive(receive2);
        addr=receive1[15:8]&receive2[15:8];
        xaddr=receive1[15:8]^receive2[15:8];
        k=1;
      end
      else if(k==1) begin
          if(xaddr[8-1-i])begin
            mask={{(8+i){1'b1}},{(8-i){1'b0}}}
            k=2;
          end
          i=i+1;
      end
      else if(k==2) begin
        if(TOP==0) begin
          P_C1_req.Send(1);
          P_C1_data.Send({addr,mask});
        end
        k=3;
      end
      else if(k==3) begin
        out1.Send(addr);
        out2.Send(addr);
        out3.Send(addr);
        k=4;
      end
      else begin
          out1.Send(mask);
          out2.Send(mask);
          out3.Send(mask);
      end
    end
  end
endmodule
