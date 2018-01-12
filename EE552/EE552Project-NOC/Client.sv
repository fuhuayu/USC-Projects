`timescale 1ns/1ns
import SystemVerilogCSP::*;
module hamming_gen (interface d,interface out);
  logic[7:0] data,data_out;
  always begin
  d.Receive(data);
  data_out[7]=data[3]^data[2]^data[0];
  data_out[6]=data[3]^data[1]^data[0];
  data_out[5]=data[3];
  data_out[4]=data[2]^data[1]^data[0];
  data_out[3]=data[2];
  data_out[2]=data[1];
  data_out[1]=data[0];
  data_out[0]=data_out[1]^data_out[2]^data_out[3]^data_out[4]^data_out[5]^data_out[6]^data_out[7];
  out.Send(data_out);
  end
endmodule // hamming_gen
module hamming_dec (interface data_in,interface data_out,interface error);
  logic[2:0] C;
  logic D;
  logic e;
  logic s;
  logic[3:0] d;
  logic[7:0] data;
  always begin
      data_in.Receive(data);
      e=0;
      C[0]=data[7]^data[5]^data[3]^data[1];
      C[1]=data[6]^data[5]^data[2]^data[1];
      C[2]=data[4]^data[3]^data[2]^data[1];
      D=data[0]^data[1]^data[2]^data[3]^data[4]^data[5]^data[6]^data[7];
      if(C==0&&D==0) begin
          d={data[5],data[3],data[2],data[1]};
        end
        else if(C==0&&D==1)begin
        d={data[5],data[3],data[2],data[1]};
        $display("Error Dectected But Corrected,Error bit is %d",(0));
        end
        else if(C!=0&&D==1)begin
          $display("Error Dectected But Corrected,Error bit is %d",(8-C));
          case(C)
          3'b111: d={data[5],data[3],data[2],~data[1]};
          3'b110: d={data[5],data[3],~data[2],data[1]};
          3'b101: d={data[5],~data[3],data[2],data[1]};
          3'b011: d={~data[5],data[3],data[2],data[1]};
          default: d={data[5],data[3],data[2],data[1]};
          endcase
        end
        else begin
        $display("A double bit error Dectected, cannot be Corrected");
        e=1;
        end
        data_out.Send(d);
        error.Send(e);
  end
endmodule // hamming_dec

module data_generator (interface r,interface send,interface hamming,output integer sa);
  parameter WIDTH = 8;
  parameter addrWIDTH=4;
  parameter FL = 0; //ideal environment
  parameter ADDR=0;
  parameter n=WIDTH/8;
  logic [WIDTH/2-1:0] Value=0;
  logic [WIDTH-1:0] SendValue=0;
  logic [addrWIDTH-1:0] addr=ADDR,SendAddr;
  logic s=0;
  integer ct=0;
  always
  begin
    sa=ct;
    //add a display here to see when this module starts its main loop
    if(s==0) begin
      r.Send({addr,{addrWIDTH{1'b1}}});
      s=1;
    end
    else begin
      Value = $random() % (2**(WIDTH/2));
      send.Send(Value);
      hamming.Receive(SendValue);
      //SendAddr={addr[addrWIDTH-1:1],~addr[0]};
      SendAddr=$random() % (2**addrWIDTH);
      //wait(addr==0);
      if(SendAddr[3:0]!=addr[3:0])begin
        //Communication action Send is about to start
        $display("%m From:%H To:%H.Send %H %H time:%d",addr,SendAddr[3:0],SendValue,Value,$time);
        r.Send({{addrWIDTH-4{1'b0}},SendAddr[3:0],SendValue});
        //Communication action Send is finished
        ct=ct+1;

      end
    end
  end
endmodule

module data_bucket (interface r,interface hamming, interface value,interface e,output integer ra);
  parameter WIDTH = 8;
  parameter addrWIDTH=4;
  parameter BL = 0; //ideal environment
  parameter ADDR=0;
  parameter n=WIDTH/8;
  logic [addrWIDTH-1:0] addr=ADDR;
  logic [addrWIDTH+WIDTH-1:0] ReceiveValue = 0;
  logic [WIDTH/2-1:0] Value=0;
  logic error;
  integer ct=0;
  always
  begin
	//$display("Start module data_bucket and time is %d", $time);
    //Save the simulation time when Receive starts
    ra=ct;
    r.Receive(ReceiveValue);
    hamming.Send(ReceiveValue[WIDTH-1:0]);
    fork
    value.Receive(Value);
    e.Receive(error);
    join
    if(error==1) begin
      $display("error bit Dectected");
    end
    if(addr==ReceiveValue[addrWIDTH+WIDTH-1:WIDTH])begin
    $display("%m %H.Receive %H %H time:%d",addr,ReceiveValue,Value,$time);
    ct=ct+1;
    end
	//$display("End module data_bucket and time is %d", $time);
  end
endmodule
module Client (interface R,interface S,output integer sa,output integer ra);
    parameter WIDTH = 8;
    parameter addrWIDTH=4;
    parameter FL = 0; //ideal environment
    parameter ADDR=0;
    Channel #(.WIDTH(WIDTH+addrWIDTH),.hsProtocol(P4PhaseBD)) intf  [4:0] ();
    data_generator #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH),.FL(FL),.ADDR(ADDR)) dg(S,intf[0],intf[1],sa);
    hamming_gen hg(intf[0],intf[1]);
    data_bucket #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH),.ADDR(ADDR)) db(R,intf[2],intf[3],intf[4],ra);
    hamming_dec hd(intf[2],intf[3],intf[4]);
endmodule // Client
