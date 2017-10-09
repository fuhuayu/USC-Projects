//-----------------------------------------------------
// This is FSM demo program using always block
// Design Name : fsm_using_always
// File Name   : fsm_using_always.v
//-----------------------------------------------------
module keyboard (
clk,reset,in_en,n,out_en,out
);
//-------------Input Ports-----------------------------
input   clk,reset,in_en;
input[3:0] n;
 //-------------Output Ports----------------------------
output  out_en,out;
//-------------Input ports Data Type-------------------
wire    clk,reset,in_en;
wire[3:0] n;
//-------------Output Ports Data Type------------------
reg  out_en;
reg[3：0] out,rec;
always @ (t_sel or clk1)
begin
  if (reset) begin
    out_en=0;
    out=0;
  end
  else
    if(n) begin
      in_en=1;
      if(n[2:0]==0)begin rec=n>>3; out=3; end
      else if (n[2:0]==0)begin rec=n>>2; out=2; end
      else if (n[2:0]==0)begin rec=n>>1; out=1; end
      out_en<=1;
      out<=out+rec;
    end
  end
end // End Of Block OUTPUT_LOGIC
endmodule // End of Module arbiter
