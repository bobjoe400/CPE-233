`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2022 01:29:52 PM
// Design Name: 
// Module Name: PC
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

module PC(
    input logic[31:0] PC_DIN,
    input logic PC_WRITE, PC_RST, CLK,
    output logic[31:0] PC_COUNT
    );
    always_ff @(posedge CLK) begin
        if(PC_RST) begin
            PC_COUNT <= 0;
        end else if(PC_WRITE) begin
            PC_COUNT <= PC_DIN;
        end    
    end
endmodule