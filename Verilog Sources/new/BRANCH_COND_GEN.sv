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


module BRANCH_COND_GEN(
        input logic[31:0] RS1, RS2,
        output logic BR_EQ, BR_LT, BR_LTU
    );
    
    //We have our 3 operations need, using combinational logic due 
    //to this being asynchronous. Set all bits to 0, then go through
    //the if statements. 
    always_comb begin
        BR_EQ = 1'b0;
        BR_LT = 1'b0;
        BR_LTU = 1'b0;
        if(RS1 == RS2) BR_EQ = 1'b1;
        if($signed(RS1) < $signed(RS2)) BR_LT = 1'b1;
        if(RS1 < RS2) BR_LTU = 1'b1;
    end
endmodule