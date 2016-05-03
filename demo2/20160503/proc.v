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
   wire jump_IF;
   wire jump_ID, jump_EX, wr_jump_ID, wr_jump_IF;
   wire [15:0] instIF, instIF_normal, addr;
   wire [2:0] rs,rt,rd;
   wire [15:0] instID,immID,displacementID, read_instID;
   wire [15:0] read1dataID,read2dataID;
   wire [15:0] read1dataEX, read2dataEX, immEX,displacementEX, pc_nx;
   wire rt_rd;
   wire [2:0] writereg, writereg_m, read2sel;
   wire regdst;
   wire haltID, haltEX, haltMEM, haltWB;
//   wire regwriteID, regwriteEX, regwriteMEM, regwriteWB;
//   wire regwrite;
   
   wire [15:0] immMEM, immWB;
   wire [15:0] opB;
   wire [4:0] aluop;
   wire [2:0] alu_op;
   wire slbi_EX, slbi_WB, slbi_MEM, invA,invB,cin,flip1,flip2;//, sh_select;
   wire [3:0]shamt;
   //wire ofl,zero,rt_rd,N,P;
   
   wire [15:0]aluOut,aluOutMEM,read2dataMEM,instEX_normal,instEX,read_instEX, instMEM, instWB;
   wire ofl,zero,N,P,c_out, c_outMEM, c_outWB,oflMEM,zeroMEM,NMEM,PMEM;
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

   //flush
   wire [15:0] wr_instIF, wr_instID, wr_read1dataID, wr_read2dataID;
   wire [2:0] wr_rs, wr_r_wr, wr_rd;
   wire wr_haltID;
   wire [15:0] wr_immID, wr_displacementID, wr_pc_inc_two_ID,wr_nx_pcID, wr_aluOut; 
   wire wr_id_rd_v, wr_for_EXID_rs_ID, wr_for_MEMID_rs_ID, wr_for_EXID_rt_ID, wr_for_MEMID_rt_ID;
   wire wr_jmp_r_ID, wr_branch_id;

   wire wr_branch_if;

   //ex_select
   wire regdst_ex, memtoreg_ex, compareS_ex, btr_ex, ld_imm_ex, writeR7_ex;

   //mem_select
   wire [15:0] regwritedata_m;
   wire regdst_m, memtoreg_m, compareS_m, btr_m, ld_imm_m, writeR7_m;

   //R7
   wire [15:0] nx_pcID, nx_pcEX, nx_pcMEM, nx_pcWB; 
   wire [15:0] pc_inc_two, pc_inc_two_ID, pc_inc_two_EX, pc_inc_two_MEM, pc_inc_two_WB;

   //jmp_r
   wire jmp_r_IF;
   wire writeR7_EX;
   wire jmp_r_ID;
   wire jmp_r_EX;

   //branch
   wire compareS_EX;
   wire branch_if;
   wire branch_id, branch_ex;

   //forwarding and data hazard control
   wire id_rs_v,id_rt_v,id_rd_v;
   wire ex_rd_v,mem_rd_v;
   wire[15:0] forwarded_read1dataEX,forwarded_read2dataEX,read1dataWB,read2dataWB,read1dataMEM;
   wire fow_EXID_rs_ID,fow_EXID_rt_ID, fow_MEMID_rs_ID,fow_MEMID_rt_ID;
   wire fow_EXID_rs_EX,fow_EXID_rt_EX, fow_MEMID_rs_EX,fow_MEMID_rt_EX;
   wire[2:0] r1_reg,r2_reg,r_wr,ex_r_wr,mem_r_wr,wb_r_wr;
   wire  stall_q;

   wire[15:0] aluOEX;

   wire[15:0] forwarded_read2dataMEM;
   
   dff stal (.q(stall_q),.d(stall),.clk(clk),.rst(rst));
   //stall
   assign instStall = 16'h0800;
   assign pc_en=( (stall&~rst) | jump_IF | (jump_ID & (~br_ctl)) )? 1'b0:1'b1;
   
   
   //Stage IF
   assign instIF = (jump_ID | jump_EX) ? instStall:instIF_normal; //when jump, insert two NOPs
   
   IF_control ifcont (.Jump(jump_IF),.Branch(branch_if), .jmp_r(jmp_r_IF), .opcode(instIF[15:11]));
   
   pc prog_c (.branch_if(branch_if),.pc_inc_two(pc_inc_two),.jmp_r(jmp_r),.en(pc_en),.clk(clk),.rst(rst),.jump(jump_EX),.inst(instIF),.addr(addr),.branch(branch_ex),.rs(forwarded_read1dataEX),.pc_nx(pc_nx),.EX_inst(instEX),.br_ctl(br_ctl));
   memory2c inst_mem (.data_out(instIF_normal), .data_in(16'h0000), .addr(addr), .enable(1'b1), .wr(1'b0), .createdump(), .clk(clk), .rst(rst));

   //flush IF
   assign wr_instIF = br_ctl? 16'h0800 :
                      haltMEM? 16'h0800 :
                      instIF;

  assign wr_jump_IF = br_ctl? 3'h0 :
                      haltMEM? 3'h0:
                      jump_IF;

  assign wr_branch_if = br_ctl? 3'h0 :
                        haltMEM? 3'h0:
                        branch_if;

   //IF/ID registers
   reg16_init IFID (.read(instID),.write(wr_instIF),.wr_en(~stall),.rst(rst),.clk(clk));
   reg16 nx_pcid(.read(nx_pcID),.write(pc_nx),.wr_en(~stall),.rst(rst),.clk(clk));
   reg16 pc_inc_twoid(.read(pc_inc_two_ID),.write(pc_inc_two),.wr_en(~stall),.rst(rst),.clk(clk));
   reg1 branchid(.q(branch_id),.d(wr_branch_if),.clk(clk),.rst(rst),.en(~stall));
   reg1 jumpid(.q(jump_ID),.d(wr_jump_IF),.clk(clk),.rst(rst),.en(~stall));
 
   //Stage ID   
   ID_control idcont (.Rt_Rd(rt_rd),.Halt(haltID), .jmp_r(jmp_r_ID), .opcode(read_instID[15:11]));
   decoder inst_decode(.inst(read_instID),.rt(rt),.rs(rs),.rd(rd),.imm(immID),.displacement(displacementID));
   rf_bypass regfile (.read1data(read1dataID), .read2data(read2dataID), .err(err), .clk(clk), .rst(rst), .read1regsel(r1_reg), .read2regsel(r2_reg), .writeregsel(wb_r_wr), .writedata(regwritedata), .write(regwrite));//TODO write
   reg_control regctl(
    .rs_v(id_rs_v),.rt_v(id_rt_v),.rd_v(id_rd_v),.r1_reg(r1_reg),.r2_reg(r2_reg),.
    r_wr(r_wr),.inst(read_instID));

   //stall ID
   assign read_instID = instID;
  
   //flush ID
  assign wr_rs = br_ctl? 3'h0 :
                 haltMEM? 3'h0:
                 stall? 3'h0:
                 rs;

  assign wr_r_wr = br_ctl? 3'h0 :
                 haltMEM? 3'h0:
                 stall? 3'h0:
                 r_wr;

  assign wr_rd = br_ctl? 3'h0 :
                 haltMEM? 3'h0:
                 stall? 3'h0:
                 rd;

  assign wr_instID = br_ctl? 16'h0800 :
                     haltMEM? 16'h0800 :
                     stall ? 16'h0800:
                     instID;

  assign wr_read1dataID = br_ctl? 16'h0000 :
                          haltMEM? 16'h0000 :
                          stall ? 16'h0000:
                          read1dataID;

  assign wr_read2dataID = br_ctl? 16'h0000 :
                          haltMEM? 16'h0000 :
                          stall ? 16'h0000:
                          read2dataID;

  assign wr_immID = br_ctl? 16'h0000 :
                          haltMEM? 16'h0000 :
                          stall ? 16'h0000:
                          immID;

  assign wr_displacementID = br_ctl? 16'h0000 :
                          haltMEM? 16'h0000 :
                          stall ? 16'h0000:
                          displacementID;

  assign wr_id_rd_v = br_ctl? 1'b0 :
                   haltMEM? 1'b0:
                   stall? 1'b0:
                   id_rd_v;

  assign wr_id_rd_v = br_ctl? 1'b0 :
                   haltMEM? 1'b0:
                   stall? 1'b0:
                   id_rd_v;

  assign wr_haltID = br_ctl? 1'b0 :
                   haltMEM? 1'b0:
                   stall? 1'b0:
                   haltID;

  assign wr_pc_inc_two_ID = br_ctl? 16'h0000 :
                          haltMEM? 16'h0000 :
                          stall ? 16'h0000:
                          pc_inc_two_ID; 

  assign wr_fow_EXID_rs_ID = br_ctl? 1'b0 :
                   haltMEM? 1'b0:
                   stall? 1'b0:
                   fow_EXID_rs_ID;

  assign wr_fow_MEMID_rs_ID = br_ctl? 1'b0 :
                   haltMEM? 1'b0:
                   stall? 1'b0:
                   fow_MEMID_rs_ID;

  assign wr_fow_EXID_rt_ID = br_ctl? 1'b0 :
                   haltMEM? 1'b0:
                   stall? 1'b0:
                   fow_EXID_rt_ID;

  assign wr_fow_MEMID_rt_ID = br_ctl? 1'b0 :
                   haltMEM? 1'b0:
                   stall? 1'b0:
                   fow_MEMID_rt_ID;

  assign wr_jmp_r_ID = br_ctl? 1'b0 :
                   haltMEM? 1'b0:
                   stall? 1'b0:
                   jmp_r_ID;

  assign wr_nx_pcID = br_ctl? 16'h0000 :
                          haltMEM? 16'h0000 :
                          stall ? 16'h0000:
                          nx_pcID;

  assign wr_aluOut = br_ctl? 16'h0000 :
                          haltMEM? 16'h0000 :
                          stall ? 16'h0000:
                          aluOut;

  assign wr_branch_id = br_ctl? 1'b0 :
                   haltMEM? 1'b0:
                   stall? 1'b0:
                   branch_id;

  assign wr_jump_ID = br_ctl? 1'b0 :
                 haltMEM? 1'b0:
                 stall? 1'b0:
                 jump_ID;


   
   assign read2sel = (rt_rd)?rd:rt;
   
   //ID/EX registers
   reg3 rdex(.read(rdEX),.write(wr_rd),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg3 rsex(.read(rsEX),.write(wr_rs),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg3 rwrex(.read(ex_r_wr),.write(wr_r_wr),.wr_en(1'b1),.rst(rst),.clk(clk));
   
   reg16 instex (.read(instEX_normal),.write(wr_instID),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 read1dataex(.read(read1dataEX),.write(wr_read1dataID),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 read2dataex(.read(read2dataEX),.write(wr_read2dataID),.wr_en(1'b1),.rst(rst),.clk(clk));

   reg16 immex (.read(immEX),.write(wr_immID),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 disex (.read(displacementEX),.write(wr_displacementID),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg1 rdexv(.q(ex_rd_v),.d(wr_id_rd_v),.clk(clk),.rst(rst),.en(1'b1));
   reg1 haltex(.q(haltEX),.d(wr_haltID),.clk(clk),.rst(rst),.en(1'b1));
   reg16 pc_inc_twoex(.read(pc_inc_two_EX),.write(wr_pc_inc_two_ID),.wr_en(1'b1),.rst(rst),.clk(clk));

   reg1 ex_rs(.q(fow_EXID_rs_EX),.d(wr_fow_EXID_rs_ID),.clk(clk),.rst(rst),.en(1'b1));
   reg1 mem_rs(.q(fow_MEMID_rs_EX),.d(wr_fow_MEMID_rs_ID),.clk(clk),.rst(rst),.en(1'b1));
   reg1 ex_rt(.q(fow_EXID_rt_EX),.d(wr_fow_EXID_rt_ID),.clk(clk),.rst(rst),.en(1'b1));
   reg1 mem_rt(.q(fow_MEMID_rt_EX),.d(wr_fow_MEMID_rt_ID),.clk(clk),.rst(rst),.en(1'b1));

   reg1 jmp_rex(.q(jmp_r_EX),.d(wr_jmp_r_ID),.clk(clk),.rst(rst),.en(1'b1));
 
   reg16 nx_pcex(.read(nx_pcEX),.write(wr_nx_pcID),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 aluO_ex(.read(aluOEX),.write(wr_aluOut),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg1 branchex(.q(branch_ex),.d(wr_branch_id),.clk(clk),.rst(rst),.en(1'b1));
   reg1 jumpex(.q(jump_EX),.d(wr_jump_ID),.clk(clk),.rst(rst),.en(1'b1));

//   reg1 regwrid(.q(regwriteEX),.d(regwriteID),.clk(clk),.rst(rst));
   //stall EX


   //Stage EX
//assign read_instEx = (stall_q)?instStall:instEX_normal;
   assign instEX = instEX_normal;
   
   assign forwarded_read1dataEX = (fow_EXID_rs_EX)? regwritedata_m:
                                (fow_MEMID_rs_EX)?  regwritedata:
                                 //(jmp_r_EX & ~(instEX[10] & instEX[9] & instEX[8]))? regwritedata_m :
                                 //(writeR7_EX) ?  pc_inc_two_EX :
                                read1dataEX;

   assign forwarded_read2dataEX = (fow_EXID_rt_EX)? regwritedata_m: //read2dataMEM:
                                (fow_MEMID_rt_EX)?  regwritedata:  //read2dataWB:
                                read2dataEX;
                                
   EX_control excont (.ALUOp(aluop),.ALUSrc(alusrc), .wr_r7(writeR7_EX), .compareS_EX(compareS_EX), .opcode(instEX[15:11]));

/*
   WB_control ex_wbcntl(.MemtoReg(memtoreg_ex),.RegWrite(regwrite_ex),.ld_imm(ld_imm_ex),.compareS(compareS_ex),.btr(btr_ex),.writeR7(writeR7_ex),.opcode(instEX[15:11]),.RegDst(regdst_ex));

*/
   
   alu ALU(.A(forwarded_read1dataEX), .B(opB), .Cin(cin), .Op(alu_op), .invA(invA), .invB(invB), .sign(1'b1), .Out(aluOut), .Ofl(ofl), .Z(zero),.N(N),.P(P),.c_out(c_out));

/*
  assign slbi_aluOut = {(aluOut[15]|imm[15]), (aluOut[14]|imm[14]),
                        (aluOut[13]|imm[13]), (aluOut[12]|imm[12]),
                        (aluOut[11]|imm[11]), (aluOut[10]|imm[10]),
                        (aluOut[9]|imm[9]), (aluOut[8]|imm[8]),
                        (aluOut[7]|imm[7]), (aluOut[6]|imm[6]),
                        (aluOut[5]|imm[5]), (aluOut[4]|imm[4]),
                        (aluOut[3]|imm[3]), (aluOut[2]|imm[2]),
                        (aluOut[1]|imm[1]), (aluOut[0]|imm[0])};
*/
   
   alu_control a_c(
  .alu_op(alu_op), .inv_a(invA), .inv_b(invB), .cin(cin), .shamt(shamt),.flip_1(flip1),
  .flip_2(flip2), .shift(shift),.SLBI(slbi_EX), .opcode(instEX[15:11]), .func(instEX[1:0]),.immd(instEX[3:0]));
     
      assign opB = (alusrc)? forwarded_read2dataEX:
                (shift) ? {{12{1'b0}},shamt}:
                immEX; 
      
                
   //EX/MEM registers
   reg3 rdmem(.read(rdMEM),.write(rdEX),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg3 rsmem(.read(rsMEM),.write(rsEX),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg3 rwrmem(.read(mem_r_wr),.write(ex_r_wr),.wr_en(1'b1),.rst(rst),.clk(clk));
             
   reg16 instM(.read(instMEM),.write(instEX),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 aluOutM(.read(aluOutMEM),.write(aluOut),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 read1dataM(.read(read1dataMEM),.write(forwarded_read1dataEX),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 read2dataM(.read(read2dataMEM),.write(opB),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 immM (.read(immMEM),.write(immEX),.wr_en(1'b1),.rst(rst),.clk(clk));

   reg16 reg_forwarded_read2dataMEM(.read(forwarded_read2dataMEM),.write(forwarded_read2dataEX),.wr_en(1'b1),.rst(rst),.clk(clk));

   reg16 pc_inc_twomem(.read(pc_inc_two_MEM),.write(pc_inc_two_EX),.wr_en(1'b1),.rst(rst),.clk(clk));

   reg1 oflM(.q(oflMEM),.d(ofl),.clk(clk),.rst(rst),.en(1'b1));
   reg1 c_outM(.q(c_outMEM),.d(c_out),.clk(clk),.rst(rst),.en(1'b1));
   reg1 zeroM(.q(zeroMEM),.d(zero),.clk(clk),.rst(rst),.en(1'b1));
   reg1 NM(.q(NMEM),.d(N),.clk(clk),.rst(rst),.en(1'b1));
   reg1 PM(.q(PMEM),.d(P),.clk(clk),.rst(rst),.en(1'b1));
   reg1 rdmemv(.q(mem_rd_v),.d(ex_rd_v),.clk(clk),.rst(rst),.en(1'b1));
   reg1 haltmem(.q(haltMEM),.d(haltEX),.clk(clk),.rst(rst),.en(1'b1));

   reg1 slbimem(.q(slbi_MEM),.d(slbi_EX),.clk(clk),.rst(rst),.en(1'b1));
//   reg1 regwrex(.q(regwriteMEM),.d(regwriteEX),.clk(clk),.rst(rst));

   reg16 nx_pcmem(.read(nx_pcMEM),.write(nx_pcEX),.wr_en(1'b1),.rst(rst),.clk(clk));


   //stage MEM
   MEM_control memcont (.MemRead(memread),.MemWrite(memwrite),.opcode(instMEM[15:11]));
   WB_control mem_wbcntl(.MemtoReg(memtoreg_m),.RegWrite(regwrite_m),.ld_imm(ld_imm_m),.compareS(compareS_m),.btr(btr_m),.writeR7(writeR7_m),.opcode(instMEM[15:11]),.RegDst(regdst_m));

 
   memory2c data_mem(.data_out(mem_out), .data_in(forwarded_read2dataMEM), .addr(aluOutMEM), .enable(memread|memwrite), .wr(memwrite), .createdump(), .clk(clk), .rst(rst)); 

   mf_data mdata(.rd(rdMEM),.rs(rsMEM),.regdst(regdst_m),.memtoreg(memtoreg_m),.slbi(slbi_MEM),.compareS(compareS_m),.btr_cntl(btr_m),.aluOut(aluOutMEM),.mem_out(mem_out),.alu_out(aluOutMEM),.imm(immMEM),.writereg(writereg_m),.ofl(oflMEM),.zero(zeroMEM),.N(NMEM),.P(PMEM),.cout(c_outMEM),.inst(instMEM),.ld_imm(ld_imm_m),.regwritedata(regwritedata_m));
 
   
   //MEM/WB registers
   reg3 rdwb(.read(rdWB),.write(rdMEM),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg3 rswb(.read(rsWB),.write(rsMEM),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg3 rwrwb(.read(wb_r_wr),.write(mem_r_wr),.wr_en(1'b1),.rst(rst),.clk(clk));
   
   reg16 instwb(.read(instWB),.write(instMEM),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 aluOutwb(.read(aluOutWB),.write(aluOutMEM),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 memoutwb(.read(mem_outWB),.write(mem_out),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 immwb (.read(immWB),.write(immMEM),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 read1datawb(.read(read1dataWB),.write(read1dataMEM),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 read2datawb(.read(read2dataWB),.write(read2dataMEM),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg16 pc_inc_twowb(.read(pc_inc_two_WB),.write(pc_inc_two_MEM),.wr_en(1'b1),.rst(rst),.clk(clk));
   reg1 oflwb(.q(oflWB),.d(oflMEM),.clk(clk),.rst(rst),.en(1'b1));
   reg1 zerowb(.q(zeroWB),.d(zeroMEM),.clk(clk),.rst(rst),.en(1'b1));
   reg1 Nwb(.q(NWB),.d(NMEM),.clk(clk),.rst(rst),.en(1'b1));
   reg1 Pwb(.q(PWB),.d(PMEM),.clk(clk),.rst(rst),.en(1'b1));
   reg1 c_out_WB(.q(c_outWB),.d(c_outMEM),.clk(clk),.rst(rst),.en(1'b1));

   reg1 haltwb(.q(haltWB),.d(haltMEM),.clk(clk),.rst(rst),.en(1'b1));

   reg1 slbiwb(.q(slbi_WB),.d(slbi_MEM),.clk(clk),.rst(rst),.en(1'b1));
//   reg1 regwrmem(.q(regwriteWB),.d(regwriteMEM),.clk(clk),.rst(rst));

   reg16 nx_pcwb(.read(nx_pcWB),.write(nx_pcMEM),.wr_en(1'b1),.rst(rst),.clk(clk));

  //Stage WriteBack
   WB_control wbcntl(.MemtoReg(memtoreg),.RegWrite(regwrite),.ld_imm(ld_imm),.compareS(compareS),.btr(btr),.writeR7(writeR7),.opcode(instWB[15:11]),.RegDst(regdst));

   


    writeback wback (.nxt_pc(pc_inc_two_WB), .wr_r7(writeR7),.rd(rdWB),.rs(rsWB),.regdst(regdst),.memtoreg(memtoreg),.slbi(slbi_WB),.compareS(compareS),.btr_cntl(btr),.aluOut(aluOutWB),.mem_out(mem_outWB),.alu_out(aluOutWB),.imm(immWB),.writereg(writereg),.ofl(oflWB),.zero(zeroWB),.N(NWB),.P(PWB),.cout(c_outWB),.inst(instWB),.ld_imm(ld_imm),.regwritedata(regwritedata));
   
   //hazard
   Harzard HDU (.ID_rs(r1_reg), .ID_rt(r2_reg), .EX_rd(ex_r_wr),.MEM_rd(mem_r_wr),.ID_rs_v(id_rs_v), .ID_rt_v(id_rt_v), .EX_rd_v(ex_rd_v),.MEM_rd_v(mem_rd_v),.EX_inst(instEX),.fow_EXID_rs(fow_EXID_rs_ID),.fow_EXID_rt(fow_EXID_rt_ID),. fow_MEMID_rs(fow_MEMID_rs_ID),.fow_MEMID_rt(fow_MEMID_rt_ID),.stall(stall),.rst(rst),.clk(clk));
   
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
