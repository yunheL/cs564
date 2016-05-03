module pc(branch_if, pc_inc_two, jmp_r, en,clk,rst,jump,inst,addr,branch,rs,pc_nx,EX_inst,br_ctl);

input jmp_r;
input branch_if;
input en, clk, rst, jump,branch;
input[15:0] inst,EX_inst;
input [15:0] rs;

output [15:0] addr;
output [15:0] pc_nx;
output br_ctl;
output [15:0] pc_inc_two;

//output [15:0] writeregdata;

wire Z,N,P;
wire [15:0] pc_wb, nxt_pc;
wire br_ctl;
wire [15:0] br_imm, br_out,br_pre;
wire [15:0] jmp_d, jmp_i, jmp_out;

//wire [15:0] br_dec;
wire [15:0] br_inc;
wire [15:0] prev_pc;

wire [15:0] inc;

wire [15:0] branch_addr;

reg16 branch_addr_reg(.read(branch_addr),.write(addr),.wr_en(branch_if),.rst(rst),.clk(clk));

//assign inc = (jmp_r) ?  16'h0000 : 16'h0002;

reg16 pc_dff(.read(addr),.write(pc_wb),.wr_en(en),.rst(rst),.clk(clk));
CLA16 pc_incr(.A(addr),.B(16'h0002),.Cin(1'b0),.Cout(),.S(nxt_pc));

CLA16 br_inc_two(.A(branch_addr),.B(16'h0002),.Cin(1'b0),.Cout(),.S(br_inc));
//CLA16 br_dec_four(.A(branch_addr),.B(16'b1111111111111100),.Cin(1'b0),.Cout(),.S(br_dec)); //-4 to go back to the branch address
CLA16 br_add(.A(br_inc),.B(br_imm),.Cin(1'b0),.Cout(),.S(br_pre));

//CLA16 previous_pc (.A(addr),.B(16'hFFFD),.Cin(1'b1).Cout(),.S(prev_pc)); //curr pc -2





  assign or0 = rs[0]|rs[1]|rs[2]|rs[3];
  assign or1 = rs[4]|rs[5]|rs[6]|rs[7];
  assign or2 = rs[8]|rs[9]|rs[10]|rs[11];
  assign or3 = rs[12]|rs[13]|rs[14]|rs[15];
  
  assign Z = ~(or0|or1|or2|or3);
  assign N = rs[15];
  assign P = ~(Z^N); 
assign br_ctl = ((EX_inst[15:11]==5'b01100)&Z) ?1'b1:
                ((EX_inst[15:11]==5'b01101)&(~Z))? 1'b1:
                ((EX_inst[15:11]==5'b01110)&N)? 1'b1:
                ((EX_inst[15:11]==5'b01111)&(Z|P))? 1'b1:
                1'b0;
assign br_imm = {{8{EX_inst[7]}}, EX_inst[7:0]};		//get immediate from EX stage instruction

CLA16 jmp_add_d(.A(nxt_pc),.B({{5{EX_inst[10]}},EX_inst[10:0]}),.Cin(1'b0),.Cout(),.S(jmp_d));
CLA16 jmp_add_i(.A(rs),.B({{8{EX_inst[7]}},EX_inst[7:0]}),.Cin(1'b0),.Cout(),.S(jmp_i));
assign jmp_out = (EX_inst[11])? jmp_i:jmp_d;
assign br_out = (br_ctl)? br_pre:nxt_pc;
assign pc_wb = (jump)? jmp_out : br_out;
assign pc_nx = pc_wb;
assign pc_inc_two = nxt_pc;
endmodule
