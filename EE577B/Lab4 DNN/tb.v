module tb ();
  parameter width=4;
  parameter l1=4;
  parameter l2=3;
  parameter l3=5;
  parameter l4=0;
  parameter l5=0;
  integer file1,file2,file3,a,i,total,n,numread,ct;
  reg clk,reset,start;
  reg [15:0] din;
  reg [(l1*l2+l2*l3+l4*l5)*width-1:0] w;
  wire ready;
  wire[15:0] out;
  generate
  mcp #(width,l1,l2,l3,l4,l5) m(clk,reset,start,din,w,ready,out);
  endgenerate
  initial begin
    file1 = $fopen("DNN.txt","r");
    file2 = $fopen("input.txt","r");
    file3 = $fopen("output.txt","w");
    a=$fscanf(file1,"%d %d %d %d %d\n",l1,l2,l3,l4,l5);
    a=$fscanf(file1,"%d\n",width);
    total=l1*l2+l2*l3+l4*l5;
    for(i=0;i<total;i=i+1)begin
      a=$fscanf(file1,"%h\n",n);
      w[(i+1)*width-1-:width]=n;
    end
    if(l5>0) numread=l5;
    else if(l4>0) numread=l4;
    else if(l3>0) numread=l3;
    else if(l2>0) numread=l2;
    else if(l1>0) numread=l1;
    clk=0;
    reset=1;
    start=0;
    din=16'h1234;
    #10;
    reset=0;
  end
  always @ ( clk ) begin
    clk<=#0.5 ~clk;
  end
  always @ ( posedge clk ) begin
    if(reset)begin
      ct=0;
      start=0;
      reset<=~reset;
    end
    else if(ready) begin
      if(ct<numread) begin $fwrite(file3,"%h,",out);ct=ct+1;end
      else begin reset<=1;$fwrite(file3,"\n");end
    end
    else if(start==0) begin
      start<=1;
      a=$fscanf(file2,"%h\n",din);
    end
  end
  assign out[15:width]=0;

endmodule // tb
