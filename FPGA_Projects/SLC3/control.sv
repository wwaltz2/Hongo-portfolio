//------------------------------------------------------------------------------
// Engineers:        Evan McGowan and Bill Waltz
//
// Design Name:    Complete ISDU for SLC-3
// Module Name:    Control - Behavioral
//
//------------------------------------------------------------------------------

module control (   
	input logic         clk, 
	input logic			reset,

	input logic  [15:0] ir,
	input logic         ben_out,
	//input logic [15:0]  mem_rdata,

	input logic 		continue_i,
	input logic 		run_i,
		
	output logic        ld_mar,
	output logic		ld_mdr,
	output logic		ld_ir,
	output logic		ld_ben,
	output logic		ld_cc,
	output logic		ld_reg,
	output logic		ld_pc,
	//output logic        ld_led,
						
	output logic        gate_pc,
	output logic		gate_mdr,
	output logic		gate_alu,
	output logic		gate_marmux,
						
	output logic [1:0]  pcmux,
	output logic        drmux,
	output logic 		sr1mux,
	output logic		sr2mux,
	output logic		addr1mux,
	output logic [1:0]  addr2mux,
	output logic [1:0]	aluk,
	output logic        mio_en,
		
	output logic        mem_mem_ena, // Mem Operation Enable
	output logic		mem_wr_ena  // Mem Write Enable
);

	logic [3:0] opcode;


	enum logic [4:0] {  
		halted, //0
		pause_ir1,
		pause_ir2, 
		s_18, //3
		s_18_2, 
		s_33_1,
		s_33_2, //6
		s_33_3,
		s_35, 
		s_32, //9
		s_01,
		//s_01_1,
		s_05, //0c
		s_09, 
		s_00, 
        s_22, //0f
        s_12, 
        s_04, 
        s_21, //12
        s_06, 
        s_25_1, 
		s_25_2, //15
		s_25_3, 
        s_27,
        s_07, //18
        s_23, 
        s_16_1, 
		s_16_2, //1b
		s_16_3 
	} state, state_nxt;   // Internal state logic


	always_ff @ (posedge clk)
	begin
		if (reset) 
			state <= halted;
		else
			state <= state_nxt;
	end

	assign opcode = ir[15:12]; 
   
	always_comb
	begin 
		
		// Default controls signal values so we don't have to set each signal
		// in each state case below (If we don't set all signals in each state,
		// we create an inferred latch)
		ld_mar = 1'b0;
		ld_mdr = 1'b0;
		ld_ir = 1'b0;
		ld_ben = 1'b0;
		ld_cc = 1'b0;
		ld_reg = 1'b0;
		ld_pc = 1'b0;
		//ld_led = 1'b0;
		 
		gate_pc = 1'b0;
		gate_mdr = 1'b0;
		gate_alu = 1'b0;
		gate_marmux = 1'b0;
		 
		aluk = 2'b00;
		 
		pcmux = 2'b00;
		drmux = 1'b0;
		sr1mux = 1'b0;
		sr2mux = 1'b0;
		addr1mux = 1'b0;
		addr2mux = 1'b0;
		mio_en = 1'b0;
		 
		mem_mem_ena = 1'b0;
		mem_wr_ena = 1'b0;

			
		// Assign relevant control signals based on current state
		case (state)
			halted: ; //dunno if we actually put anything here
			s_18 : 
				begin 
					gate_pc = 1'b1;
					ld_mar = 1'b1;
				end
			s_18_2 :
			    begin
			        ld_pc = 1'b1;
			        //pc_mux = 2'b00;
			    end
			s_33_1, s_33_2, s_33_3 : //you may have to think about this as well to adapt to ram with wait-states
				begin
					mem_mem_ena = 1'b1;
					mio_en = 1'b1;
					ld_mdr = 1'b1;
				end
			s_35 : 
				begin 
                    gate_mdr = 1'b1;
					ld_ir = 1'b1;
					//ld_cc = 1'b1;
				end
			pause_ir1: ; //ld_led = 1'b1; 
			pause_ir2: ; //ld_led = 1'b1; 
			// the rest of these are week 2 basically
			s_32 : 
				ld_ben = 1'b1;
			s_01: //, s_01_1:
				begin 
					sr2mux = ir[5];
					gate_alu = 1'b1;
					ld_reg = 1'b1;
					ld_cc = 1'b1;
					sr1mux = 1'b1;
				end
			s_05 :
				begin
					sr2mux = ir[5];
					aluk = 2'b01;
					gate_alu = 1'b1;
					ld_reg = 1'b1;
					ld_cc = 1'b1;
					sr1mux = 1'b1;
				end
			s_09 :
				begin
					aluk = 2'b10;
					gate_alu = 1'b1;
					ld_reg = 1'b1;
					ld_cc = 1'b1;
					sr1mux = 1'b1;
					//drmux = 1'b0;
				end
			s_00 : ; //BR //leave as is, this is correct
			s_22 :
				begin
					addr2mux = 2'b10;
					ld_pc = 1'b1;
					pcmux = 2'b10;
				end
			s_12 :
				begin
					sr1mux = 1'b1;
					//aluk = 2'b11; //passthrough
					pcmux = 2'b10;
					ld_pc = 1'b1;
					//gate_alu = 1'b1;
					addr1mux = 1'b1;
				end
			s_04 :
				begin
					gate_pc = 1'b1;
					drmux = 1'b1;
					ld_reg = 1'b1;
				end
			s_21 :
				begin
					addr2mux = 2'b11;
					pcmux = 2'b10;
					ld_pc = 1'b1;
				end
			s_06 :
				begin
					sr1mux = 1'b1;
					addr1mux = 1'b1;
					addr2mux = 2'b01;
					gate_marmux = 1'b1;
					ld_mar = 1'b1;
				end
			s_25_1 :
				mem_mem_ena = 1'b1;
			s_25_2 : 
				mem_mem_ena = 1'b1;
			s_25_3 : 
				begin 
					mem_mem_ena = 1'b1;
					ld_mdr = 1'b1;
					mio_en = 1'b1; 
				end
			s_27 :
				begin
					gate_mdr = 1'b1;
					ld_reg = 1'b1;
					ld_cc = 1'b1;
					//drmux = 1'b0;
				end
			s_07 :
				begin
					sr1mux = 1'b1;
					addr1mux = 1'b1;
					addr2mux = 2'b01;
					gate_marmux = 1'b1;
					ld_mar = 1'b1;
				end
			s_23 :
				begin
					ld_mdr = 1'b1;
					gate_alu = 1'b1;
					aluk = 2'b11; // passthrough
					//mio_en = 1'b1; // why is this high?
					sr1mux = 1'b0;
					
				end 
			s_16_1 :
			     begin
			        mem_mem_ena = 1'b1;
					mem_wr_ena = 1'b1;
				 end
			s_16_2 :
			     begin
			        mem_mem_ena = 1'b1;
					mem_wr_ena = 1'b1;
				 end
			s_16_3 :
			     begin
			        mem_mem_ena = 1'b1;
					mem_wr_ena = 1'b1;	
				end
			// you need to finish the rest of states..... no lol I don't
			

			default : ; //do nothing
		endcase
	end 


	always_comb
	begin
		// default next state is staying at current state
		state_nxt = state;
        // ALL STATES HERE LOOK TO BE DONE
		unique case (state)
			halted : 
				if (run_i) 
					state_nxt = s_18;
			s_18 :
			    state_nxt = s_18_2;
			s_18_2 :
				state_nxt = s_33_1; //notice that we usually have 'r' here, but you will need to add extra states instead 
			s_33_1 :                 //e.g. s_33_2, etc. how many? as a hint, note that the bram is synchronous, in addition, 
				state_nxt = s_33_2;   //it has an additional output register. 
			s_33_2 :
				state_nxt = s_33_3;
			s_33_3 : 
				state_nxt = s_35;
			s_35 :                     //this will be uncommented for part 2
				state_nxt = s_32;
