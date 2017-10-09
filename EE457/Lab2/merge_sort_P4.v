// ---------------------------------------------------------------------------------
//  Module: merge_sort_P4
//  File name:  merge_sort_P4.v (based on copy_array_to_array_imp2.v)
// 	Design by:  Gandhi Puvvada Dec 2015 
//  Verilog coding by: Urvashi Dhoot <dhoot@usc.edu> and Pezhman Mamdouh <mamdouh@usc.edu> 
//  Minor improvement of code on 1/25/2016 by Gandhi 
//  Date: 1/7/2016, 1/25/2016, 2/15/2016

//  Description: Merging three 4-element arrays As_of_I, Bs_of_J, Cs_of_K presorted in ascending order 
//				 into a 12-element array M[L] in ascending order
//
//				 Coding note:
//				 Array declaration is different here compared to min_max_finder_part1.v
//
//				 In the min-max lab, the M[I] array was declared in the UUT (Unit 
//				 Under Test) using the statement reg [7:0] M [0:15];
//				 And the testbench min_max_finder_part1_tb.v initializes the content 
//				 of this array by using the heirarchical refering method (UUT.M[I]).
//				 In the UUT, we can write statements such as Max <= M[I]; 
//				 because the array M[I] is declared in the UUT.
//				  
//				 In this lab the arrays, As_of_I, Bs_of_J, Cs_of_K and M[L], are declared in the testbench. 
//				 The UUT manipulates (initializes and increments) the indecies I, J, K, and L 
//				 and conveys them to the testbench.

//				 The testbench returns As_of_I, Bs_of_J, Cs_of_K under the signal names As_of_I and Bs_of_J,
//				 Cs_of_K.

//				 The testbench receives from the UUT the following and writes into M[L]
// 				 the data provided to it by the UUT:
// 				 Ms_of_L, L, and the desire to write Ms_of_L_Write
//				 So the Ms_of_L_Write signal is produced combinationally. The combinational OFL
//				 (which is on the downstream of the state memory Flip-Flops) is coded thoughtfully using 
//				 an assign statement, and not a clocked RTL statement.
//				 So, in this code, we cannot write RTL statements such as M[L] <= As_of_I;
//				 because the arrays As_of_I, Bs_of_J, Cs_of_K, and M[L] are not declared in the UUT.
//				 
// 				 The min-max lab practice is suitable if the arrays such as the register file
//				 are part of the UUT namely the CPU.
//				 The practice shown here is suitable for coding pieces of hardware such as 
//				 a memory controller, because the memory is outside the memory controller.
//				 More on this in higher courses!
// ---------------------------------------------------------------------------------

