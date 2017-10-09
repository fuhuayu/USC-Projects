
module hamming_gen (input[3:0] data,output[7:0] out,output status);
  logic[7:0] data_out;
  logic s;
  always @ ( * ) begin
  s=0;
  data_out[7]=data[3]^data[2]^data[0];
  data_out[6]=data[3]^data[1]^data[0];
  data_out[5]=data[3];
  data_out[4]=data[2]^data[1]^data[0];
  data_out[3]=data[2];
  data_out[2]=data[1];
  data_out[1]=data[0];
  data_out[0]=data_out[1]^data_out[2]^data_out[3]^data_out[4]^data_out[5]^data_out[6]^data_out[7];
  s=1;
  end
  assign out=data_out;
  assign status=s;
endmodule // hamming_gen
module hamming_dec (input[7:0] data,output[3:0] data_out,output error,output status);
  logic[2:0] C;
  logic D;
  logic e;
  logic s;
  logic[3:0] d;
  always @ ( data ) begin
  s=0;
  C[0]=data[7]^data[5]^data[3]^data[1];
  C[1]=data[6]^data[5]^data[2]^data[1];
  C[2]=data[4]^data[3]^data[2]^data[1];
  D=data[0]^data[1]^data[2]^data[3]^data[4]^data[5]^data[6]^data[7];
  if(C==0&&D==0) begin
      d={data[5],data[3],data[2],data[1]};
      e=0;
    end
    else if(C==0&&D==1)begin
    d={data[5],data[3],data[2],data[1]};
    e=0;
    $display("Error Dectected But Corrected,Error bit is %d",(0));
    end
    else if(C!=0&&D==1)begin
      e=0;
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
    d=4'bxxxx;
    e=1;
    end
    s=1;
  end
  assign data_out=d;
  assign error=e;
  assign status=s;
endmodule // hamming_dec

