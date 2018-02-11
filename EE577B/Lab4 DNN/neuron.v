module neuron (clk,reset,mode,in,w,out);
  parameter width = 4;
  input clk,reset;
  input wire[2:0] mode;
  input wire[width-1:0] in,w;
  output[width-1:0] out;
  wire[width-1:0] out;
  reg[31:0] value;
  always @ ( posedge clk ) begin
    if(reset) value=0;
    else begin
      case(mode)
        1: value<=value+{in,{(16-width){1'b0}}}*{w,{(16-width){1'b0}}};
        2: begin
  				if(value>500000) value <= 65535;
  				else if(value>250000) value <= 64869;
  				else if(value>150000) value <= 62577;
  				else if(value>97500) value <= 53831;
  				else if(value>92500) value <= 53079;
  				else if(value>87500) value <= 52292;
  				else if(value>82500) value <= 51467;
  				else if(value>77500) value <= 50606;
  				else if(value>72500) value <= 49708;
  				else if(value>67500) value <= 48774;
  				else if(value>62500) value <= 47805;
  				else if(value>57500) value <= 46801;
  				else if(value>52500) value <= 45764;
  				else if(value>47500) value <= 44695;
  				else if(value>42500) value <= 43595;
  				else if(value>37500) value <= 42468;
  				else if(value>32500) value <= 41316;
  				else if(value>27500) value <= 40139;
  				else if(value>22500) value <= 38943;
  				else if(value>17500) value <= 37729;
  				else if(value>12500) value <= 36501;
  				else if(value>7500) value <= 35263;
  				else if(value>2500) value <= 34017;
  				else value <= 32768;
  			end
        default: value <= value;
    endcase
  end
end
  assign out=value[15-:width];
endmodule // neuron_first
