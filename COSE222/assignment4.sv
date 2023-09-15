module alu(  
  input logic [31:0] iA, iB,
  input logic [2:0] iF,
  output logic [31:0] oY,
  output logic oZero);

  logic [31:0] notiB;
  
  always_comb
    begin
      notiB <= ~iB;
    end
  
  always_comb
    case(iF)
      3'b000: oY <= iA & iB;
      3'b001: oY <= iA | iB;
      3'b010: oY <= iA + iB;
      3'b100: oY <= iA & notiB;
      3'b101: oY <= iA | notiB;
      3'b110: oY <= iA - iB;
      3'b111:
        begin
          if (iA < iB) 
            	begin
					oY <= 3'b001;
				end 
          else 
            begin
				oY <= 3'b000;
            end
        end
    endcase

  
  always_comb
    begin
    if (oY == 3'b000)
      begin
        oZero <= 3'b001;
      end
    else if (oY != 3'b000)
      begin
      	oZero <= 3'b000;
      end
    end

  
    
endmodule 