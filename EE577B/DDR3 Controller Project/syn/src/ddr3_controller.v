module ddr3_controller(
   	// add necessary inputs/outputs to support DDR3: for example, validout, resetbar_pad, read...
   	// Outputs
   	dout, raddr, fillcount, notfull, ready, ck_pad, ckbar_pad,
   	cke_pad, csbar_pad, rasbar_pad, casbar_pad, webar_pad, ba_pad,
   	a_pad, dm_pad, odt_pad, resetbar_pad,validout,
   	// Inouts
   	dq_pad, dqs_pad, dqsbar_pad,
   	// Inputs
   	clk, reset, read, cmd, din, addr, initddr, sz, op
   	);

///////////////////////////////task1: determine the parameters ///////////////////////////////////////
   	parameter BL = 4; // Burst Lenght = (based on phase1 assignment)
   	parameter BT = 0;   // Burst Type = (based on phase1 assignment)
   	parameter CL = 5;  // CAS Latency (CL) = (based on phase1 assignment)
   	parameter AL = 3;  // Posted CAS# Additive Latency (AL) = (based on phase1 assignment)
/////////////////////////////////////////////////////////////////////////////////////////////////////

	localparam [2:0] SCR = 3'b001;
	localparam [2:0] SCW = 3'b010;
	localparam [2:0] BLR = 3'b011;
	localparam [2:0] BLW = 3'b100;
	localparam [2:0] ATR = 3'b101;
	localparam [2:0] ATW = 3'b110;

   	input 	 clk;
   	input 	 reset;
   	input 	 read;
   	input [2:0] cmd;
   	// input [1:0] sz;
   	// input [2:0] op;
   	input [15:0] din;
   	input [25:0] addr;
   	input 		 initddr;
   	output [15:0] dout;
   	output [25:0] raddr;
   	// output       validout;
   	output [5:0]  fillcount;
   	output       notfull;
   	// input        fetching;
   	output 		 ready;

   	output 		 ck_pad;
   	output 		 ckbar_pad;
   	output 		 cke_pad;
   	output 		 csbar_pad;
   	output 		 rasbar_pad;
   	output 		 casbar_pad;
   	output 		 webar_pad;
   	output [2:0]  ba_pad;
   	output [13:0] a_pad;
   	inout [15:0]  dq_pad;
   	inout [1:0] 	 dqs_pad;
   	inout [1:0] 	 dqsbar_pad;
   	output [1:0]  dm_pad;
   	output 		 odt_pad;
   	output		 resetbar_pad;
   	output reg  validout;
   	input [1:0] sz;
   	input [2:0] op;
   	wire         resetbar, resetbar_i;

   	/*autowire*/
   	// Beginning of automatic wires (for undeclared instantiated-module outputs)
   	wire [15:0]		dataOut;				// From XDFIN of fifo.v
   	wire [15:0]			dq_o;					// From XSSTL of SSTL18DDR3INTERFACE.v
   	wire [1:0]			dqs_o;					// From XSSTL of SSTL18DDR3INTERFACE.v
   	wire [1:0]			dqsbar_o;				// From XSSTL of SSTL18DDR3INTERFACE.v
   	wire					notfull;				// From XDFIN of fifo.v
   	wire [5:0]	CMD_fillcount, RETURN_fillcount;		// From XDFIN of fifo.v
	wire [5:0]	fillcount;
   	wire					full;				// From XDFIN of fifo.v
   	// End of automatics

  	//  wire 		 ri_i;
   	wire 		 ts_i;
   	reg 		 ck_i;
   	wire 		 cke_i;
   	wire 		 csbar_i;
   	wire 		 rasbar_i;
   	wire 		 casbar_i;
   	wire 		 webar_i;
   	wire [2:0] 	 ba_i;
   	wire [13:0] 	 a_i;
   	wire [15:0] 	 dq_i;
   	wire [1:0] 	 dqs_i;
   	wire [1:0] 	 dqsbar_i;
   	wire [1:0] 	 dm_i;
   	wire [1:0]    dm_pl_i;
   	wire 		 odt_i;

   	wire [1:0] dqs_pl, dqsbar_pl, dqs_init, dqsbar_init;

   	reg ck;

   	wire csbar, init_csbar;
   	wire rasbar, init_rasbar;
   	wire casbar, init_casbar;
   	wire webar, init_webar;
   	wire init_resetbar;
   	wire[2:0] ba, init_ba;
   	wire[13:0] a,init_a;
   	wire[1:0] dm;
   	wire init_cke;
   	wire ri_con;

   	wire [33:0] CMD_data_in, CMD_data_out;
   	wire [15:0] IN_data_out;
   	wire [41:0] RETURN_data_in, RETURN_data_out;
   	reg [41:0] RETURN_data_out_reg;
   	wire IN_empty, IN_full, CMD_empty, CMD_full, RETURN_empty, RETURN_full;
   	reg IN_put, CMD_put;
   	wire IN_get, CMD_get, RETURN_get, RETURN_put;
   	wire [25:0] RETURN_address;
   	wire [15:0] RETURN_data;
   	wire ts_DQ, ts_DQS;

   	// CK divider
   	always @(posedge clk)
       	if (reset==1)
	       ck_i <= 0;
	   	else
	       ck_i <= ~ck_i;  // MHz Clock (based on phase1 assignment)

