`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2022 12:30:54 PM
// Design Name: 
// Module Name: CSR
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


module CSR(
        input logic RESET, INT_TAKEN, WR_EN, CLK,
        input logic[11:0] ADDR,
        input logic[31:0] PC, WD,
        output logic CSR_ME,
        output logic[31:0] CSR_MEPC, CSR_MTVEC, RD
    );
    
    logic[31:0] REG[0:3]; //our 32-bit x 3 register
    logic[1:0] addr; //internal address for decoding
    
    always_comb begin
        case(ADDR) //decoder for input address's
            12'h304: addr = 2'b0;
            12'h305: addr = 2'b1;
            12'h341: addr = 2'b10;
            default: addr = 2'b0;
        endcase
        CSR_ME = REG[0][0]; //setting output variables
        CSR_MEPC = REG[2];
        CSR_MTVEC = REG[1];
        RD = REG[addr];
    end
    
    always_ff @(posedge CLK) begin
        if(RESET) begin //reset MIE, MEPC, MTVEC
            REG[0] <= 32'b0;
            REG[2] <= 32'b0;
            REG[1] <= 32'b0;
        end
        else if(INT_TAKEN) begin
            REG[2] <= PC; //set MEPC to PC
            REG[0] <= 1'b0; //set MIE to 0
        end else if(WR_EN) begin
            REG[addr] <= WD; //set register to input
        end 
    end
endmodule
