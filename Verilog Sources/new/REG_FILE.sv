`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2022 09:38:59 AM
// Design Name: 
// Module Name: REG_FILE
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


module REG_FILE(
        input logic[4:0] RF_ADR1, RF_ADR2, RF_WA,
        input logic[31:0] RF_WD, 
        input logic RF_EN, CLK,
        output logic[31:0] RF_RS1, RF_RS2
    );
    logic[31:0] REG[0:31]; //creating our 32-bit x 32 address register
    
    //the register is asynchronus, so we use an always_comb block. 
    //I'm independently checking if either of the addresses are 0. 
    //If so, I am forcing that output to 0. If not, they just
    //output whatever is in that register address. 
    always_comb begin
        RF_RS1 = REG[RF_ADR1];
        RF_RS2 = REG[RF_ADR2];
    end
    
    //The actual register itself is only writeable with the enable
    //bit on and on the posedge of the CLK signal.
    always_ff @(posedge CLK) begin
        if(RF_EN) begin
            if(RF_WA != 32'b0) REG[RF_WA] <= RF_WD;
        end
    end
    
    //This initializes all the bits in the register to 0 
    initial begin
        for(int i=0; i< 32; i++) begin
            REG[i] = 0;
        end
    end
endmodule