///////////////////////////////task2: determine the FIFO connections ///////////////////////////////////
 	// Input data FIFO
   	FIFO #(.DEPTH_P2(5), .WIDTH(16)) FIFO_IN (/*autoinst*/
							.clk				(clk),
							.reset				(reset),
							.data_in            (din),
							.put  				(IN_put),
							.get				(IN_get),
							.data_out			(IN_data_out),
							.empty			    (IN_empty),
							.full			    (IN_full),
							.fillcount			(fillcount)
							);
	// Command FIFO
    FIFO #(.DEPTH_P2(5), .WIDTH(34)) FIFO_CMD (/*autoinst*/
							.clk				(clk),
							.reset				(reset),
							.data_in            (CMD_data_in),
							.put  				(CMD_put),
							.get				(CMD_get),
							.data_out			(CMD_data_out),
							.empty			    (CMD_empty),
							.full			    (CMD_full),
							.fillcount			(CMD_fillcount)
							);
	// Return DATA and address FIFO
	FIFO #(.DEPTH_P2(5), .WIDTH(42)) FIFO_RETURN (/*autoinst*/
							.clk				(clk),
							.reset				(reset),
							.data_in      		(RETURN_data_in),
							.put  				(RETURN_put),
							.get				(RETURN_get),
							.data_out			(RETURN_data_out),
							.empty			    (RETURN_empty),
							.full			    (RETURN_full),
							.fillcount			(RETURN_fillcount)
							);

