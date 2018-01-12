module Hamming_tb ();
  reg[3:0] data_in,data_out;
  logic[7:0] hamming_out1,hamming_out2;
  reg error;
  integer i;
  hamming_gen hg(data_in,hamming_out1);
  hamming_dec hd(hamming_out2,data_out,error);
  always begin
  begin
    data_in=$random() % (2**4);
    #1;
    for(i=0;i<8;i=i+1)begin
      hamming_out2=hamming_out1^(8'b00000001<<i);
      #1;
    end
    for(i=0;i<8;i=i+1)begin
      hamming_out2=hamming_out1^(8'b00000101<<i);
      #1;
    end
  end
  end
endmodule // Hamming_tb
