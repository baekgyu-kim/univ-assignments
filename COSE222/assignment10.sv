`include "alu.sv"
`include "regfile.sv"
`include "imem.sv"
`include "dmem.sv"
`include "controller.sv"

module mips(
  input logic iClk,
  input logic iReset
);

  logic [31:0] ALU_ALUResult_E;
  logic [31:0] ALU_ALUResult_M;
  logic [31:0] REG_SrcA_D;
  logic [31:0] REG_SrcA_E;
  logic [31:0] REG_SrcB_D;
  logic [31:0] REG_SrcB_E;
  logic [31:0] REG_WriteData_E;
  logic [31:0] REG_WriteData_M;
  logic [31:0] IMEM_InstF;
  logic [31:0] IMEM_InstD;
  logic [31:0] DMEM_ReadData_M;
  logic [31:0] DMEM_ReadData_W;
  logic [31:0] pc;
  logic [4:0] WriteReg;
  logic [31:0] SrcB;
  logic [31:0] Result;
  logic [15:0] SignImm_D;
  logic [15:0] SignImm_E;
  logic [4:0] Rt;
  logic [4:0] Rd;
  
  logic CTL_RegWrite;
  logic CTL_MemWrite;
  logic CTL_RegDst;
  logic CTL_ALUSrc;
  logic CTL_MemtoReg;
  logic [2:0] CTL_ALUControl;
  
  assign REG_WriteData_E = REG_SrcB_E;
  assign Rt = IMEM_InstD[20:16];
  assign Rd = IMEM_InstD[15:11];
  assign WriteReg = CTL_RegDst ? Rd : Rt;
  assign SignImm_D = {{16{IMEM_InstD[15]}}, IMEM_InstD[15:0]};
  assign SrcB_E = CTL_ALUSrc ? SignImm_E : REG_WriteData_E;
  assign Result = CTL_MemtoReg ? DMEM_ReadData_W : ALU_ALUResult_M;
  
  alu ALU(
    .iA		(REG_SrcA_E),
    .iB		(SrcB_E),
    .iF		(CTL_ALUControl),
    .oY		(ALU_ALUResult_E),
    .oZero	()
  );
  
  regfile REG(
    .iClk	(iClk),
    .iReset	(iReset),
    .iRaddr1(IMEM_InstD[25:21]),
    .iRaddr2(IMEM_InstD[20:16]),
    .iWaddr	(WriteReg),
    .iWe	(CTL_RegWrite),
    .iWdata	(Result),
    .oRdata1(REG_SrcA_D),
    .oRdata2(REG_SrcB_D)
  );
  
  imem IMEM(
    .iAddr	(pc),
    .oRdata	(IMEM_InstF)
  );
  
  dmem DMEM(
    .iClk	(iClk),
    .iReset	(iReset),
    .iWe	(CTL_MemWrite),
    .iAddr	(ALU_ALUResult_M),
    .iWdata	(REG_WriteData_M),
    .oRdata	(DMEM_ReadData_M)
  );
  
  controller CTL(
    .iOp		(IMEM_InstD[31:26]),
    .iFunc		(IMEM_InstD[5:0]),
    .oRegWrite	(CTL_RegWrite),
    .oMemWrite	(CTL_MemWrite),
    .oRegDst	(CTL_RegDst),
    .oALUSrc	(CTL_ALUSrc),
    .oMemtoReg	(CTL_MemtoReg),
    .oALUControl(CTL_ALUControl)
  );
  
  always_ff@(posedge iClk, posedge iReset)
    if(iReset)
      pc <= 0;
    else 
      pc <= pc + 4;

    always_ff@(posedge iClk, posedge iReset)
      if(iReset) begin
      	  IMEM_InstD <= 0;
        end else begin 
          IMEM_InstD <= IMEM_InstF;
          REG_SrcA_E <= REG_SrcA_D;
          REG_SrcB_E <= REG_SrcB_D;
          SignImm_E <= SignImm_D;
          ALU_ALUResult_M <= ALU_ALUResult_E;
          REG_WriteData_M <= REG_WriteData_E;
          DMEM_ReadData_W <= DMEM_ReadData_M;
        end

endmodule
