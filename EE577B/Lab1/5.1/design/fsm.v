//-----------------------------------------------------
// This is FSM demo program using always block
// Design Name : fsm_using_always
// File Name   : fsm_using_always.v
//-----------------------------------------------------
module seq_detect (
in,clk,rst,match
);
//-------------Input Ports-----------------------------
input   in,clk,rst;
 //-------------Output Ports----------------------------
output  match;
//-------------Input ports Data Type-------------------
wire    in,clk,rst;
//-------------Output Ports Data Type------------------
reg     match;
//-------------Internal Constants--------------------------
parameter SIZE = 3           ;
parameter IDLE  = 3'b000,S0 = 3'b001,S1 = 3'b010,
S2 = 3'b011,S3 = 3'b100,S4 = 3'b101,S5 = 3'b110 ;
//-------------Internal Variables---------------------------
reg   [SIZE-1:0]          state        ;// Seq part of the FSM
reg   [SIZE-1:0]          next_state   ;// combo part of FSM

//----------SM-----------------------------
always @ (posedge clk)
begin
  if (rst == 1'b1) begin
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end
//----------NSL + OFL-----------------------------
always @ (posedge clk)
begin
case(state)
  IDLE : if (in == 1'b1) begin
               next_state = S0;
             end else begin
               next_state = IDLE;
             end
  S0 : if (in == 1'b0) begin
               next_state = S1;
             end
  S1 : if (in == 1'b1) begin
               next_state = S2;
             end else begin
               next_state = IDLE;
             end
   S2 : if (in == 1'b1) begin
                next_state = S3;
              end else begin
                next_state = S1;
              end
   S3 : if (in == 1'b1) begin
                next_state = S4;
              end else begin
                next_state = S1;
              end
  S4 : if (in == 1'b0) begin
               next_state = S5;
             end else begin
               next_state = IDLE;
             end
  S5 : if (in == 1'b1) begin
               next_state = S2;
             end else begin
               next_state = IDLE;
             end
  default : next_state = IDLE;
 endcase
if (rst == 1'b1) begin
  match<=0;
end
else begin
  if(state==S5) match<=1;
  else match<=0;
end
end // End Of Block OUTPUT_LOGIC

endmodule // End of Module arbiter
