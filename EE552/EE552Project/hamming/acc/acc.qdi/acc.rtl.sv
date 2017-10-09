`include "/home/scf-12/ee552/proteus/pdk/proteus/svc2rtl.sv"
`E1OFN_M(2,16)
        //--------RTL module--------
        module  acc_RTL    ( interface   A     , interface   Sum      , input    CLK      , input    _RESET       )  ;
parameter WIDTH    = 16           ;
logic  [ A        . W              -  1       : 0       ]    a    , ff$a      ;
logic  [ Sum        . W              -  1       : 0       ]    sum    , ff$sum      ;
always_ff  @ ( posedge  CLK         , negedge  _RESET          )
  begin
   if ( !  _RESET          )
   begin
    ff$sum        <= 0       ;
   end
   else
   begin
    ff$a        <= a         ;
    ff$sum        <= sum         ;
   end
  end
  always_comb
   begin
    A        . InitDo          ;
    Sum        . InitDo          ;
    Sum        . InitData          ;
    a        =  ff$a          ;
    sum        =  ff$sum          ;
    A        . Receive     ( a          )      ;
    sum        =  sum        +  a           ;
    Sum        . Send     ( sum          )      ;
   end
   endmodule    //--------------------------
     //------Wrapper module------
     module  acc    ( e1of2_16    . In      A     , e1of2_16    . Out      Sum      , input    CLK      , input    _RESET       )  ;
parameter WIDTH    = 16           ;
rtl_interface    # ( . M    ( A    .  M          ) , . N    ( A    .  N          )   )  RTL_A     (    )  ;
RECV_M_1ofN    # ( . M    ( A    .  M          ) , . N    ( A    .  N          )   )  A_RECEIVE     ( A    .  In         , RTL_A    .  RcvOut           )  ;
rtl_interface    # ( . M    ( Sum    .  M          ) , . N    ( Sum    .  N          )   )  RTL_Sum     (    )  ;
SEND_M_1ofN    # ( . M    ( Sum    .  M          ) , . N    ( Sum    .  N          )   )  Sum_SEND     ( RTL_Sum    .  SndIn         , Sum    .  Out           )  ;
acc_RTL    # ( . WIDTH    ( WIDTH          )   )  acc_RTL_BODY     ( . A    ( RTL_A    .  RtlIn         ) , . Sum    ( RTL_Sum    .  RtlOut         ) , . CLK    ( CLK         ) , . _RESET    ( _RESET         )   )  ;
endmodule
