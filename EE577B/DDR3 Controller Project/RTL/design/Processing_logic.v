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
`define RD_WR `tRD+`RD_WR_D+2 			// 10+20+2 = 32
`define tRP 6*`tCLK
// refresh
`define REFRESH	12
`define REFRESH_END `REFRESH+68
module ALU(
	input [15:0] op_a,
	input [15:0] op_b,
	input [2:0] opcode,
	output reg [15:0] out,
	output reg C
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
			NOT: begin out = ~op_a; C=0; end
			NAND: begin out = ~(op_a & op_b); C=0; end
			NOR: begin out = ~(op_a | op_b); C=0; end
			XOR: begin out = op_a ^ op_b; C=0; end
			ADD: begin
				{C,out[7:0]} = op_a[7:0] + op_b[7:0];
				out[15:8] = op_a[15:8] + op_b[15:8];
			end
			FLIP: begin
				for (i=0; i<16; i=i+1)
					out[i] = op_a[15-i];
					C=0;
			end
			SRA: begin out = {op_a[15], op_a[15:1]}; C=0; end
			SLA: begin out = {op_a[14:0], 1'b0}; C=0; end
			default: begin out = 0; C=0; end
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
  output reg DATA_get, RETURN_put;
  output reg [25:0] RETURN_address;
  output wire [15:0] RETURN_data;
  output reg	cs_bar, ras_bar, cas_bar, we_bar;
  output reg [2:0] BA;
  output reg [13:0] A;
  output reg [1:0] DM;
  output reg [15:0]  DQ_out;
  output reg [1:0]   DQS_out;
  output reg ts_con,resetbar;
  reg [33:0] CMD_data_out_reg;
  reg [15:0] DATA_data_out_reg;
  reg listen, shut;
	reg [6:0] counter,counter1;
	reg [12:0] refCounter;
  reg [3:0] state;
  reg DM_flag;
  reg [1:0] Pointer;
	reg [2:0] block_counter,block_counter1;
  reg [4:0] addVal;
	wire C;
  wire [2:0] cmd;
  wire [1:0] sz;
  wire [2:0] op;
  wire [25:0] addr;

  assign {cmd,addr,op,sz} = CMD_data_out_reg;

  parameter [3:0]
  IDLE     =   4'd0,
  RCMD     =   4'd1,        //write leveling
  SRF      =   4'd2,        //self-refresh
  RF       =   4'd3,        //refresh
  PCPD     =   4'd4,        //precharge power down
  ACT      =   4'd5,        //activating
  BACT     =   4'd6,        //bank active
  ACPD     =   4'd7,        //active power down
  BLWR     =   4'd8,        //block write
  SCWRAP   =   4'd9,        //writing auto precharge
  BLRD     =   4'd10,       //block read
  SCRDAP   =   4'd11,       //read auto precharge
  PRE      =   4'd12,       //precharge
  // update
  NOTREADY =   4'd13,       //precharge
  RDATM    =   4'd14,
  WRATM    =   4'd15;
  //
  parameter [2:0]
	NOP = 3'd0,
  SCR = 3'd1,//Scalar Read
  SCW = 3'd2,//Scalar Write
  BLR = 3'd3,//Block Read
  BLW = 3'd4;//Block Write
  // update
  parameter [2:0]
  ATR = 3'b101,        // Atomic Read
  ATW = 3'b110;        // Atomic Write
  //

  reg [15:0] op_a;
  reg [15:0] op_b;
  wire [15:0] ALU_out;

  ALU alu(op_a, op_b, op, ALU_out, C);

  always @(posedge clk)
  begin
      if (reset)
      begin
          CMD_get <= 0;
          DATA_get <= 0;
          RETURN_put <= 0;
          cs_bar <= 0;
          ras_bar <= 1;
          we_bar <= 1;
          cas_bar <= 1;
          BA <= 0;
          A <= 0;
          DM_flag <= 0;
          DQS_out <= 2'bZZ;
          ts_con <= 0;
          resetbar <= 1;
          listen <= 0;
          shut <= 1;
          Pointer <= 0;
          counter <= 0;
					counter1<=0;
          state <= 0;
					block_counter<=0;
		      block_counter1<=0;
		      addVal<=0;
					refCounter<=0;
          //  DATA_data_out_reg <= 0;
          CMD_data_out_reg <= 0;
          RETURN_address <= 0;
      end
      else if (ready)
      begin
					refCounter[6:0] <= refCounter[6:0] + 1;
					if(refCounter[6:0]==7'b1111111) refCounter[12:7]<=refCounter[12:7]+1;
          case(state) //update
          // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          // !!!! DATA_get is set default to 0 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
              IDLE:
                begin
										DQS_out <= 2'bZZ;
                    counter<=0;
										counter1<=0;
										addVal<=0;
                    // update
                    DATA_get<=0;
                    CMD_get<=0; // under the pre-requisite that FIFO itself can handle EMPTY-READ command
										if(refCounter>4800) state <= ACT;
										else if (!CMD_empty && !RETURN_full) begin
	                    CMD_get <= 1;
	                    state <= RCMD;
                		end
                end
              RCMD:
                begin
                  CMD_get <= 0;
                  case(CMD_data_out[33:31])
                    SCW, BLW, ATR, ATW:
                    begin
                    	DATA_get <= 1;
                    end
                  endcase
									case(CMD_data_out[33:31])
										BLR,BLW:begin
											block_counter<={CMD_data_out[1:0],1'b1};
											block_counter1<={CMD_data_out[1:0],1'b1};
										end
									endcase
                  if (CMD_data_out[33:31]!=0 && CMD_data_out[33:31]!=7)
                    begin
                      state <= ACT;
                      CMD_data_out_reg <= CMD_data_out;
                    end
                  else state <= IDLE;
                end
              ACT:
                begin
                    DATA_get <= 0;
                    if (DATA_get)
                      DATA_data_out_reg <= DATA_data_out;
                    if (ck)
                    begin
											counter <= counter+1;
											counter1<=counter1+1;
											if(refCounter>4800)begin
												{cs_bar,ras_bar,cas_bar,we_bar} <= 4'b0010;
												A[10] <= 1;
												state <= RF;
											end
											else begin
                        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0011;
                        BA <= addr[25:23];
                        A[12:0] <= addr[22:10];
                        case (cmd)
													SCR: state<=SCRDAP;
													SCW: state<=SCWRAP;
													BLR: state<=BLRD;
													BLW: state<=BLWR;
                      // update
                          ATW: state <= WRATM;
                          ATR: state <= RDATM;
                          default: state <= IDLE;
                        endcase
											end
                    //
                    end
                end
              SCRDAP:
                begin
                  Pointer <= 0;
                  counter <= counter+1;
                  case (counter)
                      2:
                      begin
                          {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
                      end
                      `tRD:
                      begin//read
                          {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101;
													A[11]<=addr[10];
													A[10] <= 1;
                          A[9:0] <= addr[9:0];
                          RETURN_address <= addr;
                      end
                      `tRD_NOP:
                      begin           //nop
                          {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
                      end
                      // `tLIS-2: shut <= 0;
                      // `tLIS-1:
                      // begin
                      //     listen <= 1;
                      // end
                      `tLIS:
                        begin           //data
                          listen <= 1;
                        end
                      `tLIS+1:
                        begin           //data
                          listen <= 0;
                        end
                      `tLIS+2:
                        begin
                          RETURN_put <= 1;
                        end
                      `tLIS+3:
                        begin
                          RETURN_put <= 0;
                        end
                      `tLIS+6:
                        begin
                          state <= IDLE;
                        end
                  endcase
                end
							BLRD:
								begin
									Pointer <= 0;
					        counter<=counter+1;
					        counter1<=counter1+1;
					        case (counter)
					          2:RETURN_address<=addr;
							          `tLIS: listen<=1;//listen
							          `tLIS+1:begin//data
							           listen<=0;
						          end
					          `tLIS+2: RETURN_put<=1;
					          `tLIS+3: begin
							          Pointer<=Pointer+1;
							          RETURN_address<=RETURN_address+1;
						          end
					          `tLIS+4: begin
							          Pointer<=Pointer+1;
							          RETURN_address<=RETURN_address+1;
							        end
					          `tLIS+5: begin
							          Pointer<=Pointer+1;
							          RETURN_address<=RETURN_address+1;
							        end
					          `tLIS+6: begin
						            Pointer<=0;
						            RETURN_put<=0;
						            if(block_counter>0)begin
						              counter<=`tLIS-1;
						              RETURN_address<=RETURN_address+1;
						              block_counter<=block_counter-1;
						            end
						          end
					        endcase
									case(counter1)
					          2:begin
						            {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;//NOP
						          end
					          `tRD:begin//read
						            {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101;
						            A[11]<=addr[10];
						            if(block_counter1==0) A[10]<=1;
						            else A[10]<=0;
						            A[9:0]<=addr[9:0]+addVal;
						          end
					          `tRD_NOP:begin//nop
						            {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
						            if(block_counter1>0)begin
						              counter1<=`tRD_NOP-7;
						              block_counter1<=block_counter1-1;
						              addVal<=addVal+4;
						            end
						          end
					          `tLIS+6:begin
						            state<=IDLE;
						          end
					        endcase
					      end
              SCWRAP:
                begin
                  Pointer <= 0;
                  counter <= counter+1;
                  case(counter)
                    2:
                      begin
                          {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
                      end
                    `tWR:
                      begin
                          {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;
													A[11]<=addr[10];
													A[10] <= 1;
                          A[9:0] <= addr[9:0];
                      end
                    `tWR_NOP: {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
                    `tWR_DATA-1:
                      begin
                        ts_con <= 1;
                        DQS_out <= 2'b11;
                      end
                    `tWR_DATA:
                      begin
                        DQS_out <= ~DQS_out;
                        DM_flag <= (addr[1:0]==0);
                      end
                    `tWR_DATA+1:
                      begin
                        DQS_out <= ~DQS_out;
                        DM_flag <= (addr[1:0]==1);
                      end
                    `tWR_DATA+2:
                      begin
                        DQS_out <= ~DQS_out;
                        DM_flag <= (addr[1:0]==2);
                      end
                    `tWR_DATA+3:
                      begin
                          DQS_out <= ~DQS_out;
                          DM_flag <= (addr[1:0]==3);
                      end
                    `tWR_DATA+4:
                      begin
                          DQS_out <= ~DQS_out;
                          DM_flag <= 0;
                      end
                    `tWR_DATA+9: ts_con <= 0;
                    `tWR_DATA+20:
                      begin
                          state <= IDLE;
                      end
                  endcase
                end
							BLWR:
								begin
									Pointer <= 0;
					        counter<=counter+1;
					        counter1<=counter1+1;
					        case(counter)
					          `tWR_DATA-1:begin
							          ts_con<=1;
							          DQS_out<=2'b11;
						          end
					          `tWR_DATA:begin
							          DQS_out<=~DQS_out;
							          DM_flag<=1;
							          DATA_get<=1;
						          end
					          `tWR_DATA+1:begin
							          DQS_out<=~DQS_out;
							          DATA_data_out_reg<=DATA_data_out;
						          end
					          `tWR_DATA+2:begin
						            DQS_out<=~DQS_out;
						            DATA_data_out_reg<=DATA_data_out;
						          end
					          `tWR_DATA+3:begin
						            DQS_out<=~DQS_out;
						            if(block_counter==0)begin
						              DATA_get<=0;
						            end
						            else begin
						              DATA_get<=1;
						            end
						            DATA_data_out_reg<=DATA_data_out;
						          end
					          `tWR_DATA+4:begin
						            DQS_out<=~DQS_out;
						            DM_flag<=0;
						            if(block_counter!=0)begin
						              counter<=`tWR_DATA-3;
						              block_counter<=block_counter-1;
						              DATA_get<=0;
						              DATA_data_out_reg<=DATA_data_out;
						            end
						          end
					          `tWR_DATA+9:ts_con<=0;
					          endcase
					          case(counter1)
					            2:begin
						              {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
						            end
					            `tWR: begin
						              {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;
						              A[11]<=addr[10];
						              if(block_counter1==0) A[10]<=1;
						              else A[10]<=0;
						              A[9:0]<=addr[9:0]+addVal;
						            end
					            `tWR_NOP:begin
													{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
													if(block_counter1>0)begin
														counter1<=`tWR_NOP-7;
														block_counter1<=block_counter1-1;
														addVal<=addVal+4;
														end
												end
					            `tWR_DATA+20:begin
						              state<=IDLE;
						            end
					          endcase
					      end
              WRATM:
                begin
                  counter <= counter + 1;
                  Pointer <= 0;
                  case (counter)
                    2:
                      begin
                        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
                      end
                    `tRD:
                      begin           //read command
                        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101;
                        A[10] <= 0;
                        A[9:0] <= addr[9:0];
                        RETURN_address <= addr;
                      end
                    `tRD_NOP:
                      begin           //nop
                        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
                      end
                    // `tLIS-1: shut <= 0;   //listen
                    `tLIS:
                      begin           //data
                        listen <= 1;
                      end
                    `tLIS+1:
                      begin           //data
                        listen <= 0;
                      end
                    `tLIS+3:
                      begin
                        // shut <= 1;
                        op_a <= RETURN_data;
                        op_b <= DATA_data_out_reg;
                      end
                    `tLIS+5: DATA_data_out_reg <= {ALU_out[15:8]+C,ALU_out[7:0]};
                    `RD_WR:
                      begin           //write command
                        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;
                        A[10] <= 1;
                        A[9:0] <= addr[9:0];
                      end
                    `RD_WR+2: {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
                    `RD_WR+16-1:
                      begin      // 16 = tWR_DATA - tWR
                        ts_con <= 1;
                        DQS_out <= 2'b11;
                      end
                    `RD_WR+16:
                      begin
                        DQS_out <= ~DQS_out;
                        DM_flag <= (addr[1:0]==0);
                      end
                    `RD_WR+16+1:
                      begin
                        DQS_out <= ~DQS_out;
                        DM_flag <= (addr[1:0]==1);
                      end
                    `RD_WR+16+2:
                      begin
                        DQS_out <=  ~DQS_out;
                        DM_flag <= (addr[1:0]==2);
                      end
                    `RD_WR+16+3:
                      begin
                        DQS_out <= ~DQS_out;
                        DM_flag <= (addr[1:0]==3);
                      end
                    `RD_WR+16+4:
                      begin
                        DQS_out <= ~DQS_out;
                        DM_flag <= 0;
                      end
                    `RD_WR+16+9: ts_con <= 0;
                    `RD_WR+16+40:
                      begin
                        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
                        counter <= 0;
                        state <= IDLE;
                        DATA_get <= 0;
                        CMD_get <= 0;
                      end
                  endcase
                end
              RDATM:
                begin
                  counter <= counter + 1;
                  Pointer <= 0;
                  case (counter)
                    2:
                      begin
                        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
                      end
                    `tRD:
                      begin           //read command
                        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101;
                        A[10] <= 0;
                        A[9:0] <= addr[9:0];
                        RETURN_address <= addr;
                      end
                    `tRD_NOP:
                      begin           //nop
                        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
                      end
                    // `tLIS-1: shut <= 0;   //listen
                    `tLIS:
                      begin           //data
                        listen <= 1;
                      end
                    `tLIS+1:
                      begin           //data
                        listen <= 0;
                      end
                    `tLIS+3:
                      begin
                        // shut <= 1;
                        op_a <= RETURN_data;
                        op_b <= DATA_data_out_reg;
                        //RETURN_put <= 1;
                      end
                    `tLIS+5:
                      begin
                        DATA_data_out_reg <= {ALU_out[15:8]+C,ALU_out[7:0]};
                        RETURN_put <= 1;
                      end
										`tLIS+6:RETURN_put <= 0;
                    `RD_WR:
                      begin           //write command
                        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;
                        A[10] <= 1;
                        A[9:0] <= addr[9:0];
                      end
                    `RD_WR+2: {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
                    `RD_WR+16-1:
                      begin      // 16 = tWR_DATA - tWR
                        ts_con <= 1;
                        DQS_out <= 2'b11;
                      end
                    `RD_WR+16:
                      begin
                        DQS_out <= ~DQS_out;
                        DM_flag <= (addr[1:0]==0);
                      end
                    `RD_WR+16+1:
                      begin
                        DQS_out <= ~DQS_out;
                        DM_flag <= (addr[1:0]==1);
                      end
                    `RD_WR+16+2:
                      begin
                        DQS_out <=  ~DQS_out;
                        DM_flag <= (addr[1:0]==2);
                      end
                    `RD_WR+16+3:
                      begin
                        DQS_out <= ~DQS_out;
                        DM_flag <= (addr[1:0]==3);
                      end
                    `RD_WR+16+4:
                      begin
                        DQS_out <= ~DQS_out;
                        DM_flag <= 0;
                      end
                    `RD_WR+16+9: ts_con <= 0;
                    `RD_WR+16+40:
                      begin
                        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
                        counter <= 0;
                        state <= IDLE;
                        DATA_get <= 0;
                        CMD_get <= 0;
                      end
                  endcase
                end
							RF:
								begin
									counter <= counter + 1;
									case(counter)
										2:
                      begin
                        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
                      end
										`REFRESH:
											begin
												{cs_bar,ras_bar,cas_bar,we_bar} <= 4'b0001;
											end
										`REFRESH+2:
                      begin           //nop
                        {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;
                      end
										`REFRESH_END:
											begin
												counter <= 0;
												refCounter <= 0;
												state <= IDLE;
											end
									endcase
								end
              default: state <= IDLE;
          endcase
      end
  end

  ddr3_ring_buffer8 ring_buffer(RETURN_data, listen, DQS_in[0], Pointer, DQ_in, shut);

  always @(negedge clk)
  begin
      DQ_out <= DATA_data_out_reg;
      if (DM_flag)
          DM <= 2'b00;
      else
          DM <= 2'b11;
  end

endmodule // ddr_controller
