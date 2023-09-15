`include "alu.sv"
`include "regfile.sv"
`include "imem.sv"
`include "dmem.sv"

module datapath(
  input logic iClk,
  input logic iReset,
  input logic iRegWrite,
  input logic iMemWrite,
  input logic [2:0] iALUControl
);
  logic [31:0] iAddr;
  logic [31:0] oRdata;
  
  imem instMemory(
    .iAddr	(iAddr), 
    .oRdata	(oRdata)
  );
  
  logic [31:0] extended; 
  logic [15:0] notExtended;
  assign notExtended = oRdata[15:0];
  always_comb
    begin 
      extended <= $signed(notExtended);
    end
  
  
  logic [4:0] iRaddr1, iRaddr2, iWaddr;
  logic [31:0] oRdata1, oRdata2;
  
  assign iRaddr1 = oRdata[25:21];
  assign iRaddr2 = oRdata[20:16];
  assign iWaddr = oRdata[15:11];
  


  regfile registerFile(
    .iClk	(iClk),
    .iReset (iReset),
    .iRaddr1	(iRaddr1),
    .iRaddr2	(iRaddr2),
    .iWaddr		(iWaddr),
    .iWe	(iRegWrite),
    .oRdata1	(oRdata1),
    .oRdata2	(oRdata2)
  );
  
 


  logic [31:0] ALUResult;
  logic Zero;

  alu myAlu(
    .iA	(oRdata1),
    .iB	(extended),
    .iF	(ALUControl),
    .oY	(ALUResult),
    .oZero	(Zero)
  );
  
  
  logic [31:0] readData;
  
  dmem dataMemory(
    .iClk	(iClk),
    .iWe	(iMemWrite),
    .iAddr	(ALUResult),
    .oRdata	(readData)
  );
  
  
  assign iAddr = iAddr + 3'b100;
  
  
  
endmodule
