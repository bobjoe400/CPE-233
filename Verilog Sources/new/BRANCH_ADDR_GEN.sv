`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2022 11:58:02 AM
// Design Name: 
// Module Name: BRANCH_ADDR_GEN
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


module BRANCH_ADDR_GEN(
        input logic[31:0] I, J, B, RS1, PC,
        output logic[31:0] JAL, BRANCH, JALR
    );
    //from the OTTER assembly manual:
    //jal = PC + J
    //branch = PC + B
    //jalr = rs1 + I
    //
    //No need to use an always_ff since we aren't
    //saving any values and its going to be asynchronous
    always_comb begin
        JAL = PC + J;
        BRANCH = PC + B;
        JALR = RS1 + I;
    end
endmodule
