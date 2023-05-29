`timescale 1ns / 1ps

module Topo(
    input  logic        reset,
    input  logic        clock,
    output logic        halt,
    output logic  [5:0] address,
    input  logic [15:0] data_in,
    output logic [15:0] data_out,
    output logic        mem_write
);

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
    .address(address_s),
    .data_out(data_out),
    .data_in(data_in),
    .opd(opd_s)
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
    .halt(halt)
);

endmodule : Topo