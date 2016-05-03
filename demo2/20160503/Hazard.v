module Harzard(ID_rs, ID_rt, EX_rd,MEM_rd,ID_rs_v, ID_rt_v, EX_rd_v,MEM_rd_v,EX_inst,fow_EXID_rs,fow_EXID_rt, fow_MEMID_rs,fow_MEMID_rt,stall,clk,rst);

input[2:0] ID_rs, ID_rt, EX_rd,MEM_rd;
input ID_rs_v, ID_rt_v, EX_rd_v,MEM_rd_v;
input [15:0] EX_inst;
input rst,clk;


output fow_EXID_rs,fow_EXID_rt, fow_MEMID_rs,fow_MEMID_rt;//foward signal from which stage to which rs/rt reg
output  stall;

//reg [1:0]stall_cnt;
//wire [1:0]stall_cnt_q;
//wire stall_LD;

//data Hazard (most recent execution result)

assign fow_EXID_rs = (EX_rd_v&ID_rs_v&(EX_rd==ID_rs));
assign fow_EXID_rt = (EX_rd_v&ID_rt_v&(EX_rd==ID_rt));
assign fow_MEMID_rs = (MEM_rd_v&ID_rs_v&~(EX_rd_v&(EX_rd==MEM_rd))&(MEM_rd==ID_rs));
assign fow_MEMID_rt = (MEM_rd_v&ID_rt_v&~(EX_rd_v&(EX_rd==MEM_rd))&(MEM_rd==ID_rt));
/*
//stall 2 cycles
dff st_cnt0(.q(stall_cnt_q[0]),.d(stall_cnt[0]),.clk(clk),.rst(rst));
dff st_cnt1(.q(stall_cnt_q[1]),.d(stall_cnt[1]),.clk(clk),.rst(rst));
*/
//assign stall = stall_LD;
/*
always @ * begin
case(stall_LD)
  1'b1: 
  begin
  case(stall_cnt_q) 
    2'b00: 
    begin
      stall_cnt = 2'b01;
      stall = 1'b1;
    end
    2'b01:
    begin
      stall_cnt = 2'b10;
      stall = 1'b1;
    end
    2'b01: 
    begin
      stall_cnt = 2'b00;
      stall = 1'b0;
    end
    default: 
    begin
      stall_cnt = 2'b00;
      stall = 1'b0;
    end
  
  endcase
  end
  1'b0: 
  begin
    stall_cnt = 2'b00;
    stall = 1'b0;
  end
endcase
end
*/
    
//assign stall_LD = (EX_inst[15:11]==5'b10001);
assign stall = ((EX_inst[15:11]==5'b10001)&EX_rd_v)&((ID_rs==EX_rd)|(ID_rt==EX_rd));//optimized erroness stall
//assign stall = ((MEM_inst[15:11]==5'b10001)&MEM_rd_v)&((EX_rs==MEM_rd)|(EX_rt==MEM_rd));
endmodule
