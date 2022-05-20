`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2022 02:51:58 PM
// Design Name: 
// Module Name: IMMED_GEN
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


module IMMED_GEN(
    input logic[24:0] IR,
    output logic[31:0] U, I, S, J, B
    );
    //U 31:12 == 24:5
    //I 31 = 24, 30:25 = 23:18, 24:20 = 18:13
    //S 31 = 24, 30:25 = 23:18, 11:7 = 4:0
    //B 31 = 24, 7 = 0, 30:25 = 23:18, 11:8 = 4:1
    //J 31 = 24, 19:12 = 12:5, 20 = 13, 30:21 = 23:14
    always_comb begin
        U = {IR[24:5],12'b0};
        I = {{21{IR[24]}},IR[23:18], IR[17:13]};
        S = {{21{IR[24]}}, IR[23:18], IR[4:0]};
        B = {{20{IR[24]}}, IR[0], IR[23:18], IR[4:1], 1'b0};
        J = {{12{IR[24]}}, IR[12:5], IR[13], IR[23:14], 1'b0};
    end       
endmodule
