`include "/home/scf-12/ee552/proteus/pdk/proteus/svc2rtl.sv"
module hamming_gen_csp_gold (interface d,interface out);
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
