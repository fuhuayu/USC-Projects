module Calc (input integer s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,
  r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15);
  integer ts,tr;
  always @ ( * ) begin
    ts=s0+s1+s2+s3+s4+s5+s6+s7+s8+s9+s10+s11+s12+s13+s14+s15;
    tr=r0+r1+r2+r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+r13+r14+r15;
    $display("total packet sent:%d total packet receive:%d total packet in network:%d",ts,tr,ts-tr);
  end

endmodule // calc
