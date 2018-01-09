`define AL 3*`tCLK 						// 6
`define BL 4*`tCLK						// 8
`define CL 5*`tCLK						// 10
`define tRCD 10
`define tRD `tRCD 						// 10
`define tWR `tRCD 						// 10
`define tRD_NOP `tRD+2 					// 12
`define tWR_NOP `tWR+2 					// 12
`define tLIS `tRD+(`AL+`CL)  			// 10+2*8 = 26
`define tWR_DATA `tWR+(`AL+`CL) 		// 10+2*8 = 26    in scalar write, exit at tWR + 56
// update
`define tCLK 2
`define tCWL 5*`tCLK
`define tCCD 4*`tCLK 					// 8
`define RL `AL+`CL						// 16
`define WL `AL+`tCWL 					// 16
`define RD_WR_D `RL+`tCCD+2*`tCLK-`WL 	// read-to-write delay, 16+16+4-16 = 20
`define RD_WR `tRD+`RD_WR_D 			// 10+20 = 30
`define tRP 6*`tCLK
//

module ALU(
	input [15:0] op_a,
	input [15:0] op_b,
	input [2:0] opcode,
	output reg [15:0] out
	);
	
	localparam [2:0] NOT 	= 3'b000;
	localparam [2:0] NAND	= 3'b001;
	localparam [2:0] NOR	= 3'b010;
	localparam [2:0] XOR	= 3'b011;
	localparam [2:0] ADD	= 3'b100;
	localparam [2:0] FLIP	= 3'b101;
	localparam [2:0] SRA	= 3'b110;
	localparam [2:0] SLA	= 3'b111;
	
	integer i;
	
	always @(*)
	begin
		case (opcode)
			NOT: out = ~op_a;
			NAND: out = ~(op_a & op_b);
			NOR: out = ~(op_a | op_b);
			XOR: out = op_a ^ op_b;
			ADD: out = op_a + op_b;
			FLIP: begin
				for (i=0; i<16; i=i+1)
					out[i] = op_a[15-i];
			end
			SRA: out = {op_a[15], op_a[15:1]};
			SLA: out = {op_a[14:0], 1'b0};
			default: out = 0;
		endcase
	end
endmodule

module Processing_logic(
   // Outputs
   DATA_get,
   CMD_get,
   RETURN_put,
   RETURN_address, RETURN_data,  //construct RETURN_data_in
   cs_bar, ras_bar, cas_bar, we_bar,  // read/write function
   BA, A, DM,
   DQS_out, DQ_out,
   ts_con,
   resetbar,
   // Inputs
   clk, ck, reset, ready,
   CMD_empty, CMD_data_out, DATA_data_out,
   RETURN_full,
   DQS_in, DQ_in
   );

   parameter BL = 4'd4; // Burst Length
   parameter BT = 1'd0;   // Burst Type
   parameter CL = 3'd5;  // CAS Latency (CL)
   parameter AL = 3'd3;  // Posted CAS# Additive Latency (AL)


   input 	 clk, ck, reset, ready;
   input 	 CMD_empty, RETURN_full;
   input [33:0]	 CMD_data_out;
   input [15:0]  DATA_data_out;
   input [15:0]  DQ_in;
   input [1:0]   DQS_in;
   
   // CMD_data_out = {cmd,addr,op,sz};

   output reg CMD_get;
   output reg		 DATA_get, RETURN_put;
   output reg [25:0] RETURN_address;
   output wire [15:0] RETURN_data;
   output reg	cs_bar, ras_bar, cas_bar, we_bar;
   output reg [2:0]	 BA;
   output reg [13:0] A;
   output reg [1:0]	 DM;
   output reg [15:0]  DQ_out;
   output reg [1:0]   DQS_out;
   output reg ts_con,resetbar;
   reg [33:0] CMD_data_out_reg;
   reg [15:0] DATA_data_out_reg;
   reg listen;
   reg [11:0] counter;
   reg [3:0] state;
   reg DM_flag;
   reg [2:0] Pointer;
   wire [2:0] cmd;
   wire [1:0] sz;
   wire [2:0] op;
   wire [25:0] addr;
   assign {cmd,addr,op,sz}=CMD_data_out_reg;

   parameter [3:0]
   IDLE=4'd0,
   WL=4'd1,//write leveling
   SRF=4'd2,//self-refresh
   RF=4'd3,//refresh
   PCPD=4'd4,//precharge power down
   ACT=4'd5,//activating
   BACT=4'd6,//bank active
   ACPD=4'd7,//active power down
   WR=4'd8,//writing
   WRAP=4'd9,//writing auto precharge
   RD=4'd10,//read
   RDAP=4'd11,//read auto precharge
   PRE=4'd12,//precharge
   // update
   NOTREADY=4'd13,//precharge
   RCMD=4'd14;
   //
   parameter [2:0]
   NOP = 3'd0,
   SCR = 3'd1,//Scalar Read
   SCW = 3'd2;//Scalar Write
   // update
   parameter [2:0]
   ATR = 3'b101, // Atomic Read
   ATW = 3'b110; // Atomic Write
   parameter [3:0]
   RDATM = 4'd14,
   WRATM = 4'd15;
   //
   
   reg [15:0] op_a;
   reg [15:0] op_b;
   wire [15:0] out;
   
   ALU alu(op_a, op_b, op, out);

always @(posedge clk) begin
    if(reset)
    begin
      CMD_get<=0;
      DATA_get<=0;
      RETURN_put<=0;
      cs_bar <= 0;
  		ras_bar <= 1;
  		we_bar <= 1;
  		cas_bar <= 1;
      BA <= 0;
      A <= 0;
  		DM_flag <= 0;
      DQS_out<=0;
      ts_con <= 0;
  		resetbar <= 1;
      listen<=0;
      Pointer<=0;
      counter<=0;
      state<=0;

    //  DATA_data_out_reg <= 0;
      CMD_data_out_reg <= 0;
      RETURN_address <= 0;
  	end
    else if (ready) begin
      case(state) //update
	  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	  // !!!! DATA_get is set default to 0 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      IDLE:begin
        counter<=0;
		// update
        DATA_get<=0;
        CMD_get<=0; // under the pre-requisite that FIFO itself can handle EMPTY-READ command
        if (!CMD_empty && !RETURN_full) begin
			CMD_get <= 1;
			state <= RCMD;
		end
		//
      end
	  RCMD: begin
		CMD_get <= 0;
		case(CMD_data_out[33:31])
		SCW, ATR, ATW: begin
			DATA_get <= 1;
		end
		endcase
		if (CMD_data_out[33:31]!=0 && CMD_data_out[33:31]!=7) begin
			state <= ACT;
			CMD_data_out_reg <= CMD_data_out;
		end
		else
			state <= IDLE;
	  end
      ACT:begin
        if(ck)begin
          counter<=counter+1;
          {cs_bar, ras_bar, cas_bar, we_bar}<=4'b0011;
          BA <= addr[25:23];
          A[12:0] <= addr[22:10];
          case(cmd)
          SCR:state<=RDAP;
		  // update
          SCW: begin
			state <= WRAP;
			DATA_data_out_reg <= DATA_data_out;
		  end
		  ATW: begin
			state <= WRATM;
			DATA_data_out_reg <= DATA_data_out;
		  end
		  ATR: begin
			state <= RDATM;
			DATA_data_out_reg <= DATA_data_out;
		  end
          default: state<=IDLE;
          endcase
		  DATA_get <= 0;
		  //
        end
      end
      RDAP:begin
        counter<=counter+1;
        case (counter)
          2:begin
            {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
          end
          `tRD:begin//read
            {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101;
            A[10]<=1;
            A[9:0]<=addr[9:0];
            RETURN_address<=addr;
          end
          `tRD_NOP:begin//nop
            {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
          end
          `tLIS-1: listen<=1;//listen
          `tLIS:begin//data
            listen<=0;
          end
          `tLIS+2: begin
          RETURN_put<=1;
          end
          `tLIS+3: begin
            RETURN_put<=0;
          end
          `tLIS+18:begin
            {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
            counter<=0;
            state<=IDLE;
            DATA_get<=0;
            CMD_get<=0;
          end
        endcase
      end
      WRAP:begin
        counter<=counter+1;
        case(counter)
          2:begin
            {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
          end
          `tWR: begin
            {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;
            A[10]<=1;
            A[9:0]<=addr[9:0];
          end
          `tWR_NOP: {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
          `tWR_DATA-1:begin
          ts_con<=1;
          DQS_out<=2'b11;
          end
          `tWR_DATA:begin
          DQS_out<=~DQS_out;
          DM_flag<=(addr[1:0]==0);
          end
          `tWR_DATA+1:begin
          DQS_out<=~DQS_out;
          DM_flag<=(addr[1:0]==1);
          end
          `tWR_DATA+2:begin
          DQS_out<=~DQS_out;
          DM_flag<=(addr[1:0]==2);
          end
          `tWR_DATA+3:begin
          DQS_out<=~DQS_out;
          DM_flag<=(addr[1:0]==3);
          end
          `tWR_DATA+4:begin
          DQS_out<=~DQS_out;
          DM_flag<=0;
          end
          `tWR_DATA+9:ts_con<=0;
          `tWR_DATA+40:begin
            {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
            counter<=0;
            state<=IDLE;
            DATA_get<=0;
            CMD_get<=0;
          end
          endcase
      end
	  //
	  // WRATM: begin
		// counter <= counter+1;
		// Pointer <= 0;
        // case (counter)
          // 2:begin
            // {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
          // end
          // `tRD:begin //read command
            // {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101;
            // A[10]<=0;
            // A[9:0]<=addr[9:0];
            // RETURN_address<=addr;
          // end
          // `tRD_NOP:begin//nop
            // {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
          // end
          // `tLIS-1: listen<=1;//listen
          // `tLIS:begin//data
            // listen<=0;
          // end
		  // `RD_WR: begin 	// write command
		  	// {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;
		  	// A[10]<=1;
		  	// A[9:0]<=addr[9:0];
		  // end
		  // `RD_WR+2: {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
		  // `RD_WR+16-1:begin 		// 16 = tWR_DATA - tWR
			// ts_con<=1;
			// DQS_out<=2'b11;
		  // end
		  // `RD_WR+16:begin
			// DQS_out<=~DQS_out;
			// DM_flag<=(addr[1:0]==0);
		  // end
		  // `RD_WR+16+1:begin
			// DQS_out<=~DQS_out;
			// DM_flag<=(addr[1:0]==1);
		  // end
		  // `RD_WR+16+2:begin
			// DQS_out<=~DQS_out;
			// DM_flag<=(addr[1:0]==2);
		  // end
		  // `RD_WR+16+3:begin
			// DQS_out<=~DQS_out;
			// DM_flag<=(addr[1:0]==3);
		  // end
		  // `RD_WR+16+4:begin
			// DQS_out<=~DQS_out;
			// DM_flag<=0;
		  // end
		  // `RD_WR+16+9:ts_con<=0;
		  // `RD_WR+16+40:begin
		  	// {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
		  	// counter<=0;
		  	// state<=IDLE;
		  	// DATA_get<=0;
		  	// CMD_get<=0;
		  // end
        // endcase
	  // end
	  // //
      default: state<=IDLE;
      endcase
    end
  end

ddr3_ring_buffer8 ring_buffer(RETURN_data, listen, DQS_in[0], Pointer[2:0], DQ_in, reset);
always @(negedge clk)
  begin
    DQ_out <= DATA_data_out_reg;
    if(DM_flag)
        DM <= 2'b00;
    else
        DM <= 2'b11;
  end

endmodule // ddr_controller