module data_generator (interface r);
  parameter WIDTH = 8;
  parameter addrWIDTH=4;
  parameter FL = 0; //ideal environment
  parameter ADDR=0;
  parameter n=WIDTH/8;
  logic [WIDTH/2-1:0] Value=0;
  logic [WIDTH-1:0] SendValue=0;
  logic [addrWIDTH-1:0] addr=ADDR,SendAddr;
  wire[n-1:0] status;
  genvar i;
  generate
  for(i=0;i<n;i=i+1)
    hamming_gen hg(Value[4*(i+1)-1:4*i],SendValue[8*(i+1)-1:8*i],status[i]);
  endgenerate
  initial begin
    r.Send({addr,{addrWIDTH{1'b1}}});
  end
  always
  begin
    //add a display here to see when this module starts its main loop

    Value = $random() % (2**(WIDTH/2));
    SendAddr=$random() % (2**addrWIDTH);
    if(SendAddr[3:0]!=addr[3:0])begin
      #FL;
      wait(status=={n{1'b1}});
      //Communication action Send is about to start
      $display("%m %H.Send %H %H",SendAddr[3:0],SendValue,Value);
      r.Send({{addrWIDTH-4{1'b0}},SendAddr[3:0],SendValue});
      //Communication action Send is finished
    end
  end
endmodule

module data_bucket (interface r);
  parameter WIDTH = 8;
  parameter addrWIDTH=4;
  parameter BL = 0; //ideal environment
  parameter ADDR=0;
  parameter n=WIDTH/8;
  logic [addrWIDTH-1:0] addr=ADDR;
  logic [addrWIDTH+WIDTH-1:0] ReceiveValue = 0;
  logic [WIDTH/2-1:0] Value=0;
  wire[n-1:0] status,error;
  genvar i;
  generate
  for(i=0;i<n;i=i+1)
    hamming_dec hd(ReceiveValue[8*(i+1)-1:8*i],Value[4*(i+1)-1:4*i],error[i],status[i]);
  endgenerate
  always
  begin
	//$display("Start module data_bucket and time is %d", $time);
    //Save the simulation time when Receive starts
    r.Receive(ReceiveValue);
    #BL;
    #0.1;
    wait(status=={n{1'b1}});
    $display("%m %H.Receive %H %H",addr,ReceiveValue,Value);
	//$display("End module data_bucket and time is %d", $time);
  end
endmodule
module Client (interface R,interface S);
    parameter WIDTH = 8;
    parameter addrWIDTH=4;
    parameter FL = 0; //ideal environment
    parameter ADDR=0;
    data_generator #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH),.FL(FL),.ADDR(ADDR)) dg(S);
    data_bucket #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH),.ADDR(ADDR)) db(R);
endmodule // Client

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
      C[0]=data[7]^data[5]^data[3]^data[1];
      C[1]=data[6]^data[5]^data[2]^data[1];
      C[2]=data[4]^data[3]^data[2]^data[1];
      D=data[0]^data[1]^data[2]^data[3]^data[4]^data[5]^data[6]^data[7];
      if(C==0&&D==0) begin
          d={data[5],data[3],data[2],data[1]};
          e=0;
        end
        else if(C==0&&D==1)begin
        d={data[5],data[3],data[2],data[1]};
        e=0;
        $display("Error Dectected But Corrected,Error bit is %d",(0));
        end
        else if(C!=0&&D==1)begin
          e=0;
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

module data_generator (interface r,interface send,interface hamming);
  parameter WIDTH = 8;
  parameter addrWIDTH=4;
  parameter FL = 0; //ideal environment
  parameter ADDR=0;
  parameter n=WIDTH/8;
  logic [WIDTH/2-1:0] Value=0;
  logic [WIDTH-1:0] SendValue=0;
  logic [addrWIDTH-1:0] addr=ADDR,SendAddr;
  logic s;

  always
  begin
    //add a display here to see when this module starts its main loop
    if(s==0) begin
      r.Send({addr,{addrWIDTH{1'b1}}});
      s=1;
    end
    else begin
      Value = $random() % (2**(WIDTH/2));
      send.Send(Value);
      hamming.Receive(SendValue);
      SendAddr=$random() % (2**addrWIDTH);
      if(SendAddr[3:0]!=addr[3:0])begin
        #FL;
        //Communication action Send is about to start
        $display("%m %H.Send %H %H",SendAddr[3:0],SendValue,Value);
        r.Send({{addrWIDTH-4{1'b0}},SendAddr[3:0],SendValue});
        //Communication action Send is finished
      end
    end
  end
endmodule

module data_bucket (interface r,interface hamming, interface value,interface e);
  parameter WIDTH = 8;
  parameter addrWIDTH=4;
  parameter BL = 0; //ideal environment
  parameter ADDR=0;
  parameter n=WIDTH/8;
  logic [addrWIDTH-1:0] addr=ADDR;
  logic [addrWIDTH+WIDTH-1:0] ReceiveValue = 0;
  logic [WIDTH/2-1:0] Value=0;
  logic error;
  always
  begin
	//$display("Start module data_bucket and time is %d", $time);
    //Save the simulation time when Receive starts
    r.Receive(ReceiveValue);
    hamming.Send(ReceiveValue[WIDTH-1:0]);
    fork
    value.Receive(Value);
    e.Receive(error);
    join
    if(error==0) begin
      $display("error bit Dectected");
    end
    $display("%m %H.Receive %H %H",addr,ReceiveValue,Value);
	//$display("End module data_bucket and time is %d", $time);
  end
endmodule
module Client (interface R,interface S);
    parameter WIDTH = 8;
    parameter addrWIDTH=4;
    parameter FL = 0; //ideal environment
    parameter ADDR=0;
    Channel #(.WIDTH(WIDTH+addrWIDTH),.hsProtocol(P4PhaseBD)) intf  [4:0] ();
    data_generator #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH),.FL(FL),.ADDR(ADDR)) dg(S,intf[0],intf[1]);
    hamming_gen hg(intf[0],intf[1]);
    data_bucket #(.WIDTH(WIDTH),.addrWIDTH(addrWIDTH),.ADDR(ADDR)) db(R,intf[2],intf[3],intf[4]);
    hamming_dec hd(intf[2],intf[3],intf[4]);
endmodule // Client
