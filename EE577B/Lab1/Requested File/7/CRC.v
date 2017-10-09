//-----------------------------------------------------
// This is FSM demo program using always block
// Design Name : fsm_using_always
// File Name   : fsm_using_always.v
//-----------------------------------------------------
module CRC (
in,clk,rst,out
);
//-------------Input Ports-----------------------------
input[31:0] in;
input   clk,rst;
 //-------------Output Ports----------------------------
output[35:0]  out;
//-------------Input ports Data Type-------------------
wire    clk,rst;
//-------------Output Ports Data Type------------------
reg[35:0]  out;
reg[31:0]  temp;
integer i;
always @ (posedge clk)
begin

  if (rst) begin
    out<=0;
  end
  else begin
    temp=in;
    for(i=0;i<32;i=i+1) begin
      if(temp[31]) begin
        temp[31:27]=temp[31:27]^5'b10011;
      end
      temp=temp<<1;
    end
    out[35:4]<=in;
    out[3:0]<=temp[31:28];
  end
end // End Of Block OUTPUT_LOGIC

endmodule // End of Module arbiter
