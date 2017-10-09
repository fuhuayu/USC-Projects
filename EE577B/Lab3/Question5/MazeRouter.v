//-----------------------------------------------------
// Design Name : Maze Router
// File Name   : MazeRouter.v
// Authors	   : Yang Zhang
// Function    : Read "map" saved inside RAM and output routing
//-----------------------------------------------------
`timescale 1ns/10ps
module maze_router (
reset		,
start		,
clk         , // Clock Input
address     , // Address Output
data_in        , // Data
data_out,
cs          , // Chip Select
we          , // Write Enable/Read Enable
D			// Set the This signal tell testbench to prinout the content of SRAM
);

parameter DATA_WIDTH = 8 ;
parameter ADDR_WIDTH = 8 ;

//------------Input---------------
input					reset		;
input 					start	;
input                  clk         ;


input [DATA_WIDTH-1:0]  data_in;

//------------output---------------
output                  cs          ;
output                  we          ;
output [DATA_WIDTH-1:0]  data_out       ;
output [ADDR_WIDTH-1:0] address     ;
output D;

reg cs,we;
reg [DATA_WIDTH-1:0]  data_out,currDataIn;
reg [ADDR_WIDTH-1:0] address,currAddress;
reg D,addrLock,Rlock,wT,wS;
reg[1:0] Setup;
reg[4:0] states;
reg[5:0] S,T,location;
reg[3:0] distance;
reg[5:0] grid [63:0];
reg pgrid [63:0];
reg[(6*30-1):0] RN,RO;
integer nc,oc;
integer i,j,file,lcounter,pcounter;
reg[3:0] locTrig,pLoc;//which loc can be searched.
reg[2:0] direct;
//--------------Code Starts Here------------------
//-----manhattan distance
function automatic [3:0] manhattan_distance;
input[5:0] locA, locB;
reg[5:0] rA,rB,qA,qB,h,w;
begin
  rA=locA%8;
  rB=locB%8;
  qA=locA/8;
  qB=locB/8;
  h=qA>qB?qA-qB:qB-qA;
  w=rA>rB?rA-rB:rB-rA;
  manhattan_distance=w+h;
end
endfunction
function automatic [3:0] get_closer;//closer direction;
input[5:0] loc;
reg up,down,left,right;
reg[5:0] uploc,downloc,leftloc,rightloc;
begin
  uploc=loc>7?loc-8:loc;
  downloc=loc<56?loc+8:loc;
  leftloc=loc>0?loc-1:loc;
  rightloc=loc<63?loc+1:loc;
  up=manhattan_distance(uploc,T)<manhattan_distance(loc,T)?1:0;
  down=manhattan_distance(downloc,T)<manhattan_distance(loc,T)?1:0;
  left=manhattan_distance(leftloc,T)<manhattan_distance(loc,T)?1:0;
  right=manhattan_distance(rightloc,T)<manhattan_distance(loc,T)?1:0;
  get_closer={up,down,left,right};
end
endfunction
function automatic [5:0] getNewLoc;
input[5:0] loc;
input[2:0] direction;
begin
  case(direction)
    1:getNewLoc=loc-8;
    2:getNewLoc=loc+8;
    3:getNewLoc=loc-1;
    4:getNewLoc=loc+1;
  endcase
end
endfunction
function checkValid;
input[5:0] loc;
input[2:0] direction;
begin
  case(direction)
    1:checkValid=loc>7?1:0;
    2:checkValid=loc<56?1:0;
    3:checkValid=loc>0?1:0;
    4:checkValid=loc<63?1:0;
  endcase
end
endfunction

function automatic [1:0] checkP;//0 not placeable, 1 placeable, 2 T
input [5:0] loc;
  begin
    if(grid[loc][5:4]!=2) begin
      if(grid[loc][3:0]==7||grid[loc][3:0]==5) checkP=0;
      else if(grid[loc][3:0]==6) checkP=2;
      else checkP=1;
    end
    else checkP=0;
  end
endfunction
reg[2:0] direction_line,invdirect_line;
reg[5:0] nloc_line;
reg[2:0] direction_lee,invdirect_lee;
reg[5:0] nloc_lee;
reg[5:0] loc_s2;
reg[2:0] invdirect_s2;
reg[5:0] nloc_s2;
reg[3:0] p_s2;
reg v_s2;
always@(clk)
begin
if(clk==0)begin
  if (reset) begin
    cs<=0;
    we<=0;
    data_out<=0;
    address<=0;
    D=0;
    states<=0;
    Setup<=0;
    lcounter=1;
    pcounter=1;
    RO<=0;
    RN<=0;
    nc<=0;
    oc<=0;
    wT<=0;
    wS<=0;
    addrLock=0;
    locTrig=0;
    for(i=0;i<64;i=i+1) grid[i]<=0;
  end
  else begin
    if(cs==1)begin
      if(grid[address]==0)begin
        case(data_in)
         16'hee:grid[address][3:0]<=8;
         16'hff:grid[address][3:0]<=7;
        endcase
      end
    end
    case (states)
      0: begin
        if (start && (Setup==0)) begin
          Setup<=Setup+1;
        end
        if (Setup==1) begin
          Setup<=Setup+1;
        end else if (Setup==2) begin
          Setup<=Setup+1;
        end else if (Setup==3) begin
          states<=1;
        end
        if (Setup==1) begin
          cs<=1;
          address<=128;
        end
        else if (Setup==2) begin
          S=data_in;
          grid[S][3:0]<=5;
          grid[S][5:4]<=2;
          RO<=(RO<<6)+S;
          oc<=oc+1;
          address<=129;
        end
        else if (Setup==3) begin
          T=data_in;
          grid[T]<=6;
        end
      end
      1: begin//search decision
        if(oc!=0||locTrig!=0)begin
          if(locTrig==0)begin
            location=RO[(oc*6-1)-:6];

            locTrig=4'b1111;
            case(grid[location][2:0])
              1:locTrig=4'b0111;
              2:locTrig=4'b1011;
              3:locTrig=4'b1101;
              4:locTrig=4'b1110;
            endcase
            pLoc<=get_closer(location)&locTrig;
          end
          else if(pLoc!=0)begin
            if (pLoc[3]) begin
            direction_line=1;
            invdirect_line=2;
            end
            else if (pLoc[2]) begin
            direction_line=2;
            invdirect_line=1;
            end
            else if (pLoc[1]) begin
            direction_line=3;
            invdirect_line=4;
            end
            else if (pLoc[0]) begin
            direction_line=4;
            invdirect_line=3;
            end
            nloc_line=getNewLoc(location,direction_line);
            if(grid[nloc_line]==0) begin
              if(addrLock==0)begin
                address<=nloc_line;
                addrLock=1;
              end
            end else begin
              addrLock=0;
              pLoc[4-direction_line]<=0;
              locTrig[4-direction_line]=0;
              if(locTrig==0) oc<=oc-1;
              if(Rlock==0)begin
                case(checkP(nloc_line))
                  1:begin
                  Rlock=1;
                  direct=direction_line;
                  locTrig=0;
                  states<=2;//line search
                  end
                  2:begin
                  Rlock=1;
                  location=nloc_line;
                  states<=3;//result
                  grid[nloc_line]<={3'b100,invdirect_line};
                  RO[(oc*6)+:6]<=nloc_line;
                  oc<=oc+1;
                  end
                endcase
              end
            end
          end
          else if(locTrig!=0)begin
              if (locTrig[3]) begin
                direction_lee=1;
                invdirect_lee=2;
              end
              else if (locTrig[2]) begin
              direction_lee=2;
              invdirect_lee=1;
              end
              else if (locTrig[1]) begin
              direction_lee=3;
              invdirect_lee=4;
              end
              else if (locTrig[0]) begin
              direction_lee=4;
              invdirect_lee=3;
              end
              if(checkValid(location,direction_lee))begin
                nloc_lee=getNewLoc(location,direction_lee);
                if(grid[nloc_lee]==0) begin
                  if(addrLock==0)begin
                    address<=nloc_lee;
                    addrLock=1;
                  end
                end else begin
                  addrLock=0;
                  locTrig[4-direction_lee]=0;
                  if(locTrig==0) oc<=oc-1;
                  if(Rlock==0)begin
                    case(checkP(nloc_lee))
                      1:begin
                      Rlock=1;
                      RN<=(RN<<6)+nloc_lee;
                      if(grid[nloc_lee][5:4]==0) grid[nloc_lee]<={3'b010,invdirect_lee};
                      nc<=nc+1;
                      end
                    endcase
                  end
                end
              end
              else begin
              locTrig[4-direction_lee]=0;
              if(locTrig==0) oc<=oc-1;
              end
          end
          Rlock=0;
        end
        else begin
          oc<=nc+oc;
          RO<=(RO<<(nc*6))+RN;
          nc<=0;
          RN<=0;
        end
      end
      2:begin
        addrLock=0;
        if(nc>0)begin
          oc<=nc+oc;
          RO<=(RO<<(nc*6))+RN;
          nc<=0;
          RN<=0;
        end
        else begin
          case(direct)
          1:begin loc_s2=getNewLoc(location,direct);invdirect_s2=2;end
          2:begin loc_s2=getNewLoc(location,direct);invdirect_s2=1;end
          3:begin loc_s2=getNewLoc(location,direct);invdirect_s2=4;end
          4:begin loc_s2=getNewLoc(location,direct);invdirect_s2=3;end
          endcase
          v_s2=checkValid(loc_s2,direct);
          if(v_s2)begin
            nloc_s2=getNewLoc(loc_s2,direct);
            if(grid[nloc_s2]==0) begin
              address<=nloc_s2;
            end else begin
              case (checkP(nloc_s2))
                0:states<=1;
                1:begin
                  p_s2=get_closer(loc_s2);
                  if(p_s2[4-direct]==1)location=loc_s2;
                  else states<=1;
                end
                2:states<=3;
              endcase
              grid[loc_s2]<={3'b100,invdirect_s2};
              RO[(oc*6)+:6]<=loc_s2;
              location=loc_s2;
              oc<=oc+1;
            end
          end
          else begin
            states<=1;
            grid[loc_s2]<={3'b100,invdirect_s2};
            RO[(oc*6)+:6]<=loc_s2;
            oc<=oc+1;
          end


        end
      end
      3:begin
        we<=1;
        data_out<=0;
        if(location==S)begin
          if(wS==1)D=1;
          else begin
            wS<=1;
            address<=S;
          end
        end
        else if(wT==0) begin
          wT<=1;
          address<=T;
        end else begin
          address<=location;
          location=getNewLoc(location,grid[location][2:0]);
        end
      end
    endcase
  end
end
end

endmodule // End of Module
