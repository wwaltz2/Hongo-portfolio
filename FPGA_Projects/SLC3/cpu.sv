//------------------------------------------------------------------------------
// Engineers:        Evan McGowan and Bill Waltz
//   
// Design Name:    SLC-3 core
// Module Name:    SLC3
//
//------------------------------------------------------------------------------

module cpu (
    input   logic        clk,
    input   logic        reset,

    input   logic        run_i,
    input   logic        continue_i,
    output  logic [15:0] hex_display_debug,
    output  logic [15:0] led_o,
   
    input   logic [15:0] mem_rdata,
    output  logic [15:0] mem_wdata, // mdr
    output  logic [15:0] mem_addr, // mar
    output  logic        mem_mem_ena,
    output  logic        mem_wr_ena
);


// Internal connections
logic ld_mar; 
logic ld_mdr; 
logic ld_ir; 
logic ld_ben; 
logic ld_cc; 
logic ld_reg; 
logic ld_pc; 
//logic ld_led;
logic [7:0] load_reg;

logic gate_pc;
logic gate_mdr;
logic gate_alu; 
logic gate_marmux;

logic [1:0] pcmux;
logic       drmux;
logic       sr1mux;
logic [2:0] sr1_in;
logic       sr2mux;
logic [2:0] dr_in;
logic       addr1mux;
logic [1:0] addr2mux;
logic [1:0] aluk;
logic       mio_en;

logic [15:0] mdr_in;
logic [15:0] mar; 
logic [15:0] mdr;
logic [15:0] ir;
logic [15:0] pc;
logic [15:0] alu;
logic ben;
//additional signals
logic [15:0] pcmux_out;
logic [15:0] addr_adder_out;
logic [15:0] io_bus;
logic [15:0] sr2mux_out;
logic [15:0] sr1_out, sr2_out;
logic [15:0] addr1_out, addr2_out;
logic [2:0] nzp_in, nzp_out;
logic ben_out;

//register unit!
logic [15:0] reg_file [8]; //should this be [7:0]?

assign mem_addr = mar;
assign mem_wdata = mdr; // from lab manual: these are the same thing
assign ben = ((ir[11] & nzp_out[2]) | (ir[10] & nzp_out[1]) | (ir[9] & nzp_out[0]));

// State machine, you need to fill in the code here as well
// .* auto-infers module input/output connections which have the same name
// This can help visually condense modules with large instantiations, 
// but can also lead to confusing code if used too commonly
control cpu_control (.*);


assign led_o = ir;
assign hex_display_debug = pc; // was IR
assign addr_adder_out = addr1_out + addr2_out;

