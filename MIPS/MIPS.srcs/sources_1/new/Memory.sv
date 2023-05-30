module Memory(
    input logic [15:0] data_out,
    output logic [15:0] data_in,
    input logic clock,
    input logic reset,
    input logic mem_write,
    input logic [5:0] adress
);

logic [15:0] memoria [0:63];

initial begin
  $readmemh("C:/Users/lucas/Desktop/ORG TRABSON/MIPS-Multiciclo/programa.txt", memoria);
 end

always_ff @(posedge clock) begin
     if(mem_write) begin
            memoria[adress] <= data_out;
     end  
end

always_comb begin
    data_in <= memoria[adress];
end

endmodule