//            s_35 :                      // this will be commented for part 2
//                state_nxt = pause_ir1;
			// pause_ir1 and pause_ir2 are only for week 1 such that TAs can see 
			// the values in ir.
			pause_ir1 : 
				if (continue_i) 
					state_nxt = pause_ir2;
			pause_ir2 : 
				if (~continue_i)	
					state_nxt = s_18;
			s_32 :
				case(opcode)
					4'b0001 : state_nxt = s_01; //add
					4'b0101 : state_nxt = s_05; //and
					4'b1001 : state_nxt = s_09; //not
					4'b0000 : state_nxt = s_00; //br
					4'b1100 : state_nxt = s_12; //jmp
					4'b0100 : state_nxt = s_04; //jsr
					4'b0110 : state_nxt = s_06; //ldr
					4'b0111 : state_nxt = s_07; //str
					4'b1101 : state_nxt = pause_ir1; //pse
					default : state_nxt = s_18;
				endcase
			s_01 :
//			    state_nxt = s_01_1;
//			s_01_1:
				state_nxt = s_18;
			s_05 : //And
				state_nxt = s_18;
			s_09 : //not 
				state_nxt = s_18;
			s_00 : //br
				case(ben_out)	
					1'b1 : state_nxt = s_22;
					1'b0 : state_nxt = s_18;
				endcase
			s_22 :
				state_nxt = s_18; 
			s_12 : //jmp
				state_nxt = s_18; 
			s_04 : //jsr
				state_nxt = s_21;
			s_21 :
				state_nxt = s_18; 
			s_06 : //ldr
				state_nxt = s_25_1;
			s_25_1 :
				state_nxt = s_25_2;
			s_25_2 :
				state_nxt = s_25_3;
			s_25_3 :
				state_nxt = s_27;
			s_27 :
			    //if (continue_i)
				state_nxt = s_18; 
			s_07 : //str
				state_nxt = s_23;
			s_23 :
				state_nxt = s_16_1;
			s_16_1 :
				state_nxt = s_16_2;
			s_16_2 :
				state_nxt = s_16_3;
			s_16_3 :
				state_nxt = s_18; 
			// you need to finish the rest of states..... nope I will pass
			default :
			    state_nxt = state;
		endcase
	end
	
endmodule
