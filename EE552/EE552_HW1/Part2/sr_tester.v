`timescale 1ns/100ps
module sr_tester;
  reg [7:0] par_in;
  reg ser_in,rst=0, clk=0;
  reg [1:0]cmd;
  wire [7:0] data_out;

  integer fp,fpp,status;
  
  initial
  begin
  	fp = $fopen("patterns.txt","r");
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
    	fpp = $fopen("sr_original.dump");  
	$fmonitor(fpp, "%t\t%d\t%d\t%d\t%d\t%d\t", $time, cmd, par_in, ser_in, data_out,rst);
  end
  //instantiate the shift register
  shift_register sr(clk, cmd, par_in, ser_in, data_out,rst);
  
  always@(posedge clk)
  begin
	if($feof(fp))
		$stop;
	status = $fscanf(fp,"%d %h %b\n", cmd, par_in, ser_in);
  end  
endmodule

