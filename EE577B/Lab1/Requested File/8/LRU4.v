//-----------------------------------------------------
// This is FSM demo program using always block
// Design Name : fsm_using_always
// File Name   : fsm_using_always.v
//-----------------------------------------------------
module arbiter_LRU4 (
grant_vector, req_vector, enable , clk, reset
);
//-------------Input Ports-----------------------------
output [3:0] grant_vector;
input [3:0] req_vector;
input clk, reset, enable;
//-------------Input ports Data Type-------------------
wire    clk,reset,enable;
wire [3:0] req_vector;
//-------------Output Ports Data Type------------------
reg [3:0] grant_vector,taken,swap;
reg[15:0] pirority;
always @ (posedge clk)
begin
  if(reset==1)begin
    grant_vector=0;
    taken=0;
    pirority=16'h1234;
  end
  else begin
    if (enable==1&&req_vector>0) begin
      case (pirority[15:12])
        4'h1:if (req_vector[0]) begin
            taken=1;
            grant_vector=4'b0001;
          end
          else taken=0;
        4'h2:if (req_vector[1]) begin
            taken=1;
            grant_vector=4'b0010;
          end
          else taken=0;
        4'h3:if (req_vector[2]) begin
            taken=1;
            grant_vector=4'b0100;
          end
          else taken=0;
        4'h4:if (req_vector[3]) begin
            taken=1;
            grant_vector=4'b1000;
          end
          else taken=0;
      endcase
      if (taken==0) begin
        case (pirority[11:8])
          4'h1:if (req_vector[0]) begin
              taken=2;
              grant_vector=4'b0001;
            end
            else taken=0;
          4'h2:if (req_vector[1]) begin
              taken=2;
              grant_vector=4'b0010;
            end
            else taken=0;
          4'h3:if (req_vector[2]) begin
              taken=2;
              grant_vector=4'b0100;
            end
            else taken=0;
          4'h4:if (req_vector[3]) begin
              taken=2;
              grant_vector=4'b1000;
            end
            else taken=0;
        endcase
      end
      if (taken==0) begin
        case (pirority[7:4])
          4'h1:if (req_vector[0]) begin
              taken=3;
              grant_vector=4'b0001;
            end
            else taken=0;
          4'h2:if (req_vector[1]) begin
              taken=3;
              grant_vector=4'b0010;
            end
            else taken=0;
          4'h3:if (req_vector[2]) begin
              taken=3;
              grant_vector=4'b0100;
            end
            else taken=0;
          4'h4:if (req_vector[3]) begin
              taken=3;
              grant_vector=4'b1000;
            end
            else taken=0;
        endcase
      end
      if (taken==0) begin
        case (pirority[3:0])
          4'h1:if (req_vector[0]) begin
              taken=4;
              grant_vector=4'b0001;
            end
          4'h2:if (req_vector[1]) begin
              taken=4;
              grant_vector=4'b0010;
            end
          4'h3:if (req_vector[2]) begin
              taken=4;
              grant_vector=4'b0100;
            end
          4'h4:if (req_vector[3]) begin
              taken=4;
              grant_vector=4'b1000;
            end
        endcase
      end

      if (taken==1) begin
        swap=pirority[15:12];
        pirority<={pirority[11:0],swap};
      end else if (taken==2) begin
        swap=pirority[11:8];
        pirority<={pirority[15:12],pirority[7:0],swap};
      end else if (taken==3) begin
        swap=pirority[7:4];
        pirority<={pirority[15:8],pirority[3:0],swap};
      end
    end
    else
      begin
      grant_vector=0;
    end
  end
end // End Of Block OUTPUT_LOGIC

endmodule // End of Module arbiter
