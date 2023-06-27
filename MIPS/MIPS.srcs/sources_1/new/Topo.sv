`timescale 1ns / 1ps

module Topo(
    input   logic        reset,
    input   logic        clock,
    output  logic        halt
);

logic            [15:0]  data_in_i;
logic            [15:0]  data_out_i;
logic                    mem_write_i;
logic              [5:0] adress_i;
logic                    jump_s;
logic                    pce_s;
logic                    ir_enable_s;
logic                    s_addr_s;
logic                    mtr_s;
logic                    flag_r_e_s;
decoded_instruction_type decoded_instruction_s;
logic                    reg_write_s;
logic              [1:0] aluop_s;
logic                    zero_s;
logic                    ovf_s;
logic                    sgn_ovf_s;
logic                    opd_s;
logic              [1:0] ula_src_s;
logic                    mem_in_s;

Datapath datapath_i
(
    .reset(reset),
    .clock(clock),
    .jump(jump_s),
    .pce(pce_s),
    .ir_enable(ir_enable_s),
    .s_addr(s_addr_s),
    .mtr(mtr_s),
    .aluop(aluop_s),
    .reg_write(reg_write_s),
    .flag_r_e(flag_r_e_s),
    .decoded_instruction(decoded_instruction_s),
    .zero(zero_s),
    .ovf(ovf_s),
    .sgn_ovf(sgn_ovf_s),
    .address(adress_i),
    .data_out(data_out_i),
    .data_in(data_in_i),
    .opd(opd_s),
    .mem_write(mem_write_i),
    .ula_src (ula_src_s),
    .mem_in(mem_in_s)
);

Control control_i
(
    .reset(reset),
    .clock(clock),
    .jump(jump_s),
    .pce(pce_s),
    .ir_enable(ir_enable_s),
    .s_addr(s_addr_s),
    .mtr(mtr_s),
    .aluop(aluop_s),
    .reg_write(reg_write_s),
    .flag_r_e(flag_r_e_s),
    .decoded_instruction(decoded_instruction_s),
    .zero(zero_s),
    .ovf(ovf_s),
    .sgn_ovf(sgn_ovf_s),
    .opd(opd_s),
    .halt(halt),
    .mem_write(mem_write_i),
    .ula_src(ula_src_s),
    .mem_in(mem_in_s)
);

Memory memory_i
(
     .data_out(data_out_i),
     .data_in(data_in_i),
     .clock(clock),
     .reset(reset),
     .mem_write(mem_write_i),
     .adress(adress_i)
);

Testbench testbench_i(
    .clock(clock),
    .reset(reset),
    .halt(halt)
);
    
    
endmodule : Topo