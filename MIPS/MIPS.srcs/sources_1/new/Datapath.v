`timescale 1ns / 1ps
  typedef enum  logic [4:0]{
    I_NOP,
    I_LOAD,
    I_STORE,
    I_ADD,
    I_SUB,
    I_AND,
    I_OR,
    I_JUMP,
    I_JZERO,
    I_HALT
}decoded_instruction_type;

module Datapath(
        input logic clock,
        input logic reset,
        input logic s_addr,
        input logic pce,
        input logic mem_write,
        input logic jump,
        input logic ir_enable,
        input logic opd,
        input logic mtr,
        input logic reg_write,
        input logic [1:0] aluop,
        input logic [15:0] data_in,
        output logic [1:0] alu_flag,
        output decoded_instruction_type decoded_instruction,
        output logic [15:0] data_out,
        output logic [5:0] address
    );

   logic [15:0] A;
   logic [15:0] B;
   logic [15:0] ula_out;
   logic cc;
   logic ov_f;
   logic sov_f;
   logic [15:0] instruction;
   logic [15:0] data;
   logic [15:0] write_data;
   logic [15:0] R0;
   logic [15:0] R1;
   logic [15:0] R2;
   logic [15:0] R3;
   logic [15:0] addr_a;
   logic [15:0] addr_b;
   logic [15:0] addr_x;
   logic [5:0] pc;
   logic [5:0] pc_in;
   logic [5:0] decod_address;
   logic [1:0] decod_addrB;
   
    always_comb begin
      case(aluop)
        2'b00: begin //ADD
            {cc,ula_out[14:0]} = A[14:0] + B[14:0];
            {ov_f,ula_out[15]} = A[15] + B[15] + cc; 
            sov_f = ov_f ^ cc;
        end
        2'b01: begin //SUB
            B[15:0]= ~B[15:0]+ 1;
            {cc,ula_out[14:0]} = A[14:0] + B[14:0];
            {ov_f,ula_out[15]} = A[15] + B[15] + cc; 
             sov_f = ov_f ^ cc;
        end
        2'b10: begin //AND
            {ula_out} = A & B;
            sov_f = 1'b0;
            ov_f = 1'b0;
            cc = 1'b0;
        end
        2'b11: begin //OR
            {ula_out} = A | B;
            sov_f = 1'b0;
            ov_f = 1'b0;
            cc = 1'b0;
        end
      endcase
    end
    
    always_ff @(posedge clock or negedge reset)begin
        if(ir_enable) begin
            instruction <= data_in;
        end
    end
    
    always_ff @(posedge clock or negedge reset)begin
        data <= data_in;
    end
    
    always_comb begin
        if(mtr)begin
            write_data <= ula_out;
        end else begin
            write_data <= data_in;
        end
    end
    
    //Banco de registradores
    always_ff @(posedge clock or negedge reset) begin 
        if(reg_write) begin
            unique case(addr_x)
                2'b00: R0=write_data;
                2'b01: R1=write_data;
                2'b10: R2=write_data;
                2'b11: R3=write_data;
            endcase
         end 
             case(addr_a)
                2'b00: A=R0;
                2'b01: A=R1;
                2'b10: A=R2;
                2'b11: A=R3;
            endcase
            case(addr_b)
                2'b00: B=R0;
                2'b01: B=R1;
                2'b10: B=R2;
                2'b11: B=R3;
            endcase
     end
     
     always_ff @(posedge clock or negedge reset) begin //PC
        if(reset) begin
            R0 <= 'd0;
            R1 <= 'd0;
            R2 <= 'd0;
            R3 <= 'd0;
        end
        
        if(pce) begin
            pc <= pc_in;
        end
     end
     
     always_comb begin
        if(jump) begin
            
        end else begin
            pc_in <= pc + 1;
        end
     end
     
     always_comb begin
        if(s_addr) begin
            
        end else begin
            address <= pc;
        end
     end
     
     always_comb begin
        if(opd) begin
           addr_b = addr_x;
        end else begin
            addr_b = decod_addrB;
        end
     end
     
    always_comb begin  // DECODER
          decod_address = 'd0;
         case(instruction[15:8])
            8'b1000_0001: begin  // LOAD
                decoded_instruction = I_LOAD;
                addr_x = instruction[7:6];
                decod_address = instruction[5:0];
            end
            8'b1000_0010: begin  // STORE
                decoded_instruction = I_STORE;
                decod_addrB = instruction[7:6];
                decod_address = instruction[5:0];
            end
            8'b1010_0001: begin  // ADD
                decoded_instruction = I_OR;
                addr_a = instruction[1:0];
                decod_addrB = instruction[3:2];
                addr_x = instruction[7:6];
            end
            8'b1010_0010: begin  // SUB
                decoded_instruction = I_OR;
                addr_a = instruction[1:0];
                decod_addrB = instruction[3:2];
                addr_x = instruction[7:6];
            end
            8'b1010_0011: begin  // AND
                decoded_instruction = I_OR;
                addr_a = instruction[1:0];
                decod_addrB = instruction[3:2];
                addr_x = instruction[7:6];
            end
            8'b1010_0100: begin  // OR
                decoded_instruction = I_OR;
                addr_a = instruction[1:0];
                decod_addrB = instruction[3:2];
                addr_x = instruction[7:6];
            end
            8'b0000_0001: begin  // BRANCH
                decoded_instruction = I_JUMP;
                decod_address = instruction[5:0];
            end
            8'b0000_0010: begin  // BZERO
                decoded_instruction = I_JZERO;
                decod_address = instruction[5:0];
            end
             8'b1111_1111: begin  // HALT
                decoded_instruction = I_HALT;
            end
            default: begin //NOP
                decoded_instruction = I_NOP;
            end
         endcase
      end
     
endmodule
