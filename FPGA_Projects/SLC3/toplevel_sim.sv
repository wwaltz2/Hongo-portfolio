//`timescale 1ns / 1ps

module toplevel_sim();

    timeunit 10ns;	// This is the amount of time represented by #1 
    timeprecision 1ns;

    logic        clk;
    logic        reset;

    logic 		 run_i;
    logic 		 continue_i;
    logic [15:0] sw_i;

    logic [15:0] led_o;
    logic [7:0]  hex_seg_left;
    logic [3:0]  hex_grid_left;
    logic [7:0]  hex_seg_right;
    logic [3:0]  hex_grid_right;
    
    processor_top processor(.*);
    
    logic [15:0] PC;
    assign PC = processor.slc3.cpu.pc;
    logic [15:0] IR;
    assign IR = processor.slc3.cpu.ir;
    logic [15:0] MAR;
    assign MAR = processor.slc3.cpu.mar;
    logic [15:0] MDR;
    assign MDR = processor.slc3.cpu.mdr;
    logic [15:0] ALU;
    assign ALU = processor.slc3.cpu.alu;
//    logic [15:0] bus;
//    assign bus = processor.slc3.cpu.io_bus;
    logic [15:0] reg_file_0;
    assign reg_file_0 = processor.slc3.cpu.reg_file[0];
    logic [15:0] reg_file_1;
    assign reg_file_1 = processor.slc3.cpu.reg_file[1];
    logic [15:0] reg_file_2;
    assign reg_file_2 = processor.slc3.cpu.reg_file[2];
    logic [15:0] reg_file_3;
    assign reg_file_3 = processor.slc3.cpu.reg_file[3];
    logic [15:0] reg_file_4;
    assign reg_file_4 = processor.slc3.cpu.reg_file[4];
    logic [15:0] reg_file_7;
    assign reg_file_7 = processor.slc3.cpu.reg_file[7];
    logic [4:0] state;
    assign state = processor.slc3.cpu.cpu_control.state;
//    logic [15:0] mem_x10;
//    assign mem_x10 = processor.mem_subsystem.mem_array[16'h0010];
//    logic [7:0] load_reg;
//    assign load_reg = processor.slc3.cpu.load_reg;
//    logic [15:0] hex_display;
//    assign hex_display = processor.slc3.io_bridge.hex_display;
//    logic [15:0] hex_display_debug;
//    assign hex_display_debug = processor.slc3.hex_display_debug;
    
    initial begin: CLOCK_INITIALIZATION
		clk = 1;
	end 
	
	always begin: CLOCK_GENERATION
		#1 clk = ~clk;
	end
	
    initial begin: TEST_VECTOR
        sw_i <= 16'h0;
        continue_i <= 1'b0;
        reset <= 1'b1;
        run_i <= 1'b0;
        #10 reset <= 1'b0;
        #10 sw_i <= 16'h00A3;
        #40 run_i <= 1'b1;
        #40 run_i <= 1'b0;
        #400 continue_i <= 1'b1;
        #400 continue_i <= 1'b0;
        #400 continue_i <= 1'b1;
        #400 continue_i <= 1'b0;
        #400 continue_i <= 1'b1;
        #400 continue_i <= 1'b0;
        //#400 sw_i <= 16'h0007;
        #400 continue_i <= 1'b1;
        #400 continue_i <= 1'b0;
        #400 continue_i <= 1'b1;
        #400 continue_i <= 1'b0;
        //#400 sw_i <= 16'h01F3;
        #400 continue_i <= 1'b1;
        #400 continue_i <= 1'b0;
        #400 continue_i <= 1'b1;
        #400 continue_i <= 1'b0;
        #400 continue_i <= 1'b1;
        //#400 sw_i <= 16'h7E2D;
        #400 continue_i <= 1'b0;
        #400 continue_i <= 1'b1;
        #400 continue_i <= 1'b0;
        #400 continue_i <= 1'b1;
        #400 continue_i <= 1'b0;
        #400 continue_i <= 1'b1;
        #400 continue_i <= 1'b0;
        #400 continue_i <= 1'b1;
        #400 continue_i <= 1'b0;
        #400 continue_i <= 1'b1;
        #400 continue_i <= 1'b0;
        #400 continue_i <= 1'b1;
        #400 continue_i <= 1'b0; // idk how to make a repeat block with delays LOL       

        
//        #1 release processor.slc3.cpu.pc;
//        release processor.slc3.cpu.ir;
//        release processor.slc3.cpu.mar;
//        release processor.slc3.cpu.mdr; // for forcing
                
        $finish();
        
    end
	

endmodule
