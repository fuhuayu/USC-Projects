//-----------------------------------------------------
// This is FSM demo program using always block
// Design Name : fsm_using_always
// File Name   : fsm_using_always.v
//-----------------------------------------------------
module CLK_MUX (
t_sel,clk1,clk2,clk3,clk4,t_clk1,t_clk2,t_clk3,t_clk4
);
//-------------Input Ports-----------------------------
input   clk1,clk2,clk3,clk4;
input[1:0]   t_sel;
 //-------------Output Ports----------------------------
output  t_clk1,t_clk2,t_clk3,t_clk4;
//-------------Input ports Data Type-------------------
wire    clk1,clk2,clk3,clk4;
wire[1:0]   t_sel;
//-------------Output Ports Data Type------------------
reg  t_clk1,t_clk2,t_clk3,t_clk4;
always @ (t_sel or clk1)
begin
  case (t_sel)
    2'b00:t_clk2=clk1;
    2'b01:t_clk3=clk1;
    2'b10:t_clk4=clk1;
    2'b11:t_clk1=clk1;
  endcase
end // End Of Block OUTPUT_LOGIC
always @ (t_sel or clk2)
begin
  case (t_sel)
    2'b00:begin t_clk1=clk2;t_clk3=clk2;
    end
    2'b11:t_clk2=clk2;
  endcase
end // End Of Block OUTPUT_LOGIC
always @ (t_sel or clk3)
begin
  case (t_sel)
    2'b01:begin t_clk1=clk3;t_clk2=clk3;
    end
    2'b10:t_clk2=clk3;
    2'b11:t_clk4=clk3;
  endcase
end // End Of Block OUTPUT_LOGIC
always @ (t_sel or clk4)
begin
  case (t_sel)
    2'b00:t_clk4=clk4;
    2'b01:t_clk4=clk4;
  endcase
end // End Of Block OUTPUT_LOGIC

endmodule // End of Module arbiter
