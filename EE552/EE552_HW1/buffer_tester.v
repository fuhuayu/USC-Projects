`timescale 1ns/1ns
module buffer_tester ();
  reg in;
  integer fp; //file pointer

  buffer_non_blocking #(5,0)  g1  (out1, in);
  buffer_non_blocking #(15,0) g2  (out2, in);
  buffer_blocking     #(5,0)  g3  (out3, in);
  buffer_blocking     #(15,0) g4  (out4, in);

  buffer_non_blocking #(0,5)  g5  (out5, in);
  buffer_non_blocking #(0,15) g6  (out6, in);
  buffer_blocking     #(0,5)  g7  (out7, in);
  buffer_blocking     #(0,15) g8  (out8, in);

 
  initial 
  begin
    	fp = $fopen("buffer_tester.dump");  
	$fmonitor(fp, "%t\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t", $time, in, out1, out2, out3, out4, out5, out6, out7, out8);
  end


  initial
  begin
    in = 0 ;
    #10;  
    in = 1 ;
    #10;  
    in = 0 ;
    #10;  
    in = 1 ; 
    #10;  
  end 
endmodule

