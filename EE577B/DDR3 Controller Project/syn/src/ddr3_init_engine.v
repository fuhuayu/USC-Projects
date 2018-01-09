// Define Counter Values by setting the counter value for each stage in the INIT process
// There is a NOP command issued 1 DDR clock cycle after most commands
// More information about each stage is in the Verilog code below

`define tXPR	74 					// ??? 76
`define tCLK	2
`define tMRD	10 					// ??? 4*2+2 (+2 for setup time?)
`define tMOD	26
`define tZQinit	1024
`define tCWL	5*`tCLK
`define tAL     3*`tCLK
`define tODTLoff `tCWL+`tAL-2*`tCLK
`define tWLDQSEN 26*`tCLK
`define tWLMRD   40*`tCLK
`define tWLO	12 					// dqs rising edge - tWLO - dq
`define tWLOE   2
`define tDQSL	1
`define tDQSH	1

`define S_RSTBL 	19'd0
`define S_CKEL		`S_RSTBL+124990
`define S_RSTBH		`S_CKEL+10
`define S_CKEH		`S_RSTBH+312500
`define S_NOP0		`S_CKEH+`tCLK
`define S_EMRS2		`S_NOP0+`tXPR
`define S_NOP1 		`S_EMRS2+`tCLK
`define S_EMRS3		`S_NOP1+`tMRD
`define S_NOP2		`S_EMRS3+`tCLK
`define S_EMRS1		`S_NOP2+`tMRD
`define S_NOP3		`S_EMRS1+`tCLK
`define S_EMRS0		`S_NOP3+`tMRD
`define S_NOP4		`S_EMRS0+`tCLK
`define S_ZQCL		`S_NOP4+`tMOD
`define S_NOP5		`S_ZQCL+`tCLK

`define T_EMRS1		`S_NOP5+`tMRD+`tZQinit
`define T_NOP1		`T_EMRS1+`tCLK
`define T_ODT_on	`T_EMRS1+`tMOD
`define T_DQSL1		`T_EMRS1+`tWLDQSEN
//`define T_DQSH		`T_DQSL1+`tDQSL+3*`tWLOE
`define T_DQSH		`T_EMRS1+`tWLMRD+`tWLO 		//
`define T_DQSL2		`T_DQSH+6*`tDQSH			//
//`define T_DQSH2		`T_DQSL2+`tDQSL
//`define T_DQSL3		`T_DQSH2+`tDQSH
`define T_ODT_off	`T_DQSL2+`tWLO+`tWLOE+`tCLK
`define T_EMRS1_ex	`T_ODT_off+`tODTLoff+`tCLK+1
`define S_NOP6		`T_EMRS1_ex+`tCLK
`define S_DONE		`S_NOP6+`tMOD

// `define tXPR	76 					// ??? 76
// `define tCLK	2
// `define tMRD	8 					// ??? 4*2+2 (+2 for setup time?)
// `define tMOD	24
// `define tZQinit	1024

// `define S_RSTBL 	19'd0
// `define S_CKEL		`S_RSTBL+125002
// `define S_RSTBH		`S_CKEL+10
// `define S_CKEH		`S_RSTBH+312502
// `define S_NOP0		`S_CKEH+`tCLK
// `define S_EMRS2		`S_NOP0+`tXPR
// `define S_NOP1 		`S_EMRS2+`tCLK
// `define S_EMRS3		`S_NOP1+`tMRD
// `define S_NOP2		`S_EMRS3+`tCLK
// `define S_EMRS1		`S_NOP2+`tMRD
// `define S_NOP3		`S_EMRS1+`tCLK
// `define S_EMRS0		`S_NOP3+`tMRD
// `define S_NOP4		`S_EMRS0+`tCLK
// `define S_ZQCL		`S_NOP4+`tMOD
// `define S_NOP5		`S_ZQCL+`tCLK
// `define S_DONE		`S_NOP5+`tZQinit

/////////////////////////////////////////////////////////


module ddr3_init_engine(
   // Outputs
   ready, csbar, rasbar, casbar, webar, ba, a, dm, odt, ts_con, cke, resetbar, dqs_out, dqsbar_out,
   // Inputs
   clk, reset, init, ck, dq
   );


input clk, reset, init, ck;
input [15:0] dq;
output ready, csbar, rasbar, casbar, webar, odt, cke, resetbar;
output [2:0] ba;
output [13:0] a;
output [1:0] dm;

