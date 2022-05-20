`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2022 12:21:30 PM
// Design Name: 
// Module Name: OTTER_MCU
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


module OTTER_MCU(
        input logic CLK, RST, INTR,
        input[31:0] IOBUS_IN,
        output IOBUS_WR,
        output[31:0] IOBUS_ADDR, IOBUS_OUT
    );
    //declaring connectors arround the architecture
    logic reset, int_taken, PCWrite, regWrite, memWE2, memRDEN1, memRDEN2, csr_WE, csr_ME, intr, alu_srcA, br_eq, br_lt, br_ltu;
    logic[1:0] alu_srcB, rf_wr_sel;
    logic[2:0] pcSource;
    logic[3:0] alu_fun;
    logic[31:0] ir, mepc, mtvec, pc, pcDin,  dout2, plus4, rd, result, uType, iType, sType, jType, bType, jalr, branch, jal, rs1, rs2, srcA, srcB, wd;
    
    //setting up outputs and the interrupt gate
    assign intr = csr_ME & INTR;
    assign IOBUS_OUT = rs2;
    assign IOBUS_ADDR = result;
    
    //Structural design follows the OTTER Architechture 
    CU_FSM FSM(.CLK(CLK), .RST(RST), .INTR(intr), .IR({ir[14:12],ir[6:0]}), .PC_WRITE(PCWrite), .REG_WRITE(regWrite), .MEM_WE2(memWE2), .MEM_RDEN1(memRDEN1), .MEM_RDEN2(memRDEN2), .RESET(reset),.CSR_WE(csr_WE), .INT_TAKEN(int_taken));
    CU_DCDR DCDR(.IR({ir[30],ir[14:12], ir[6:0]}),.INT_TAKEN(int_taken), .BR_EQ(br_eq), .BR_LT(br_lt), .BR_LTU(br_ltu), .ALU_FUN(alu_fun), .ALU_SRCA(alu_srcA), .ALU_SRCB(alu_srcB), .PC_SOURCE(pcSource), .RF_WR_SEL(rf_wr_sel));
    CSR CSR(.CLK(CLK), .RESET(reset), .INT_TAKEN(int_taken), .ADDR(ir[31:20]), .WR_EN(csr_WE), .CSR_ME(csr_ME), .CSR_MEPC(mepc), .CSR_MTVEC(mtvec), .RD(rd), .PC(pc), .WD(rs1));
    BRANCH_COND_GEN BCG(.RS1(rs1), .RS2(rs2), .BR_EQ(br_eq), .BR_LT(br_lt), .BR_LTU(br_ltu));
    BRANCH_ADDR_GEN BAG(.RS1(rs1), .I(iType), .J(jType), .B(bType), .PC(pc), .JAL(jal), .BRANCH(branch), .JALR(jalr));
    IMMED_GEN IG(.IR(ir[31:7]), .I(iType), .B(bType), .J(jType), .S(sType), .U(uType));
    PC PC(.CLK(CLK), .PC_RST(reset), .PC_WRITE(PCWrite), .PC_DIN(pcDin), .PC_COUNT(pc));
    MEM MMRY(.MEM_CLK(CLK), .MEM_ADDR2(result), .MEM_DIN2(rs2), .MEM_ADDR1(pc[15:2]), .MEM_RDEN1(memRDEN1), .MEM_RDEN2(memRDEN2), .MEM_WE2(memWE2), .MEM_SIZE(ir[13:12]), .MEM_SIGN(ir[14]), .IO_IN(IOBUS_IN), .MEM_DOUT2(dout2), .MEM_DOUT1(ir), .IO_WR(IOBUS_WR));
    REG_FILE RF(.CLK(CLK), .RF_EN(regWrite), .RF_ADR1(ir[19:15]), .RF_ADR2(ir[24:20]) , .RF_WA(ir[11:7]), .RF_RS1(rs1), .RF_RS2(rs2), .RF_WD(wd));
    ALU ALU(.A(srcA), .B(srcB), .ALU_FUN(alu_fun), .RESULT(result));
    
    //the different mux's around the architecture
    always_comb begin
        case(rf_wr_sel) //Write data mux
            0: wd = plus4;
            1: wd = rd;
            2: wd = dout2;
            3: wd = result;
            default: wd = plus4;
        endcase
        case(alu_srcA) //ALU_srcA mux
            0: srcA = rs1;
            1: srcA = uType;
            default: srcA = rs1;
        endcase
        case(alu_srcB) //ALU_srcB mux
            0: srcB = rs2;
            1: srcB = iType;
            2: srcB = sType;
            3: srcB = pc;
            default: srcB = rs2;
        endcase
        case(pcSource) //PCSource Mux
            1: pcDin = jalr;
            2: pcDin = branch;
            3: pcDin = jal;
            4: pcDin = mtvec;
            5: pcDin = mepc;
            default: pcDin = plus4;
         endcase
    end
    
    //pc+4 adder
    always @(pc) begin
        plus4 <= pc + 4;
    end
endmodule
