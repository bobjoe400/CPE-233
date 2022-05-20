`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2022 12:20:54 PM
// Design Name: 
// Module Name: CU_FSM
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


module CU_FSM(
        input logic RST, INTR, CLK,
        input logic[9:0] IR,
        output logic PC_WRITE, REG_WRITE, MEM_WE2, MEM_RDEN1, MEM_RDEN2, RESET, CSR_WE, INT_TAKEN
    );
    
    typedef enum{ST_INIT, ST_FETCH, ST_EXEC, ST_WTBK, ST_INTR} state;
    
    state NS, PS;
    logic ld;
    //reset circuit 
    always_ff @(posedge CLK) begin
        if(RST == 1) PS <= ST_INIT;
        else PS <= NS;
    end

    always_comb begin
        ld = 0;
        PC_WRITE = 0;
        REG_WRITE = 0;
        MEM_WE2 = 0;
        MEM_RDEN1 = 0;
        MEM_RDEN2 = 0;
        RESET = 0;
        CSR_WE = 0;
        INT_TAKEN = 0;
        case(PS)
            ST_INIT: begin //init state
                RESET = 1'b1;
                NS = ST_FETCH;
            end
            ST_FETCH: begin //grab new instruction
                MEM_RDEN1 = 1'b1;
                NS= ST_EXEC;
            end
            ST_EXEC: begin //for all instructions, this will be the general rule, in the cases
                           //are the exceptions
                NS = ST_FETCH;
                PC_WRITE = 1'b1;
                REG_WRITE = 1'b1;
                case(IR[6:0]) //exceptions to the above rule
                    7'b1100011: //branch instructions
                        REG_WRITE = 1'b0;
                    7'b0000011: begin //load instructions
                        NS = ST_WTBK;
                        MEM_RDEN2 = 1'b1; 
                        PC_WRITE= 1'b0;
                        REG_WRITE = 1'b0;
                    end
                    7'b0100011: begin //store instructions
                        MEM_WE2 = 1'b1;
                        REG_WRITE = 1'b0;
                    end
                    7'b1110011: begin //csr instructions (csrrw mret)
                        if(IR[7]) CSR_WE = 1'b1; //csrrw
                        else REG_WRITE = 1'b0; //mret
                    end
                endcase //checking for intterupt state when not loading
                if(NS != ST_WTBK & INTR) NS = ST_INTR;
            end
            ST_WTBK: begin //writeback state for loading
                PC_WRITE = 1'b1;
                REG_WRITE = 1'b1;
                NS = ST_FETCH;
                if(INTR) NS = ST_INTR; //check for interrupt when loading
            end
            ST_INTR: begin //interrupt state
                NS = ST_FETCH;
                INT_TAKEN = 1'b1;
                PC_WRITE = 1'b1;
            end
            default: NS = ST_INIT;
        endcase
    end
endmodule
