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
    I_HALT,
    I_ILOAD,
    I_MOVE,
    I_SHIFTADD
}decoded_instruction_type;

module Control(

        input logic clock,
        input logic reset,
        output logic s_addr,
        output logic pce,
        output logic mem_write,
        output logic jump,
        output logic ir_enable,
        output logic opd,
        output logic mtr,
        output logic reg_write,
        output logic [1:0] aluop,
        input logic [1:0] alu_flag,
        input decoded_instruction_type decoded_instruction,
        output logic halt,
        input logic zero,
        output logic flag_r_e,
        input logic ovf,
        input logic sgn_ovf,
        output logic [1:0] ula_src,
        output logic mem_in
       
    );
    
    typedef enum {
    BUSCA_INSTR
   ,REG_INSTR
   ,DECODIFICA
   ,LOAD_1
   ,LOAD_2
   ,STORE_1
   ,STORE_2
   ,HALT_P
   ,JUMP_1
   ,ADD
   ,SUB
   ,OR_
   ,AND_
   ,JZERO
   ,ILOAD
   ,ILOAD2
   ,MOVE
   ,SHIFTADD
}state_t;

state_t estado;
state_t prox_estado;

    always_ff @(posedge clock or posedge reset) begin
        if(reset) begin
            estado<=BUSCA_INSTR;
        end else begin
            estado<=prox_estado;
        end
    end
    
    always_comb begin
        jump = 'b0;
        s_addr = 'b0;
        ir_enable = 'b0;
        mem_write = 'b0;
        reg_write = 'b0;
        pce = 'b0;
        aluop = 'b00;
        ir_enable = 'b0;
        opd = 'b0;
        mtr = 'b0;
        halt = 'b0;
        flag_r_e= 1'b0;
        ula_src=2'b00;
        mem_in= 1'b0;
        case(estado)
          BUSCA_INSTR: begin
          prox_estado = REG_INSTR;
        end
 
        REG_INSTR: begin
            prox_estado = DECODIFICA;
            ir_enable = 'b1;
            pce = 'b1;
            end   
        
        DECODIFICA: begin 
            case(decoded_instruction)
            
                I_HALT:begin
                 prox_estado = HALT_P;
                 
                 end 
                 I_LOAD: begin
                
                prox_estado= LOAD_1;
                s_addr=1'b1;
                opd= 1'b1;
                mtr= 1'b0;
                
                end
                
                I_STORE: begin
                prox_estado = STORE_1;
                s_addr= 1'b1;
                
                end
                
                I_JUMP: begin
                prox_estado = JUMP_1;
                jump = 1'b1;
                
                end
                
               
                
                I_ADD: begin
                prox_estado = ADD;
                aluop = 2'b00;
                
                end
                
                I_SUB: begin
                prox_estado = SUB; 
                aluop = 2'b01;
                
                end
                
                I_OR: begin
                prox_estado = OR_;
                aluop = 2'b10;
                
                end
                
                I_AND: begin
                prox_estado = AND_;
                aluop = 2'b11;
                
                end
                
                I_JZERO: begin
                   prox_estado= JZERO;
                end
                
                 I_ILOAD: begin
                    prox_estado = ILOAD;
                    aluop = 2'b00;
                    ula_src=2'b01;
                   // opd=1'b1;
                 end
                 
                 I_MOVE:begin //Move
                     prox_estado = AND_;
                     aluop= 2'b11;
                 end
                 
                 I_SHIFTADD:begin //Shift add
                 prox_estado = SHIFTADD;
                 aluop = 2'b00;
                 ula_src= 2'b10;
                 end
                    
                default begin
                    prox_estado = BUSCA_INSTR;
                end
            endcase
        
        end 
        
       
        
        JZERO: begin
            prox_estado = BUSCA_INSTR;
            if(zero) begin
                jump = 1'b1;
                pce= 1'b1;
                end
        end
        
        
        ADD: begin
            prox_estado = BUSCA_INSTR;
            flag_r_e= 1'b1;
            reg_write = 1'b1;
            aluop = 2'b00;
            mtr = 'b1;
        end
        
        SHIFTADD:begin
           prox_estado = BUSCA_INSTR;
            flag_r_e= 1'b1;
            reg_write = 1'b1;
            aluop = 2'b00;
            mtr = 'b1;
            ula_src = 2'b10;
        end
        
        SUB: begin
            prox_estado = BUSCA_INSTR;
            flag_r_e= 1'b1;
            reg_write = 1'b1;
            aluop= 2'b01;
            mtr = 'b1;
        end
        
        OR_: begin
            prox_estado = BUSCA_INSTR;
            flag_r_e= 1'b1;
            reg_write = 1'b1;
            aluop= 2'b10;
            mtr = 'b1;    
        end
        
        AND_: begin
            prox_estado = BUSCA_INSTR;
            flag_r_e= 1'b1;
            reg_write = 1'b1;
            aluop= 2'b11;
            mtr = 'b1;
        end
        
        JUMP_1: begin
            prox_estado=BUSCA_INSTR;
            jump=1'b1;
            pce= 1'b1;
        end
        
        LOAD_1: begin
        prox_estado= LOAD_2;
        ir_enable = 'b0;
        s_addr=1'b1;
        opd= 1'b1;
        mtr= 1'b0;
        end
        
        LOAD_2: begin
        prox_estado= BUSCA_INSTR;
        ir_enable = 'b0;
        s_addr=1'b1;
        reg_write=1'b1;
        opd= 1'b1;
        mtr= 1'b0;
        end
        
       ILOAD: begin
       prox_estado= ILOAD2;
       flag_r_e= 1'b1;
       aluop = 2'b00;
       ula_src=2'b01;
       mem_in=1'b1;
       ir_enable= 1'b0;
      // opd = 1'b1;
       end
        
       ILOAD2:begin
       prox_estado=BUSCA_INSTR;  
       mem_in=1'b1;
       ir_enable= 1'b0;
       mtr=1'b0;
       reg_write= 1'b1;
       ula_src=2'b01;
      // opd = 1'b1;
       
      
      
       end
       
       
        
        STORE_1: begin
          prox_estado = STORE_2;
          ir_enable = 'b0;
          s_addr=1'b1;
        end
        
        STORE_2: begin
            prox_estado= BUSCA_INSTR;
            ir_enable = 'b0;
            s_addr=1'b1;
            mem_write= 1'b1;
        end
        
        HALT_P: begin
        prox_estado= HALT_P;
        halt= 1'b1;
        
        end
        
        
        
        endcase
        
    end  
  
    
    
endmodule
