`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2022 12:20:54 PM
// Design Name: 
// Module Name: CU_DCDR
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CU_DCDR(
        input logic[10:0] IR,
        input logic INT_TAKEN, BR_EQ, BR_LT, BR_LTU,
        output logic[3:0] ALU_FUN,
        output logic[2:0] PC_SOURCE,
        output logic[1:0] ALU_SRCB, RF_WR_SEL,
        output logic ALU_SRCA
    );
    
    always_comb begin
        ALU_FUN = 4'b0;
        PC_SOURCE = 3'b0;
        ALU_SRCB = 2'b0;
        RF_WR_SEL = 2'b0;
        ALU_SRCA = 1'b0; 
        case(IR[6:0])
            7'b0110011,7'b0010011: begin // add and or sll slt sltu sra srl sub xor
                                         //addi andi ori slli slti sltui srai srli xori
                RF_WR_SEL = 2'b11;
                if(IR[5]) ALU_FUN = {IR[10],IR[9:7]};   //all non-immediate instructions work off of
                else begin                              //func3 opcode and 30th bit
                    ALU_SRCB = 2'b01;                   //all other non shift-right insturctions work
                    if(IR[9:7] == 3'b101) ALU_FUN = {IR[10], IR[9:7]};  //off of just the func3 opcode
                        else ALU_FUN = {1'b0,IR[9:7]}; 
                end
            end
            7'b1100111: begin // jalr
                PC_SOURCE = 3'b001;
                ALU_SRCB = 2'b01; 
            end
            7'b0000011: begin //lb lbu lh lhu lw
                ALU_SRCB = 2'b01;
                RF_WR_SEL = 2'b10;
            end
            7'b0100011: begin //sb sh sw
                ALU_SRCB = 2'b10;
            end
            7'b1100011: begin
                case(IR[9:7])
                    3'b000: if(BR_EQ == 1'b1) PC_SOURCE = 3'b010; //beq
                    3'b001: if(BR_EQ != 1'b1) PC_SOURCE = 3'b010; //bne
                    3'b100: if(BR_LT == 1'b1) PC_SOURCE = 3'b010; //blt
                    3'b101: if(BR_LT != 1'b1) PC_SOURCE = 3'b010; //bge
                    3'b110: if(BR_LTU == 1'b1) PC_SOURCE = 3'b010; //bltu
                    3'b111: if(BR_LTU != 1'b1) PC_SOURCE = 3'b010; //bgeu
                endcase
            end
            7'b0010111: begin //auipc
                ALU_SRCA = 1'b1;
                ALU_SRCB = 2'b11;
                RF_WR_SEL = 2'b11;
            end
            7'b0110111: begin //lui
                ALU_FUN = 4'b1001;
                ALU_SRCA = 1'b1;
                RF_WR_SEL = 2'b11;
            end
            7'b1101111: //jal
                PC_SOURCE = 3'b011; 
            7'b1110011: begin 
                if(IR[7]) begin //csrrw
                    RF_WR_SEL = 2'b10;
                end else begin //mret
                    PC_SOURCE = 3'b101;
                end
            end
        endcase
        if(INT_TAKEN) PC_SOURCE = 3'b100; //put the interrupt handling
                                          //at the end. always_comb uses
                                          //the last call to the value
    end
endmodule