/////////////////////////////////////////////////////////////////////////////////////////////////////

   	wire init_odt;
   	wire [1:0] init_ts_con;

   	// DDR3 Initialization engine
   	ddr3_init_engine XINIT (
						   	// Outputs
							.ready				(ready),
							.csbar				(init_csbar),
							.rasbar				(init_rasbar),
							.casbar				(init_casbar),
							.webar				(init_webar),
							.ba					(init_ba),
							.a					(init_a),
							.odt				(init_odt),
							.ts_con				(init_ts_con),
							.cke              	(init_cke),
							.resetbar         	(init_resetbar),
							.dqs_out        	(dqs_init),
							.dqsbar_out     	(dqsbar_init),
						   	// Inputs
							.clk				(clk),
							.reset				(reset),
							.init				(initddr),
							.ck					(ck_i),
							.dq          		(dq_o)
							);

	Processing_logic process_logic_ddr3(// Outputs
                			.DATA_get			(IN_get),
                			.CMD_get			(CMD_get),
                			.RETURN_put			(RETURN_put),
                			.RETURN_address		(RETURN_address),
							.RETURN_data		(RETURN_data),  //construct RETURN_data_in
                			.cs_bar				(csbar),
							.ras_bar			(rasbar),
							.cas_bar			(casbar),
							.we_bar				(webar),  // read/write function
                			.BA					(ba),
							.A					(a),
							.DM					(dm_pl_i),
                			.DQS_out			(dqs_pl),
							.DQ_out				(dq_i),
                			.ts_con				(ts_i),
                			.resetbar			(resetbar),
                			// Inputs
                			.clk				(clk),
							.ck					(ck_i),
							.reset				(reset),
							.ready				(ready),
                			.CMD_empty			(CMD_empty),
							.CMD_data_out		(CMD_data_out),
							.DATA_data_out		(IN_data_out),
                			.RETURN_full		(RETURN_full),
                			.DQS_in				(dqs_o),
							.DQ_in				(dq_o)
							);

  	assign RETURN_data_in = {RETURN_address,RETURN_data};
  	assign raddr = RETURN_data_out_reg[41:16];
  	assign dout = RETURN_data_out_reg[15:0];
  	assign CMD_data_in = {cmd,addr,op,sz};
  	assign RETURN_get = read;
  	assign notfull = !CMD_full;

  	assign dqs_i = (ready) ? dqs_pl : dqs_init;
  	assign dm_i = (ready)? dm_pl_i : 2'bXX;
   	// Output Mux for control signals
   	assign ts_DQ = (ready) ? ts_i : init_ts_con[0];
   	assign ts_DQS = (ready) ? ts_i : init_ts_con[1];
   	assign 		 a_i 	  = (ready) ? a      : init_a;
   	assign 		 ba_i 	  = (ready) ? ba     : init_ba;
   	assign 		 csbar_i  = (ready) ? csbar  : init_csbar;
   	assign 		 rasbar_i = (ready) ? rasbar : init_rasbar;
   	assign 		 casbar_i = (ready) ? casbar : init_casbar;
   	assign 		 webar_i  = (ready) ? webar  : init_webar;
   	assign      resetbar_i = (ready) ? resetbar : init_resetbar;

   	assign 		 cke_i 	  = init_cke;
   	assign 		 odt_i 	  = init_odt;

   	assign dqsbar_i = ~dqs_i;
   	assign dqsbar_pl = ~dqs_pl;
   	// assign dqsbar_init =~dqs_init;
   	// assign validout=~RETURN_empty;
   	assign ri_con = 1;

 //   	// validout cannot be output via wire assignment - needs to be high together with data?


 	always @(posedge clk)
 		RETURN_data_out_reg <= RETURN_data_out;

 	reg validout0, validout1;
	always @(posedge clk)
	begin
		if (reset)
		begin
			validout <= 0;
			// validout0 <= 0;
			// validout1 <= 0;
		end
		else
		begin
			// validout0 <= RETURN_get & ~RETURN_empty;
			// validout1 <= validout0;
			// validout <= validout1;
			validout <= RETURN_get & ~RETURN_empty;
		end
	end
	// assign validout = RETURN_get & ~RETURN_empty;

	reg	IN_put_BLW;
	reg	[4:0] BLW_counter;

	// FIFO control for block write. Need to hold the queue and wait for write data
	always @(posedge clk)
	begin
		if (reset)
		begin
			IN_put_BLW <= 0;
			BLW_counter <= 0;
		end
		else
		begin
			if (!IN_put_BLW)
			begin
				if (cmd==BLW && CMD_put) 				// count for data FIFO input
				begin
					IN_put_BLW <= 1;
					case (sz)
						2'b00: BLW_counter <= 7;
						2'b01: BLW_counter <= 15;
						2'b10: BLW_counter <= 23;
						2'b11: BLW_counter <= 31;
					endcase
				end
			end
			else
			begin
				if (BLW_counter == 1)
					IN_put_BLW <= 0;
				else if (!IN_full)
					BLW_counter <= BLW_counter - 1;
			end
		end
	end

	// FIFO control
	always @(cmd, CMD_full, IN_full, IN_put_BLW)
	begin
		IN_put = 0;
		CMD_put = 0;
		if (IN_put_BLW)
			IN_put = ~IN_full;
		else
		begin
			case (cmd)
				SCR, BLR:
				begin
					if (!CMD_full)
					begin
						CMD_put = 1;
					end
				end
				SCW, BLW, ATW, ATR:
				begin
					if (!CMD_full && !IN_full)
					begin
						CMD_put = 1;
						IN_put = 1;
					end
				end
				default: 	// NOP still needs to be input to FIFO?
				begin
				end
			endcase
		end
	end

   	SSTL18DDR3INTERFACE XSSTL (/*autoinst*/
							// Outputs
							.ck_pad				(ck_pad),
							.ckbar_pad			(ckbar_pad),
							.cke_pad			(cke_pad),
							.csbar_pad			(csbar_pad),
							.rasbar_pad			(rasbar_pad),
							.casbar_pad			(casbar_pad),
							.webar_pad			(webar_pad),
							.ba_pad				(ba_pad),
							.a_pad			   	(a_pad),
							.dm_pad				(dm_pad),
							.odt_pad			(odt_pad),
							.resetbar_pad		(resetbar_pad),
							.dq_o				(dq_o),
							.dqs_o		    	(dqs_o),
							.dqsbar_o			(dqsbar_o),
							// Inouts
							.dq_pad				(dq_pad),
							.dqs_pad			(dqs_pad),
							.dqsbar_pad			(dqsbar_pad),
							// Inputs
							.ri_i				(ri_con),
							.ts_DQ				(ts_DQ),
							.ts_DQS         	(ts_DQS),
							.ck_i				(ck_i),
							.cke_i			   	(cke_i),
							.csbar_i			(csbar_i),
							.rasbar_i			(rasbar_i),
							.casbar_i			(casbar_i),
							.webar_i			(webar_i),
							.ba_i				(ba_i),
							.a_i				(a_i),
							.dq_i				(dq_i),
							.dqs_i			   	(dqs_i),
							.dqsbar_i			(dqsbar_i),
							.dm_i				(dm_i),
							.odt_i			   	(odt_i),
							.resetbar_i			(resetbar_i)
							);






endmodule // ddr3_controller
