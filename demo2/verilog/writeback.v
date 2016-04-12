module writeback(rd,rs,regdst,memtoreg,slbi,compareS,btr_cntl,aluOut,mem_out,alu_out,imm,writereg,ofl,zero,N,P,inst,ld_imm,regwritedata);


input [2:0] rd,rs;
input ofl,zero,N,P,ld_imm;
input regdst,memtoreg,slbi,compareS,btr_cntl;
input [15:0] mem_out,alu_out,imm,inst,aluOut;
output [2:0]writereg;
output [15:0]regwritedata;


wire [15:0] regwrback, sResults, slbi_aluOut, btr_out;


assign writereg = (regdst)? rd:rs;
assign regwrback = (memtoreg)?mem_out:
                     (slbi)?slbi_aluOut:
                     (compareS)? sResults:
                     btr_cntl? btr_out:
                      aluOut;
assign sResults =  (zero&(inst[15:11]==5'b11100))? 16'h0001:
                   (P&(inst[15:11]==5'b11101))? 16'h0001:
                   ((P|zero)&(inst[15:11]==5'b11110))? 16'h0001:
                   (ofl&(inst[15:11]==5'b11111))? 16'h0001:
                   16'h0000;
assign slbi_aluOut = {(aluOut[15]|imm[15]), (aluOut[14]|imm[14]),
  			(aluOut[13]|imm[13]), (aluOut[12]|imm[12]),
  			(aluOut[11]|imm[11]), (aluOut[10]|imm[10]),
  			(aluOut[9]|imm[9]), (aluOut[8]|imm[8]),
  			(aluOut[7]|imm[7]), (aluOut[6]|imm[6]),
  			(aluOut[5]|imm[5]), (aluOut[4]|imm[4]),
  			(aluOut[3]|imm[3]), (aluOut[2]|imm[2]),
  			(aluOut[1]|imm[1]), (aluOut[0]|imm[0])};

assign btr_out = {aluOut[0],aluOut[1],aluOut[2],aluOut[3],
                     aluOut[4],aluOut[5],aluOut[6],aluOut[7],
                    aluOut[8],aluOut[9],aluOut[10],aluOut[11],
                    aluOut[12],aluOut[13],aluOut[14],aluOut[15]};
                      
assign regwritedata = (ld_imm)? imm:regwrback;

endmodule
