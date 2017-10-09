`timescale 1ns/100ps
module mult_tester();
  reg [1:0] a;
  reg [1:0] b;
  reg clk=0;
  wire [3:0] out;
  integer fp,fpp,status;
  
  initial
  begin
    fp = $fopen("multi_patterns.txt","r");
    

   if(!fp)
   begin
       $display("File cannot be opened!");
       $stop;
   end

  end

 
  //generate clock
  always begin 
    # 10 clk = ~ clk ;
  end
initial 
  begin
  fpp = $fopen("multi.dump");
    $fmonitor(fpp, "%t\t%b\t%b\t%b\t", $time, a, b, out);
	end
  //instantiate the shift register
  mult m1(a, b, out);

  always@(posedge clk)
  begin
	if($feof(fp))
		$stop;
	status = $fscanf(fp,"%d %d\n", a, b);
  end  
endmodule