// /////////////////////////////////////////////////////////////////////
// // 
// // Filename        : ddr2_ring_buffer.v
// // Description     : DDR2 8 deep input ring buffer 
// //                   Strobe filter and a delay line for strobe
// // Author          : Rashed Bhatti
// // Modified	       : Tzu-Ching Lin
// /////////////////////////////////////////////////////////////////////
`timescale 1ns/10ps
//`include "/home/scf-26/zihaoyua/Final_project/DDR3_RTL_folder/gscl45nm.v"

module ddr3_ring_buffer8(dout,listen,strobe,readPtr,din,reset);
   input listen;   // A cycle long pulse after which ring buffer would start paying attention towards the incoming strobe
   input strobe;   // After listen the ring buffer would capture 4 data at every edges of strobe
   input reset;
   input [15:0]  din;
   input [1:0] 	 readPtr; // Read pointer, the contol logic should provide the read pointer
   output [15:0] dout;
 
   reg [15:0] 	 dout;   
   reg [15:0] 	 r0, r1, r2, r3;
   reg 			 F0;
   wire 		 fStrobe, fStrobeBar, fStrobe1;
   reg  	 countp, countn;
   wire [15:0]	strobe_clk;

// Delayline for strobe   
// --------------------
// To tell the sysnopsys not to remove the following delay cells 
// use the following line in constraint file
// set_dont_touch [ find cell DELAY*]
// get_attribute [ find cell DELAY*] dont_touch
    CLKBUF2 DELAY0 (.Y(dStrobe0), .A(strobe  ));
    CLKBUF2 DELAY1 (.Y(dStrobe1), .A(dStrobe0)); 
    CLKBUF2 DELAY18 (.Y(dStrobe2), .A(dStrobe1));
    CLKBUF2 DELAY19 (.Y(dStrobe3), .A(dStrobe2));
    CLKBUF2 DELAY20 (.Y(dStrobe),  .A(dStrobe3));

   							  
// strobe filter
// -------------   
//     strobe   XXXX___________/-----\_____/-----\_____/-----\_____/-----\______XXXXX
//	  
//     listen   _____/-----\______________________________________________________
//	  
//     F0       ______/----------------------------------------------------\________
//   
//     fStrobe  __________________/-----\_____/-----\_____/-----\_____/-----\________
//
//     countp    -----0000000000000000000011111111111122222222222233333333333300000000



    always @ (posedge fStrobeBar or posedge listen)
	begin
		if (listen)
		begin
		  	F0 <= 1;
		  	countn <= 0;
		end
		else
		begin
			countn <= 1;
			if (countn)
			begin
				countn<=0;
				F0<=0;
			end
		end // else: !if(listen)
	end // always @ (posedge fStrobeBar or posedge listen or posedge reset)

	always @ (posedge fStrobe1 or posedge listen)
	begin
		if (listen)
		begin
		  	countp <= 0;
		end
		else
		begin
			countp <= 1;
			if (countp)
			begin
				countp<=0;
			end
		end // else: !if(listen)
	end
   
   assign fStrobe = dStrobe & F0;
   assign fStrobeBar = ~fStrobe1;
	CLKBUF2 DELAY21 (.Y(fStrobe0), .A(fStrobe));
	CLKBUF2 DELAY22 (.Y(fStrobe1), .A(fStrobe0));
	
    CLKBUF2 DELAY2 (.Y(strobe_clk[0]), .A(fStrobe)); 
	CLKBUF2 DELAY3 (.Y(strobe_clk[1]), .A(fStrobe)); 
	CLKBUF2 DELAY4 (.Y(strobe_clk[2]), .A(fStrobe)); 
	CLKBUF2 DELAY5 (.Y(strobe_clk[3]), .A(fStrobe)); 
	CLKBUF2 DELAY6 (.Y(strobe_clk[4]), .A(fStrobe)); 
	CLKBUF2 DELAY7 (.Y(strobe_clk[5]), .A(fStrobe)); 
	CLKBUF2 DELAY8 (.Y(strobe_clk[6]), .A(fStrobe)); 
	CLKBUF2 DELAY9 (.Y(strobe_clk[7]), .A(fStrobe)); 
	CLKBUF2 DELAY10 (.Y(strobe_clk[8]), .A(fStrobe)); 
	CLKBUF2 DELAY11 (.Y(strobe_clk[9]), .A(fStrobe)); 
	CLKBUF2 DELAY12 (.Y(strobe_clk[10]), .A(fStrobe)); 
	CLKBUF2 DELAY13 (.Y(strobe_clk[11]), .A(fStrobe)); 
	CLKBUF2 DELAY14 (.Y(strobe_clk[12]), .A(fStrobe)); 
	CLKBUF2 DELAY15 (.Y(strobe_clk[13]), .A(fStrobe)); 
	CLKBUF2 DELAY16 (.Y(strobe_clk[14]), .A(fStrobe)); 
	CLKBUF2 DELAY17 (.Y(strobe_clk[15]), .A(fStrobe)); 

	genvar i;
	generate for (i=0; i<16; i=i+1)
	begin
		always @(posedge strobe_clk[i])
			case (countp)
				0: r0[i] <= din[i];
				1: r2[i] <= din[i];
			endcase

		always @(negedge strobe_clk[i])
			case (countn)
				0: r1[i] <= din[i];
				1: r3[i] <= din[i];
			endcase
	end
	endgenerate

// Read data
// ---------
   always @ (r0 or r1 or r2 or r3 or readPtr)
	 begin
		case (readPtr) 
		  3'b000: dout <= r0;
		  3'b001: dout <= r1;
		  3'b010: dout <= r2;
		  3'b011: dout <= r3;
		  default: dout <= r0;
		endcase // case (readPtr)
	 end // always (r0 or r1 or r2 or r3 or r4 or readPtr)
   
   
endmodule // ddr2_ring_buffer8

