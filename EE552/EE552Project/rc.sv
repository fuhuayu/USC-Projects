`timescale 1ns/1ns
import SystemVerilogCSP::*;
module RouterLogic(interface P_C1_req, interface P_C2_req,interface P_C1_data,interface P_C2_data, interface P_in,
                   interface C1_P_req,interface C1_C2_req,interface C1_P_data,interface C1_C2_data,interface C1_in,
                   interface C2_P_req,interface C2_C1_req,interface C2_P_data,interface C2_C1_data,interface C2_in);
  parameter WIDTH = 8;
  parameter addrWIDTH = 4;
  parameter FL = 2;
  parameter BL = 4;
  logic [addrWIDTH+WIDTH-1:0] P_data_in,C1_data_in,C2_data_in;
  logic [addrWIDTH*2-1:0] receive1,receive2;
  logic [addrWIDTH-1:0]addr,mask,xaddr;
  integer i,j,k;
  initial
		begin
      fork
			C1_in.Receive(receive1);
      C2_in.Receive(receive2);
      join
      addr=receive1[addrWIDTH*2-1:addrWIDTH]&receive2[addrWIDTH*2-1:addrWIDTH];
      xaddr=receive1[addrWIDTH*2-1:addrWIDTH]^receive2[addrWIDTH*2-1:addrWIDTH];
      for(i=0;i<addrWIDTH;i=i+1)begin
        if(xaddr[addrWIDTH-1-i])begin
          mask={{addrWIDTH{1'b1}},{addrWIDTH{1'b0}}}>>i;
          break;
        end
      end
      if(mask!=0) begin
        P_C1_req.Send(1);
        P_C1_data.Send({addr,mask});
      end
      k=1;
		end
  always begin
    wait(k!=0);
      P_in.Receive(P_data_in);
      for(j=0;j<addrWIDTH;j=j+1)begin
        if(mask[addrWIDTH-1-j]==0)begin
          if(P_data_in[addrWIDTH+WIDTH-1-j]==0) begin
            C1_P_req.Send(1);
            C1_P_data.Send(P_data_in);
          end
          else begin
            C2_P_req.Send(1);
            C2_P_data.Send(P_data_in);
          end
          break;
        end
      end

  end
  always begin
    wait(k!=0);
      C1_in.Receive(C1_data_in);
      if((C1_data_in[addrWIDTH+WIDTH-1:WIDTH]&mask)==addr) begin
        C2_C1_req.Send(1);
        C2_C1_data.Send(C1_data_in);
      end
      else begin
        P_C1_req.Send(1);
        P_C1_data.Send(C1_data_in);
      end

  end
  always begin
    wait(k!=0);
      C2_in.Receive(C2_data_in);
      if((C2_data_in[addrWIDTH+WIDTH-1:WIDTH]&mask)==addr) begin
        C1_C2_req.Send(1);
        C1_C2_data.Send(C2_data_in);
      end
      else begin
        P_C2_req.Send(1);
        P_C2_data.Send(C2_data_in);
      end

  end
endmodule

module Router(interface P_in, interface P_out, interface C1_out,interface C1_in,interface C2_out,interface C2_in);
  parameter FL = 2;
  parameter BL = 4;
  parameter WIDTH = 8;
  parameter addrWIDTH = 4;
  Channel #(.WIDTH(WIDTH+addrWIDTH),.hsProtocol(P4PhaseBD)) P_C1_data ();
  Channel #(.WIDTH(WIDTH+addrWIDTH),.hsProtocol(P4PhaseBD)) P_C2_data ();
  Channel #(.WIDTH(WIDTH+addrWIDTH),.hsProtocol(P4PhaseBD)) C1_P_data ();
  Channel #(.WIDTH(WIDTH+addrWIDTH),.hsProtocol(P4PhaseBD)) C1_C2_data ();
  Channel #(.WIDTH(WIDTH+addrWIDTH),.hsProtocol(P4PhaseBD)) C2_P_data ();
  Channel #(.WIDTH(WIDTH+addrWIDTH),.hsProtocol(P4PhaseBD)) C2_C1_data ();
  Channel #(.WIDTH(WIDTH+addrWIDTH),.hsProtocol(P4PhaseBD)) P_C1_req ();
  Channel #(.WIDTH(WIDTH+addrWIDTH),.hsProtocol(P4PhaseBD)) P_C2_req ();
  Channel #(.WIDTH(WIDTH+addrWIDTH),.hsProtocol(P4PhaseBD)) C1_P_req ();
  Channel #(.WIDTH(WIDTH+addrWIDTH),.hsProtocol(P4PhaseBD)) C1_C2_req ();
  Channel #(.WIDTH(WIDTH+addrWIDTH),.hsProtocol(P4PhaseBD)) C2_P_req ();
  Channel #(.WIDTH(WIDTH+addrWIDTH),.hsProtocol(P4PhaseBD)) C2_C1_req ();
  RouterLogic #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH), .FL(FL), .BL(BL)) R( P_C1_req, P_C2_req,P_C1_data, P_C2_data,  P_in,
               C1_P_req, C1_C2_req,C1_P_data, C1_C2_data, C1_in,
               C2_P_req, C2_C1_req,C2_P_data, C2_C1_data, C2_in);
  ArbiterMerge #(.WIDTH(WIDTH+addrWIDTH), .FL(FL), .BL(BL)) AM0( P_C1_req, P_C2_req,P_C1_data,  P_C2_data, P_out);
  ArbiterMerge #(.WIDTH(WIDTH+addrWIDTH), .FL(FL), .BL(BL)) AM1( C1_P_req, C1_C2_req,C1_P_data,  C1_C2_data, C1_out);
  ArbiterMerge #(.WIDTH(WIDTH+addrWIDTH), .FL(FL), .BL(BL)) AM2( C2_P_req, C2_C1_req,C2_P_data,  C2_C1_data, C2_out);
endmodule



module RouterLogic(interface P_C1_req, interface P_C2_req,interface P_C1_data,interface P_C2_data, interface P_in,
                   interface C1_P_req,interface C1_C2_req,interface C1_P_data,interface C1_C2_data,interface C1_in,
                   interface C2_P_req,interface C2_C1_req,interface C2_P_data,interface C2_C1_data,interface C2_in);
  parameter WIDTH = 8;
  parameter addrWIDTH = 4;
  parameter FL = 2;
  parameter BL = 4;
  parameter TOP=0;
  logic [addrWIDTH+WIDTH-1:0] P_data_in,C1_data_in,C2_data_in;
  logic [addrWIDTH*2-1:0] receive1,receive2;
  logic [addrWIDTH-1:0]addr,mask,xaddr;
  integer i,j,k;
  initial
		begin
      fork
			C1_in.Receive(receive1);
      C2_in.Receive(receive2);
      join
      addr=receive1[addrWIDTH*2-1:addrWIDTH]&receive2[addrWIDTH*2-1:addrWIDTH];
      xaddr=receive1[addrWIDTH*2-1:addrWIDTH]^receive2[addrWIDTH*2-1:addrWIDTH];
      for(i=0;i<addrWIDTH;i=i+1)begin
        if(xaddr[addrWIDTH-1-i])begin
          mask={{addrWIDTH{1'b1}},{addrWIDTH{1'b0}}}>>i;
          break;
        end
      end
      if(TOP==0) begin
        P_C1_req.Send(1);
        P_C1_data.Send({addr,mask});
      end
      k=1;
		end
  always begin
    wait(k!=0);
      P_in.Receive(P_data_in);
      for(j=0;j<addrWIDTH;j=j+1)begin
        if(mask[addrWIDTH-1-j]==0)begin
          if(P_data_in[addrWIDTH+WIDTH-1-j]==0) begin
            C1_P_req.Send(1);
            C1_P_data.Send(P_data_in);
          end
          else begin
            C2_P_req.Send(1);
            C2_P_data.Send(P_data_in);
          end
          break;
        end
      end

  end
  always begin
    wait(k!=0);
      C1_in.Receive(C1_data_in);
      if((C1_data_in[addrWIDTH+WIDTH-1:WIDTH]&mask)==addr) begin
        C2_C1_req.Send(1);
        C2_C1_data.Send(C1_data_in);
      end
      else begin
        P_C1_req.Send(1);
        P_C1_data.Send(C1_data_in);
      end

  end
  always begin
    wait(k!=0);
      C2_in.Receive(C2_data_in);
      if((C2_data_in[addrWIDTH+WIDTH-1:WIDTH]&mask)==addr) begin
        C1_C2_req.Send(1);
        C1_C2_data.Send(C2_data_in);
      end
      else begin
        P_C2_req.Send(1);
        P_C2_data.Send(C2_data_in);
      end

  end
endmodule
