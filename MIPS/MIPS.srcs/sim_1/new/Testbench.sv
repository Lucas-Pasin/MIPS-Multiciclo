`timescale 1ns / 1ps
module Testbench(
    output logic clock,
    output logic reset,
    input logic halt
    );

initial begin
    reset = 0;
    #6;
    reset = 1;
    #12;
    reset = 0;
end
always begin
    clock = 0;
    #5;
    clock = 1;
    #5;
end


endmodule