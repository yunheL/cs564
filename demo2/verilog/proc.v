/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
      
   
   /* your code here */
   
   wire pc_en;
   wire jump;
   wire [15:0] instIF, addr;
   wire [2:0] rs,rt,rd;
   wire [15:0] instID,immID,displacementID;
   wire [15:0] read1dataID,read2dataID;
   wire [15:0] read1dataEX, read2dataEX, immEX,displacementEX, pc_nx;
   wire rt_rd;
   wire [2:0] writereg, read2sel;
   wire regdst;
   wire haltID, haltEX, haltMEM, haltWB;
//   wire regwriteID, regwriteEX, regwriteMEM, regwriteWB;
//   wire regwrite;
   
   wire [15:0] immMEM, immWB;
   wire [15:0] opB;
   wire [4:0] aluop;
   wire [2:0] alu_op;
   wire slbi,invA,invB,cin,flip1,flip2;//, sh_select;
   wire [3:0]shamt;
   //wire ofl,zero,rt_rd,N,P;
   
   wire [15:0]aluOut,aluOutMEM,read2dataMEM,instEX_normal,instEX, instMEM, instWB;
   wire ofl,zero,N,P,c_out,oflMEM,zeroMEM,NMEM,PMEM;
   wire [15:0]slbi_aluOut;
   
   wire memtoreg, regwrite,ld_imm,compareS,btr,writeR7;
   //wire btr_cntl;
  
   wire [15:0] aluOutWB;
   wire oflWB,zeroWB,PWB,NWB;
   
   wire [2:0] rdEX,rsEX ,rdMEM,rsMEM,rdWB,rsWB;
   wire[15:0] regwritedata, mem_out,mem_outWB;
   wire stall;
   wire br_ctl;
   wire [15:0] instStall;
   wire [15:0] wr_instIF;
   
   //forwarding and data hazard control
   wire id_rs_v,id_rt_v,id_rd_v;
   wire ex_rd_v,mem_rd_v;
   wire[15:0] forwarded_read1dataEX,forwarded_read2dataEX,read1dataWB,read2dataWB,read1dataMEM;
   wire fow_EXID_rs,fow_EXID_rt, fow_MEMID_rs,fow_MEMID_rt;
   wire[2:0] r1_reg,r2_reg,r_wr,ex_r_wr,mem_r_wr,wb_r_wr;
   wire  stall_q;
   
   dff stal (.q(stall_q),.d(stall),.clk(clk),.rst(rst));
   //stall
   assign instStall = 16'h0800;
   assign pc_en=(stall_q&~rst)? 1'b0:1'b1;
   
   
   //Stage IF
   IF_control ifcont (.Jump(jump),.Branch(branch),.opcode(instIF[15:11]));
   
   pc prog_c (.en(pc_en),.clk(clk),.rst(rst),.jump(jump),.inst(instIF),.addr(addr),.branch(branch),.rs(read1dataID),.pc_nx(pc_nx),.ID_inst(instID),.br_ctl(br_ctl));
   memory2c inst_mem (.data_out(instIF), .data_in(16'h0000), .addr(addr), .enable(1'b1), .wr(1'b0), .createdump(), .clk(clk), .rst(rst));

     assign wr_instIF = br_ctl? 16'h0800 :
                        haltMEM? 16'h0800 :
                        instIF;

   reg16_init IFID (.read(instID),.write(wr_instIF),.wr_en(1'b1),.rst(rst),.clk(clk));
   //Stage ID
   
   ID_control idcont (.Rt_Rd(rt_rd),.Halt(haltID),.opcode(instID[15:11]));
   decoder inst_decode(.inst(instID),.rt(rt),.rs(rs),.rd(rd),.imm(immID),.displacement(displacementID));
   rf_bypass regfile (.read1data(read1dataID), .read2data(read2dataID), .err(err), .clk(clk), .rst(rst), .read1regsel(r1_reg), .read2regsel(r2_reg), .writeregsel(wb_r_wr), .writedata(regwritedata), .write(regwrite));//TODO write
   reg_control regctl(
    .rs_v(id_rs_v),.rt_v(id_rt_v),.rd_v(id_rd_v),.r1_reg(r1_reg),.r2_reg(r2_reg),.
    r_wr(r_wr),.inst(instID));
  
   
   assign read2sel = (rt_rd)?rd:rt;
   
   
   reg16 rdex(.read(rdEX),.write(rd),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 rsex(.read(rsEX),.write(rs),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 rwrex(.read(ex_r_wr),.write(r_wr),.wr_en(1'b1),.rst(rst),.clk(clk));
   
   reg16 instex (.read(instEX_normal),.write(instID),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 read1dataex(.read(read1dataEX),.write(read1dataID),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 read2dataex(.read(read2dataEX),.write(read2dataID),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 immex (.read(immEX),.write(immID),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 disex (.read(displacementEX),.write(displacementID),.wr_en(1'b1),.rst(rst),.clk(clk));
   dff rdexv(.q(ex_rd_v),.d(id_rd_v),.clk(clk),.rst(rst));
   dff haltex(.q(haltEX),.d(haltID),.clk(clk),.rst(rst));
//   dff regwrid(.q(regwriteEX),.d(regwriteID),.clk(clk),.rst(rst));

   //Stage EX
   assign instEX = (stall_q)?instStall:instEX_normal;
   
   assign forwarded_read1dataEX = (fow_EXID_rs)?read1dataMEM:
                                (fow_MEMID_rs)?read1dataWB:
                                read1dataEX;
   assign forwarded_read2dataEX = (fow_EXID_rt)?read2dataMEM:
                                (fow_MEMID_rt)?read2dataWB:
                                read2dataEX;
                                
   EX_control excont (.ALUOp(aluop),.ALUSrc(alusrc),.opcode(instEX[15:11]));
   
   alu ALU(.A(forwarded_read1dataEX), .B(opB), .Cin(cin), .Op(alu_op), .invA(invA), .invB(invB), .sign(1'b1), .Out(aluOut), .Ofl(ofl), .Z(zero),.N(N),.P(P),.c_out(c_out));
   
   alu_control a_c(
  .alu_op(alu_op), .inv_a(invA), .inv_b(invB), .cin(cin), .shamt(shamt),.flip_1(flip1),
  .flip_2(flip2), .shift(shift),.SLBI(slbi), .opcode(instEX[15:11]), .func(instEX[1:0]),.immd(instEX[3:0]));
     
      assign opB = (alusrc)? forwarded_read2dataEX:
                (shift) ? {{12{1'b0}},shamt}:
                immEX; 
      
                
   //regs at EX/MEM stage  
   reg16 rdmem(.read(rdMEM),.write(rdEX),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 rsmem(.read(rsMEM),.write(rsEX),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 rwrmem(.read(mem_r_wr),.write(ex_r_wr),.wr_en(1'b1),.rst(rst),.clk(clk));
             
   reg16 instM(.read(instMEM),.write(instEX),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 aluOutM(.read(aluOutMEM),.write(aluOut),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 read1dataM(.read(read1dataMEM),.write(forwarded_read1dataEX),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 read2dataM(.read(read2dataMEM),.write(opB),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 immM (.read(immMEM),.write(immEX),.wr_en(1'b1),.rst(rst),.clk(clk));
   dff oflM(.q(oflMEM),.d(ofl),.clk(clk),.rst(rst));
   dff zeroM(.q(zeroMEM),.d(zero),.clk(clk),.rst(rst));
   dff NM(.q(NMEM),.d(N),.clk(clk),.rst(rst));
   dff PM(.q(PMEM),.d(P),.clk(clk),.rst(rst));
   dff rdmemv(.q(mem_rd_v),.d(ex_rd_v),.clk(clk),.rst(rst));
   dff haltmem(.q(haltMEM),.d(haltEX),.clk(clk),.rst(rst));
//   dff regwrex(.q(regwriteMEM),.d(regwriteEX),.clk(clk),.rst(rst));



   //stage MEM
   MEM_control memcont (.MemRead(memread),.MemWrite(memwrite),.opcode(instMEM[15:11]));
   
   memory2c data_mem(.data_out(mem_out), .data_in(read2dataMEM), .addr(aluOutMEM), .enable(memread|memwrite), .wr(memwrite), .createdump(), .clk(clk), .rst(rst)); 
   
   
   reg16 rdwb(.read(rdWB),.write(rdMEM),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 rswb(.read(rsWB),.write(rsMEM),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 rwrwb(.read(wb_r_wr),.write(mem_r_wr),.wr_en(1'b1),.rst(rst),.clk(clk));
   
   reg16 instwb(.read(instWB),.write(instMEM),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 aluOutwb(.read(aluOutWB),.write(aluOutMEM),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 memoutwb(.read(mem_outWB),.write(mem_out),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 immwb (.read(immWB),.write(immMEM),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 read1datawb(.read(read1dataWB),.write(read1dataMEM),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 read2datawb(.read(read2dataWB),.write(read2dataMEM),.wr_en(1'b1),.rst(rst),.clk(clk));
   dff oflwb(.q(oflWB),.d(oflMEM),.clk(clk),.rst(rst));
   dff zerowb(.q(zeroWB),.d(zeroMEM),.clk(clk),.rst(rst));
   dff Nwb(.q(NWB),.d(NMEM),.clk(clk),.rst(rst));
   dff Pwb(.q(PWB),.d(PMEM),.clk(clk),.rst(rst));
   dff haltwb(.q(haltWB),.d(haltMEM),.clk(clk),.rst(rst));
//   dff regwrmem(.q(regwriteWB),.d(regwriteMEM),.clk(clk),.rst(rst));


  //Stage WriteBack
   WB_control wbcntl(.MemtoReg(memtoreg),.RegWrite(regwrite),.ld_imm(ld_imm),.compareS(compareS),.btr(btr),.writeR7(writeR7),.opcode(instWB[15:11]),.RegDst(regdst));

   


    writeback wback (.rd(rdWB),.rs(rsWB),.regdst(regdst),.memtoreg(memtoreg),.slbi(slbi),.compareS(compareS),.btr_cntl(btr),.aluOut(aluOutWB),.mem_out(mem_out),.alu_out(aluOutWB),.imm(immWB),.writereg(writereg),.ofl(oflWB),.zero(zeroWB),.N(NWB),.P(PWB),.inst(instWB),.ld_imm(ld_imm),.regwritedata(regwritedata));
   
   //hazard
   Harzard HDU (.ID_rs(r1_reg), .ID_rt(r2_reg), .EX_rd(ex_r_wr),.MEM_rd(mem_r_wr),.ID_rs_v(id_rs_v), .ID_rt_v(id_rt_v), .EX_rd_v(ex_rd_v),.MEM_rd_v(mem_rd_v),.EX_inst(instEX),.fow_EXID_rs(fow_EXID_rs),.fow_EXID_rt(fow_EXID_rt),. fow_MEMID_rs(fow_MEMID_rs),.fow_MEMID_rt(fow_MEMID_rt),.stall(stall),.rst(rst),.clk(clk));
   
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
