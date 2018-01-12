`include "/home/scf-12/ee552/proteus/pdk/proteus/svc2rtl.sv"
module hamming_dec_csp_gold (interface data_in,interface data_out,interface error);
  logic[2:0] C=0;
  logic e=0;
  logic D=0;
  logic s=0;
  logic[3:0] d=0;
  logic[7:0] data=0;
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
