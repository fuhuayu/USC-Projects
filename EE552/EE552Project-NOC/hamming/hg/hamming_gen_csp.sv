`include "/home/scf-12/ee552/proteus/pdk/proteus/svc2rtl.sv"
`E1OFN_M(2,8)
`E1OFN_M(2,4)
module hamming_gen (e1of2_4.In d,e1of2_8.Out out);
  logic[7:0] data,data_out;
  always begin
  forever begin
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
  end
endmodule // hamming_gen
