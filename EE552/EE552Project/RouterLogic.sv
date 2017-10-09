`timescale 1ns/1ns
import SystemVerilogCSP::*;
module Ini(interface C1_in, interface C2_in,interface out1, interface out2, interface out3);
  parameter WIDTH = 8;
  parameter addrWIDTH = 4;
  parameter FL = 2;
  parameter BL = 4;
  parameter TOP=0;
  logic [addrWIDTH*2-1:0] receive1,receive2;
  logic [addrWIDTH-1:0]addr,mask,xaddr;
  logic [1:0] k;
  logic [addrWIDTH-1:0]i;
  always begin
    i=0;
    k=0;
    forever begin
      if(k==0) begin
        fork
        C1_in.Receive(receive1);
        C2_in.Receive(receive2);
        join
        #FL;
        addr=receive1[addrWIDTH*2-1:addrWIDTH]&receive2[addrWIDTH*2-1:addrWIDTH];
        xaddr=receive1[addrWIDTH*2-1:addrWIDTH]^receive2[addrWIDTH*2-1:addrWIDTH];
        k=1;
      end
      else if(k==1) begin
          if(xaddr[addrWIDTH-1-i])begin
            mask={{addrWIDTH{1'b1}},{addrWIDTH{1'b0}}}>>i;
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
      else begin
        fork
          out1.Send(addr);
          out2.Send(addr);
          out3.Send(addr);
        join
        fork
          out1.Send(mask);
          out2.Send(mask);
          out3.Send(mask);
        join
        #BL;
      end
    end
  end
endmodule

module Receive_P(interface in, interface P_in, interface C1_P_req, interface C1_P_data, interface C2_P_req, interface C2_P_data);
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
        #BL;
      end
      else begin
        if(k==1)begin
          P_in.Receive(P_data_in);
          #FL;
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
              #BL;
            end
            else begin
              C2_P_req.Send(1);
              C2_P_data.Send(P_data_in);
              #BL;
            end
            k=3;
          end
          j=j+1;
        end
      end
    end
  end

endmodule

module Receive_C1(interface in, interface C1_in, interface C2_C1_req, interface C2_C1_data, interface P_C1_req, interface P_C1_data);
  parameter WIDTH = 8;
  parameter addrWIDTH = 4;
  parameter FL = 2;
  parameter BL = 4;
  logic [addrWIDTH-1:0]addr,mask;
  logic [addrWIDTH+WIDTH-1:0] C1_data_in;
  logic j;
  always begin
    j=0;
    forever begin
      if(j==0) begin
        in.Receive(addr);
        in.Receive(mask);
        j=1;
        #BL;
      end
      else begin
        C1_in.Receive(C1_data_in);
        #FL;
        if((C1_data_in[addrWIDTH+WIDTH-1:WIDTH]&mask)==addr) begin
          C2_C1_req.Send(1);
          C2_C1_data.Send(C1_data_in);
          #BL;
        end
        else begin
          P_C1_req.Send(1);
          P_C1_data.Send(C1_data_in);
          #BL;
        end
      end
    end
  end
endmodule // Receive_C1
module Receive_C2(interface in, interface C2_in, interface C1_C2_req, interface C1_C2_data, interface P_C2_req, interface P_C2_data);
  parameter WIDTH = 8;
  parameter addrWIDTH = 4;
  parameter FL = 2;
  parameter BL = 4;
  logic [addrWIDTH-1:0]addr,mask;
  logic [addrWIDTH+WIDTH-1:0] C2_data_in;
  logic j;
  always begin
    j=0;
    forever begin
      if(j==0) begin
        in.Receive(addr);
        in.Receive(mask);
        j=1;
        #BL;
      end
      else begin
        C2_in.Receive(C2_data_in);
        #FL;
        if((C2_data_in[addrWIDTH+WIDTH-1:WIDTH]&mask)==addr) begin
          C1_C2_req.Send(1);
          C1_C2_data.Send(C2_data_in);
          #BL;
        end
        else begin
          P_C2_req.Send(1);
          P_C2_data.Send(C2_data_in);
          #BL;
        end
      end
    end
  end
endmodule // Receive_C
module RouterLogic(interface P_C1_req, interface P_C2_req,interface P_C1_data,interface P_C2_data, interface P_in,
                   interface C1_P_req,interface C1_C2_req,interface C1_P_data,interface C1_C2_data,interface C1_in,
                   interface C2_P_req,interface C2_C1_req,interface C2_P_data,interface C2_C1_data,interface C2_in);
  parameter WIDTH = 8;
  parameter addrWIDTH = 4;
  parameter FL = 2;
  parameter BL = 4;
  parameter TOP=0;
  Channel #(.WIDTH(WIDTH+addrWIDTH),.hsProtocol(P4PhaseBD)) Out[2:0] ();
  Ini #(.TOP(TOP),.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) ini(C1_in,C2_in,Out[0],Out[1],Out[2]);
  Receive_P #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) rp( Out[0],  P_in,  C1_P_req,  C1_P_data,  C2_P_req,  C2_P_data);
  Receive_C1 #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) rc1 ( Out[1],  C1_in,  C2_C1_req,  C2_C1_data,  P_C1_req,  P_C1_data);
  Receive_C2 #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) rc2 ( Out[2],  C2_in,  C1_C2_req,  C1_C2_data,  P_C2_req,  P_C2_data);
endmodule;
