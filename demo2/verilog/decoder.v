module decoder(inst,rt,rs,rd,imm,displacement);

  input[15:0] inst;
  
  output reg [2:0] rt,rs,rd;
  output reg [15:0] imm;
  output reg [15:0] displacement;

  always @* begin
      rt= 3'h0;
      rs= 3'h0;
      rd= 3'h0;

      imm = 16'h0000;
    displacement = 16'h0000;
    case (inst[15:13])
    //I format
    3'b010: 
    begin
      rs = inst[10:8];
      rd = inst[7:5];
      rt = 3'h0;


      case (inst[12])
      1'b0:
        imm = {{11{inst[4]}},inst[4:0]};
      1'b1:
        imm = {{11{1'b0}},inst[4:0]};
      endcase
    end
    
    3'b101:
    begin
      rs = inst[10:8];
      rd = inst[7:5];
      rt = 3'h0;


      imm = {{11{inst[4]}},inst[4:0]};
    end
    
    3'b100:
    begin
      case (inst[12:11])
      2'b10: //SLBI
      begin
        rs = inst[10:8];
        imm = {{8{1'b0}},inst[7:0]};
        rd = 3'h0;
        rt = 3'h0;


      end
      default:
      begin
        rs = inst[10:8];
        rd = inst [7:5];
        rt = 3'h0;


       imm = {{11{inst[4]}},inst[4:0]};
      end
      endcase
    end

    //R format
    3'b110:
    begin
      case (inst[12:11])
      2'b00:
      begin
        rs = inst[10:8];
        imm = {{8{inst[7]}},inst[7:0]};
        rd = 3'h0;
        rt = 3'h0;


      end
      2'b01:
      begin
        rs = inst[10:8];
        rd = inst[4:2];
        imm = 16'h0000;
        rt = 3'h0;


      end
      default:
      begin
        rd = inst[4:2];
        rs = inst[10:8];
        rt = inst[7:5];
        imm = 16'h0000;


      end
      endcase
    end
    
    3'b111:
    begin
      rd = inst[4:2];
      rs = inst[10:8];
      rt = inst[7:5];
      imm = 16'h0000;


    end
    
    //Br immediate
    3'b011:
    begin
      rs = inst[10:8];
      imm = {{8{inst[7]}},inst[7:0]};
      rd = 3'h0;
      rt = 3'h0;


    end
   
    //JMP
    3'b001:
    begin
      case (inst[12:11])
      2'b00:begin
        displacement = {{5{inst[11]}},inst[10:0]};
        imm = 16'h0000;
        rs = 3'h0;
        rd = 3'h0;
        rt = 3'h0;

      end
 
      2'b01:begin
        imm = {{8{inst[7]}},inst[7:0]};
        rs = inst[10:8];
        rd = 3'h0;
        rt = 3'h0;
        imm = 16'h0000;


      end
   
      2'b10:begin
        displacement = {{5{inst[11]}},inst[10:0]};
        imm = 16'h0000;
        rs = 3'h0;
        rd = 3'b111;
        rt = 3'h0;


      end
 
      2'b11:begin
        imm = {{8{inst[7]}},inst[7:0]};
        rs = inst[10:8];
        rd = 3'b111;
        rt = 3'h0;
        imm = 16'h0000;


      end
      endcase
    end
    endcase
  end
endmodule
    