`timescale 1 ns / 100 ps

module merge_sort_P4 (Reset, Clk, Start, Ack, As_of_I, Bs_of_J, Cs_of_K, Ms_of_L, Ms_of_L_Write, I, J, K, L);


// The testbench or the TOP design has the memory arrays.
// The pointers I, J, K, and L are maintained and updated here in this sub-design.

//inputs and outputs declaration
input Reset, Clk;
input Start, Ack;
input [7:0] As_of_I, Bs_of_J, Cs_of_K;

output reg [3:0] I, J, K, L; 
output Ms_of_L_Write;
output reg [7:0] Ms_of_L;
// reg and wire declaration
reg [10:0] state;

// State machine states
localparam
  INI   = 11'b00000000001,
  CAB 	= 11'b00000000010,
  CACS1 = 11'b00000000100,
  CBCS1 = 11'b00000001000,
  CBCS2 = 11'b00000010000,
  CABS2 = 11'b00000100000,
  CACS2 = 11'b00001000000,
  RA	= 11'b00010000000,
  RB	= 11'b00100000000,
  RC	= 11'b01000000000,
  DONE  = 11'b10000000000,
  UNKN  = 11'bXXXXXXXXXXX;

 localparam 
 Imax=4'b0011, Jmax=4'b0011, Kmax = 4'b0011, Lmax = 4'b0111; 
 
// OFL 
// ** TODO #1 **  Actually there is nothing to do here, 
// except you read the following OFL code and comments closely.
// ======
// beginning of  the OFL
// Note: Here we have deviated from our RTL coding style and created a combinational OFL
assign Ms_of_L_Write = ( (state==CACS1) || (state==CBCS1) || (state==CBCS2) || (state==CABS2) || (state==CACS2) || (state==RA) || (state==RB) || (state==RC) );
// Note that we should not, by mistake, be generating the above signal, Ms_of_L_Write, 
// in the clocked procedural block below. If we do so, we will have a clock delay 
// in activating (and inactivating) Ms_of_L_Write. One of our goals is to make this point, 
// hence we have coded the design with memories in the top/test bench  

always @(*) // Note that we are combinationally conveying the data from As_of_I or Bs_of_J or Cs_of_K
		    // to the testbench to deposit it as M[L]
	begin
			Ms_of_L=Cs_of_K; // default assignment to avoid latches
		if( ( (state==CACS1)&& (As_of_I<Cs_of_K) ) || ( (state==CACS2)&& (As_of_I<Cs_of_K) ) || ( (state==CABS2)&& (As_of_I<Bs_of_J) )  || (state==RA)  )
			Ms_of_L=As_of_I;
		if( ( (state==CBCS1)&& (Bs_of_J<Cs_of_K) ) || ( (state==CBCS2)&& (Bs_of_J<Cs_of_K) ) || ( (state==CABS2)&& (As_of_I>=Bs_of_J) )  || (state==RB)  )
			Ms_of_L=Bs_of_J;
	end	

/*  
// An alternative way of writing code to design the part of the OFL to generate Ms_of_L without latches
			always @(*)
			begin
				Ms_of_L=Cs_of_K; // default assignment to avoid latches
				// The above statement covers INI, CAB and DONE states.
				// Becasue of the presence of the above statement,
				// we need to selectively override the above statement when needed.
				// Or in otherwards, we can commentout the lines in the case assignment
				// which duplicate the above assignment.  
				// We have deliberately wrote all those redundant statements and
				// and commented them out to explin our point.	There is no harm
				// if we do no comment them out also.
				// Note that there is no need for the 
				case (state) // state and data transfers 
					 CACS1:
						begin
							if(As_of_I<Cs_of_K)
								Ms_of_L=As_of_I;
							//else
								//Ms_of_L=Cs_of_K;
						end
						
					 CBCS1:
						begin
							if(Bs_of_J<Cs_of_K)
								Ms_of_L=Bs_of_J;
							//else
								//Ms_of_L=Cs_of_K;
						end
						
					CBCS2:
						begin
							if(Bs_of_J<Cs_of_K)
								Ms_of_L=Bs_of_J;
							//else
								//Ms_of_L=Cs_of_K;
						end

					CABS2:
						begin
							if(As_of_I<Bs_of_J)
								Ms_of_L=As_of_I;
							else
								Ms_of_L=Bs_of_J;
						end
						
					CACS2:
						begin
							if(As_of_I<Cs_of_K)
								Ms_of_L=As_of_I;
							//else
								//Ms_of_L=Cs_of_K;
						end
						
					RA:
						begin
							Ms_of_L=As_of_I;
						end

					RB:
						begin
							Ms_of_L=Bs_of_J;
						end

					RC:
						begin
							//Ms_of_L=Cs_of_K;
						end
						
					//default: 
						//begin
							 //Ms_of_L=Cs_of_K;    
						//end
				endcase
			end		
*/				
	
// end of  the OFL
// ======
//start of state machine
always @(posedge Clk, posedge Reset) //asynchronous active_high Reset
 begin  
	   if (Reset) 
	       begin
	           I <= 4'bXXXX;
	           J <= 4'bXXXX;
			   K <= 4'bXXXX;
			   L<=	4'bXXXX;
			   state <= INI;
	       end
       else // under positive edge of the clock
         begin
            case (state) // state and data transfers
                 INI:
					begin
                        if(Start) 
							state <= CAB;
					   	I <= 4'b0000;
						J <= 4'b0000;
						K <= 4'b0000;
						L <= 4'b0000;
					end
                       
                 CAB:       // ** TODO #2 **  Complete State transitions. RTL operations are already completed.            
                    begin  	// Please see the "assign Ms_of_L_Write =  ..." line in the OFL
							// and also see the combinational always (*) block above in the OFL
						// State transitions in the CU
						if(As_of_I<Bs_of_J)
							state<=CACS1;
						else
							state<=CBCS1;
						
						
						
						
							
						// RTL operations in the DPU
							//none
					end
				 
				 CACS1:		// ** TODO #3 **  Complete State transitions. RTL operations are already completed.
					begin
						// State transitions in the CU

						if(I==Imax&As_of_I<Cs_of_K)
							state<=CBCS2;
						if(K==Kmax&As_of_I>=Cs_of_K)
							state<=CABS2;
						if(I!=Imax&As_of_I<Cs_of_K)
							state<=CAB;
						
						
						
						
						
						
							
						// RTL operations in the DPU	
						L<=L+1;
						if(As_of_I<Cs_of_K)
							I<=I+1;
						else
							K<=K+1;
					end
					
				 CBCS1:		// ** TODO #4 **  Complete State transitions. RTL operations are already completed.
					begin
						// State transitions in the CU

						if(J==Jmax&Bs_of_J<Cs_of_K)
							state<=CACS2;
						if(K==Kmax&Bs_of_J>=Cs_of_K)
							state<=CABS2;
						if(J!=Jmax&Bs_of_J<Cs_of_K)
							state<=CAB;
						
						
						
						
						
						
						
							
						// RTL operations in the DPU	
						L<=L+1;
						if(Bs_of_J<Cs_of_K)
							J<=J+1;
						else
							K<=K+1;
					end
					
				CBCS2:		// ** TODO #5 **  Complete State transitions. RTL operations are already completed.
					begin
						// State transitions in the CU

						if(K==Kmax&Bs_of_J>=Cs_of_K)
							state<=RB;
						if(J==Jmax&Bs_of_J<Cs_of_K)
							state<=RC;
						
						
						
						
						
						
						
							
						// RTL operations in the DPU	
						L<=L+1;
						if(Bs_of_J<Cs_of_K)
							J<=J+1;
						else
							K<=K+1;
					end

				CABS2:		// ** TODO #6 **  Complete State transitions. RTL operations are already completed.
					begin
						// State transitions in the CU

						if(I==Imax&As_of_I<Bs_of_J)
							state<=RB;
						if(J==Jmax&As_of_I>=Bs_of_J)
							state<=RA;
						
						
						
						
						
						
						
							
						// RTL operations in the DPU
						L<=L+1;
						if(As_of_I<Bs_of_J)
							I<=I+1;
						else
							J<=J+1;
					end
					
				CACS2:		// ** TODO #7 **  Complete State transitions. RTL operations are already completed.
					begin
						// State transitions in the CU

						if(K==Kmax&As_of_I>=Cs_of_K)
							state<=RA;
						if(I==Imax&As_of_I<Cs_of_K)
							state<=RC;
						
						
						
						
						
						
						
							
						// RTL operations in the DPU
						L<=L+1;
						if(As_of_I<Cs_of_K)
							I<=I+1;
						else
							K<=K+1;
					end
					
				RA:		// ** TODO #8 **  Complete State transitions. RTL operations are already completed.
				begin
					// State transitions in the CU
						
					if(I==Imax)
						state<=DONE;
					
					
					
							
					// RTL operations in the DPU	
					I<=I+1;
					L<=L+1;
				end

				RB:		// ** TODO #9 **  Complete State transitions. RTL operations are already completed.
				begin
					// State transitions in the CU

					if(J==Jmax)
						state<=DONE;
					
					
					
							
					// RTL operations in the DPU
					J<=J+1;
					L<=L+1;
				end

				RC:		// ** TODO #10 **  Complete State transitions. RTL operations are already completed.
				begin
					// State transitions in the CU

					if(K==Kmax)
						state<=DONE;
					
					
					
							
					// RTL operations in the DPU	
					K<=K+1;
					L<=L+1;
				end
				
				DONE:
					// State transitions in the CU
					if(Ack)
						state<=INI;
				default: 
                    begin
                         state <= UNKN;    
                    end
            endcase
         end   
end
 

endmodule