reg ready;
reg csbar;
reg rasbar;
reg casbar;
reg webar;
reg [2:0] ba;
reg [13:0] a;
reg odt;
output reg [1:0] dqs_out;
output [1:0] dqsbar_out;
output reg [1:0] ts_con;
reg INIT, RESET;
reg resetbar;
reg [1:0] dm;
reg cke;
reg resetN;
reg dqN,DQN;
reg [18:0]  counter,counterN;
reg flag,flagN;
reg wl_flag;

// reg odd;

assign dqsbar_out = ~dqs_out;

always @(posedge clk)
begin
	INIT <= init;
	RESET <= reset;
	if (reset)
  	begin
  		flag <= 0;
  		wl_flag <= 0;
  		cke <= 0;
  		//odt <= 0;
  		a <= 0;
  		ba <= 0;

  		// ts_con <= 0;

  		csbar <= 1;
  		rasbar <= 1;
  		webar <= 1;
  		casbar <= 1;
  		ready <= 0;
  		resetbar <= 0;
  		counter <= 0;	//
  		// odd <= 0;

  		odt <= 0;
  		ts_con <= 0;
  	end
	else if (flag == 0 && INIT == 1)
  	begin
  		// On INIT signal, set a flag to start the initialization routine and clear the counter
  		flag <= 1;
  		counter <= 0;
  	end
	else if (flag == 1)
	 begin
		counter[6:0] <= counter[6:0] + 1;
    if(counter[6:0]==7'b1111111) counter[12:7]<=counter[12:7]+1;
    if(counter[12:0]==13'b1111111111111) counter[18:13]<=counter[18:13]+1;
		case (counter)
		// Use a case statement to match counter values to specific commands issued to the DDR3 chip
		// TASK: Fill in the correct counter values in the definitions at the beginning of the file
		// and fill in any missing signal values to set up the DDR3 chip correctly in the following code

		// INIT Waits for 200 microseconds
			`S_RSTBL: begin
          				$display("S_RSTBL");
          			end

			`S_CKEL:  begin
          				$display("S_CKEL");
          			end

			`S_RSTBH: begin
          				resetbar <= 1;
          				$display("S_RSTBH");
          			end

			`S_CKEH:  begin
                	{csbar, rasbar, casbar, webar} <= 4'b0111;
                	cke <= 1;
                	$display("S_NOP0");
                end

			`S_NOP0:  begin
          				{csbar, rasbar, casbar, webar} <= 4'b0111;
          				$display("S_CKEH");
          			end

			`S_EMRS2: begin
          				{csbar, rasbar, casbar, webar} <= 4'b0000;
          				ba <= 3'b010;
          				a[2:0] <= 0;
          				a[5:3] <= 0; 		// CAS write latency
          				a[7:6] <= 0;		// normal self-refresh
          				a[8] <= 0;
          				a[10:9] <= 0;		// dynamic ODT disabled
          				a[12:11] <= 0;
          				$display("S_EMRS2");
          			end

      `S_NOP1:  begin
          				{csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command
          				$display("S_NOP1");
          			end

	    `S_EMRS3: begin
          				{csbar, rasbar, casbar, webar} <= 4'b0000;
          				ba <= 3'b011;
          				a <= 0;
          				$display("S_EMRS3");
          			end

			`S_NOP2: {csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command

			`S_EMRS1: begin
          				{csbar, rasbar, casbar, webar} <= 4'b0000;
          				ba <= 3'b001;
          				a[0] <= 0;
          				{a[5], a[1]} <= 0; 			// output drive strength
          				{a[9], a[6], a[2]} <= 3'b000;	// RTT disable
          				a[4:3] <= 2'b10;			// Additive Latency (AL)
          				// a[4:3] = 00: disabled (AL=0)   01: AL = CL-1   10: AL = CL-2   11: reserved
          				a[7] <= 0; 					// write leveling enabled
          				a[8] <= 0;
          				a[10] <= 0;
          				a[11] <= 0;					// tDQS
          				a[12] <= 0;					// Qoff
          			end

			`S_NOP3: {csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command

			`S_EMRS0: begin
          				{csbar, rasbar, casbar, webar} <= 4'b0000;
          				ba <= 3'b000;
          				a[1:0] <= 2'b10; 			// burst length = 4 (chopped?)
          				// a[1:0] = 00: fixed BL=8   01: 4 or 8 (on the fly via A12)   10: fixed BC4 (chop)   11: reserved
          				{a[6], a[5], a[4], a[2]} <= 4'b0010; 		// CAS latency = 5
          				// 0000: reserved  0010: 5  0100: 6  0110: 7  1000: 8  1010: 9  1100: 10  1110: 11  0001: 12  0011: 13  0101: 14
          				a[3] <= 1; 					// burst type: sequential (nibble)
          				// a[3] = 0: sequential (nibble)   1: interleaved
          				a[7] <= 0;
          				a[8] <= 1;					// DLL reset enabled
          				a[11:9] <= 3'b001; 			// write recovery = 5 ?
          				a[12] <= 0; 				// precharge PD, DLL off ?
          			end

			`S_NOP4: {csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command

			`S_ZQCL:  begin
          				{csbar, rasbar, casbar, webar} <= 4'b0110;
          				a <= 0;
          				a[10] <= 1;
          			end

			`S_NOP5: {csbar, rasbar, casbar, webar} <= 4'b0111;
//**********************************************************************************
//****************try wl after MRS0
			`T_EMRS1: begin
          				{csbar, rasbar, casbar, webar} <= 4'b0000;
          				ba <= 3'b001;
          				a[0] <= 0;
          				{a[5], a[1]} <= 0; 			// output drive strength
          				{a[9], a[6], a[2]} <= 3'b001;	// RTT disable
          				a[4:3] <= 2'b10;			// Additive Latency (AL)
          				// a[4:3] = 00: disabled (AL=0)   01: AL = CL-1   10: AL = CL-2   11: reserved
          				a[7] <= 1; 					// write leveling enabled
          				a[8] <= 0;
          				a[10] <= 0;
          				a[11] <= 0;					// tDQS
          				a[12] <= 0;					// Qoff
          			end

			`T_NOP1: {csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command

			`T_ODT_on: odt <= 1;

			`T_DQSL1: ts_con <= 2'b10;

			`T_DQSH + 2:begin
          				if(/*wl_flag==0 &&*/ dq[0]!=1) begin
          					counter <=`T_DQSL1;
          				end
          				else if (dq[0]==1 /*&& wl_flag == 0*/) begin
          					counter <= `T_ODT_off-`tCLK;
          					// wl_flag <=1;
          				end
          			end

			`T_ODT_off-1: begin 				// -1
          				odt <= 0;
          				ts_con <= 2'b00;
          			end

			`T_EMRS1_ex: begin
          				$display("T_EMRS1_ex");
          				{csbar, rasbar, casbar, webar} <= 4'b0000;
          				ba <= 3'b001;
          				a[0] <= 0;
          				{a[5], a[1]} <= 0; 			// output drive strength
          				{a[9], a[6], a[2]} <= 3'b000;	// RTT disable
          				a[4:3] <= 2'b10;			// Additive Latency (AL)
          				// a[4:3] = 00: disabled (AL=0)   01: AL = CL-1   10: AL = CL-2   11: reserved
          				a[7] <= 0; 					// write leveling disable
          				a[8] <= 0;
          				a[10] <= 0;
          				a[11] <= 0;					// tDQS
          				a[12] <= 0;					// Qoff
          			end
//**************************finish
			`S_NOP6:  begin
          				$display("S_NOP6");
          				{csbar, rasbar, casbar, webar} <= 4'b0111; // NOP command
          			end

			`S_DONE+100: begin
          				$display("S_DONE");
          				ready <= 1;
          				flag <= 0;
          			end

		default:flag <= 1;

		endcase
	end
end

always @(negedge clk) begin
  flagN<=flag;
  resetN<=RESET;
	if(resetN)begin
  		dqs_out <= 0;
      counterN <= 0;
      dqN<=0;
  	end
	else if(flagN==1) begin
  dqN<=dq[0];
  counterN[6:0] <= counterN[6:0] + 1;
  if(counterN[6:0]==7'b1111111) counterN[12:7]<=counterN[12:7]+1;
  if(counterN[12:0]==13'b1111111111111) counterN[18:13]<=counterN[18:13]+1;
	case(counterN)

		`T_DQSL1-1: dqs_out <= 2'b00;

		`T_DQSH-1: dqs_out <= 2'b11;

    `T_DQSH + 1: begin
              if(dqN != 1) begin
                counterN <=`T_DQSL1;
              end
              else if (dqN == 1) begin
                counterN <= `T_ODT_off -`tCLK;
              end
            end

		`T_DQSL2-1: dqs_out <= 2'b00;

	endcase
	end
end

endmodule