always_comb
begin
    // assigning bus inputs
    unique case({gate_pc,gate_mdr,gate_marmux,gate_alu})
        4'b0001 : io_bus = alu;
        4'b0010 : io_bus = addr_adder_out;
        4'b0100 : io_bus = mdr;
        4'b1000 : io_bus = pc;
        //default : io_bus = 16'hZZZZ;
    endcase
    
    // assigning input into MDR
    unique case(mio_en)
        1'b0 : mdr_in = io_bus;
        1'b1 : mdr_in = mem_rdata;
    endcase
    
    //PC MUX
    unique case(pcmux)
        2'b00 : pcmux_out = pc + 16'h0001;
        2'b01 : pcmux_out = io_bus;
        2'b10 : pcmux_out = addr_adder_out;
        2'b11 : pcmux_out = 16'hxxxx;
    endcase
    
    //SR2 MUX
    unique case(sr2mux)
        1'b0 : sr2mux_out = sr2_out;
        1'b1 :
            if (ir[4]) begin // sign-extending
                sr2mux_out = {11'b1111111111, ir[4:0]};
            end else begin
                sr2mux_out = {11'b0000000000, ir[4:0]};
            end         
    endcase
    
    //ALU
    unique case(aluk)
        2'b00 : alu = sr1_out + sr2mux_out;
        2'b01 : alu = sr1_out & sr2mux_out;
        2'b10 : alu = ~sr1_out;
        2'b11 : alu = sr1_out;
    endcase
    
    //ADDR1 MUX
    unique case (addr1mux)
        1'b0 : addr1_out = pc;
        1'b1 : addr1_out = sr1_out;
    endcase
    
    //ADDR2 MUX
    unique case (addr2mux)
        2'b00 : addr2_out = 16'h0000;
        2'b01 :
            if (ir[5]) begin
                addr2_out = {10'hFFFF, ir[5:0]};
            end else begin
                addr2_out = {10'h0000, ir[5:0]};
            end
        2'b10 :
            if (ir[8]) begin
                addr2_out = {7'hFFFF, ir[8:0]};
            end else begin
                addr2_out = {7'h0000, ir[8:0]};
            end
        2'b11 :
            if (ir[10]) begin
                addr2_out = {5'hFFFF, ir[10:0]};
            end else begin
                addr2_out = {5'h0000, ir[10:0]};
            end
    endcase
    
    //SR1_in_mux
    unique case (sr1mux)
        1'b0: sr1_in = ir[11:9];
        1'b1: sr1_in = ir[8:6];
    endcase
    
    //SR1_out
    sr1_out = reg_file[sr1_in];
    //SR2_out
    sr2_out = reg_file[ir[2:0]];
    
    unique case(drmux)
        1'b0: dr_in = ir[11:9];
        1'b1: dr_in = 3'b111;
    endcase

load_reg = 8'h00;
    
    if(ld_reg)
    begin
        load_reg[dr_in] = 1'b1;
    end
    else begin
        load_reg = 8'h00;
    end

    nzp_in = 3'b000;

    if(io_bus == 16'h0000)
        nzp_in = 3'b010;
    else if (io_bus[15])
        nzp_in = 3'b100;
    else if ((io_bus[15]==1'b0) && (io_bus != 16'h0000))
        nzp_in = 3'b001;    
    
end




load_reg #(.DATA_WIDTH(16)) reg_file_0 (
    .clk    (clk),
    .reset  (reset),

    .load   (load_reg[0]),
    .data_i (io_bus),

    .data_q (reg_file[0])
);   

load_reg #(.DATA_WIDTH(16)) reg_file_1 (
    .clk    (clk),
    .reset  (reset),

    .load   (load_reg[1]),
    .data_i (io_bus),

    .data_q (reg_file[1])
);   

load_reg #(.DATA_WIDTH(16)) reg_file_2 (
    .clk    (clk),
    .reset  (reset),

    .load   (load_reg[2]),
    .data_i (io_bus),

    .data_q (reg_file[2])
);   

load_reg #(.DATA_WIDTH(16)) reg_file_3 (
    .clk    (clk),
    .reset  (reset),

    .load   (load_reg[3]),
    .data_i (io_bus),

    .data_q (reg_file[3])
);   

load_reg #(.DATA_WIDTH(16)) reg_file_4 (
    .clk    (clk),
    .reset  (reset),

    .load   (load_reg[4]),
    .data_i (io_bus),

    .data_q (reg_file[4])
);   

load_reg #(.DATA_WIDTH(16)) reg_file_5 (
    .clk    (clk),
    .reset  (reset),

    .load   (load_reg[5]),
    .data_i (io_bus),

    .data_q (reg_file[5])
);   

load_reg #(.DATA_WIDTH(16)) reg_file_6 (
    .clk    (clk),
    .reset  (reset),

    .load   (load_reg[6]),
    .data_i (io_bus),

    .data_q (reg_file[6])
);   

load_reg #(.DATA_WIDTH(16)) reg_file_7 (
    .clk    (clk),
    .reset  (reset),

    .load   (load_reg[7]),
    .data_i (io_bus),

    .data_q (reg_file[7])
);    

load_reg #(.DATA_WIDTH(1)) reg_ben (
    .clk    (clk),
    .reset  (reset),

    .load   (ld_ben),
    .data_i (ben),

    .data_q (ben_out)
);    

    
load_reg #(.DATA_WIDTH(3)) nzp_reg (
    .clk    (clk),
    .reset  (reset),

    .load   (ld_cc),
    .data_i (nzp_in),

    .data_q (nzp_out)
);

load_reg #(.DATA_WIDTH(16)) mar_reg (
    .clk    (clk),
    .reset  (reset),

    .load   (ld_mar),
    .data_i (io_bus),

    .data_q (mar)
);

load_reg #(.DATA_WIDTH(16)) mdr_reg (
    .clk    (clk),
    .reset  (reset),

    .load   (ld_mdr),
    .data_i (mdr_in),

    .data_q (mdr)
);

load_reg #(.DATA_WIDTH(16)) ir_reg (
    .clk    (clk),
    .reset  (reset),

    .load   (ld_ir),
    .data_i (io_bus),

    .data_q (ir)
);

load_reg #(.DATA_WIDTH(16)) pc_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_pc),
    .data_i(pcmux_out),

    .data_q(pc)
);

endmodule