`timescale 1ns / 1ps

module Memory(
    input logic [15:0] data_out,
    output logic [15:0] data_in,
    input logic clock,
    input logic reset,
    input logic mem_write,
    input logic [5:0] adress
);

logic [15:0] memoria [0:63];

always_ff @(posedge clock)begin
    if(reset) begin
        memoria[0]  <= "1111111111111111";
        memoria[1]  <= "0000000000000000";
        memoria[2]  <= "0000000000000000";
        memoria[3]  <= "0000000000000000";
        memoria[4]  <= "0000000000000000";
        memoria[5]  <= "0000000000000000";        
        memoria[6]  <= "0000000000000000";
        memoria[7]  <= "0000000000000000";
        memoria[8]  <= "0000000000000000";
        memoria[9]  <= "1111111111111111";
        memoria[10] <= "0000000000000000";
        memoria[11] <= "0000000000000000";        
        memoria[12] <= "0000000000000000";
        memoria[13] <= "0000000000000000";
        memoria[14] <= "0000000000000000";
        memoria[15] <= "0000000000000000";
        memoria[16] <= "0000000000000000";
        memoria[17] <= "0000000000000000";        
        memoria[18] <= "0000000000000000";
        memoria[19] <= "0000000000000000";
        memoria[20] <= "0000000000000000";
        memoria[21] <= "0000000000000000";
        memoria[22] <= "0000000000000000";
        memoria[23] <= "0000000000000000";        
        memoria[24] <= "0000000000000000";
        memoria[25] <= "0000000000000000";
        memoria[26] <= "0000000000000000";
        memoria[27] <= "0000000000000000";
        memoria[28] <= "0000000000000000";
        memoria[29] <= "0000000000000000";        
        memoria[30] <= "0000000000000000";
        memoria[31] <= "0000000000000000";
        memoria[32] <= "0000000000000000";
        memoria[33] <= "0000000000000000";
        memoria[34] <= "0000000000000000";
        memoria[35] <= "0000000000000000";
        memoria[36] <= "0000000000000000";
        memoria[37] <= "0000000000000000";
        memoria[38] <= "0000000000000000";
        memoria[39] <= "0000000000000000";
        memoria[40] <= "0000000000000000";
        memoria[41] <= "0000000000000000";
        memoria[42] <= "0000000000000000";
        memoria[43] <= "0000000000000000";
        memoria[44] <= "0000000000000000";
        memoria[45] <= "0000000000000000";
        memoria[46] <= "0000000000000000";
        memoria[47] <= "0000000000000000";
        memoria[48] <= "0000000000000000";
        memoria[49] <= "0000000000000000";
        memoria[50] <= "0000000000000000";
        memoria[51] <= "0000000000000000";
        memoria[52] <= "0000000000000000";
        memoria[53] <= "0000000000000000";
        memoria[54] <= "0000000000000000";         
        memoria[55] <= "0000000000000000";     
        memoria[56] <= "0000000000000000";     
        memoria[57] <= "0000000000000000";     
        memoria[58] <= "0000000000000000";     
        memoria[59] <= "0000000000000000";     
        memoria[60] <= "0000000000000000";     
        memoria[61] <= "0000000000000000";     
        memoria[62] <= "0000000000000000";     
        memoria[63] <= "0000000000000000";        
    end else begin
        if(mem_write) begin
            memoria[adress] <= data_out;
        end  
    end
end

always_comb begin
    data_in <= memoria[adress];
end

endmodule