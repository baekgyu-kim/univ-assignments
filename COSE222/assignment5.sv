//iClk (1 bit): clock (rising edge)
//iReset (1 bit): reset signal

//iRaddr1 (5 bits): 1번 read port의 레지스터 넘버
//oRdata1 (32 bits): 1번 read port에서 나온 output

//iRaddr2 (5 bits): 2번 read port의 레지스터 넘버
//oRdata2 (32 bits): 2번 read port에서 나온 output

//iWaddr (5 bits): write port의 레지스터 넘버
//iWdata (32 bits): write port로 들어가는 input data

//iWe (1 bit): write enable signal


module regfile(input logic iClk, iReset, iWe,
               input logic [4:0] iRaddr1 , iRaddr2, iWaddr,
               input logic [31:0] iWdata,
               output logic [31:0] oRdata1, oRdata2
              );
  
  logic [31:0] regs[31:0];
  
  always_ff@(posedge iClk)
    begin
      regs[0] <= 0;
    	if (iReset) 
          begin
            regs[1] <= 0;
            regs[2] <= 0;
            regs[3] <= 0;
            regs[4] <= 0;
            regs[5] <= 0;
            regs[6] <= 0;
            regs[7] <= 0;
            regs[8] <= 0;
            regs[9] <= 0;
            regs[10] <= 0;
            regs[11] <= 0;
            regs[12] <= 0;
            regs[13] <= 0;
            regs[14] <= 0;
            regs[15] <= 0;
            regs[16] <= 0;
            regs[17] <= 0;
            regs[18] <= 0;
            regs[19] <= 0;
            regs[20] <= 0;
            regs[21] <= 0;
            regs[22] <= 0;
            regs[23] <= 0;
            regs[24] <= 0;
            regs[25] <= 0;
            regs[26] <= 0;
            regs[27] <= 0;
            regs[28] <= 0;
            regs[29] <= 0;
            regs[30] <= 0;
            regs[31] <= 0;
          end
      else 
        begin
          if(iWe) 
            begin
              regs[iWaddr] <= iWdata;
            end
          else
            begin
              oRdata1 <= regs[iRaddr1 + 1];
              oRdata2 <= regs[iRaddr2 + 1];
            end
        end
    end
  
  
endmodule