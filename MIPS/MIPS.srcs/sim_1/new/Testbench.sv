`timescale 1ns / 1ps
module Testbench(
    output logic clock,
    output logic reset,
    input logic halt
    );

Topo topo_i(
    .clock(clock),
    .reset(reset),
    .halt(halt)
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

always @(posedge halt) begin
  if (halt) begin
    reset = 1;
    $display("Sinal Halt finalizou");
    $finish;
  end
end

initial begin
  #600000;
  $display("Fim por timeout");
  $finish;
end


endmodule