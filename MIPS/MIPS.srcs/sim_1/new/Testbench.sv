`timescale 1ns / 1ps

module Testbench(
   output logic clock,
   output logic reset
);

always begin
    clock <= 0;
    #10n;
    clock <= 1;
end

endmodule : Testbench

