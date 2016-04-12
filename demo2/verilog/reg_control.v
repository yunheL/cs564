/* Author: Yunhe Liu & Wenxuan Mao
 * Team: MacroHard
 * Date: 4/12/2016
 * This is the instruction decoder for our processor.
 */
module reg_control(
	//outputs
    rs_v,
    rt_v,
    rd_v,
    r1_reg,
    r2_reg,
    r_wr,

	//input
	inst
);

    output reg rs_v;
    output reg rt_v;
    output reg rd_v;
    output reg [2:0] r1_reg;
    output reg [2:0] r2_reg;
    output reg [2:0] r_wr;

	input [15:0] inst;

	//multiple statement
	always @ *
	begin
        rs_v = 1'b0;
        rt_v = 1'b0;
        rd_v = 1'b0;

        r1_reg = 3'b000;
        r2_reg = 3'b000;
        r_wr = 3'b000;

		case(inst[15:11])
			5'b00000 : //TODO - HALT_1/38
			begin	
                rs_v = 1'b0;
                rt_v = 1'b0;
                rd_v = 1'b0;

                r1_reg = 3'b000;
                r2_reg = 3'b000;
                r_wr = 3'b000;
			end

			5'b00001 : //TODO - NOP_2/38
			begin
                rs_v = 1'b0;
                rt_v = 1'b0;
                rd_v = 1'b0;

                r1_reg = 3'b000;
                r2_reg = 3'b000;
                r_wr = 3'b000;
			end

			5'b01000 : //ADDI_3/38
			begin
                rs_v = 1'b1;
                rt_v = 1'b0;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = 3'b000;
                r_wr = inst[7:5];
			end

			5'b01001 : //SUBI_4/38
			begin
                rs_v = 1'b1;
                rt_v = 1'b0;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = 3'b000;
                r_wr = inst[7:5];
			end

			5'b01010 : //XOR1_5/38
			begin
                rs_v = 1'b1;
                rt_v = 1'b0;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = 3'b000;
                r_wr = inst[7:5];
			end

			5'b01011 : //ANDNI_6/38
			begin
                rs_v = 1'b1;
                rt_v = 1'b0;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = 3'b000;
                r_wr = inst[7:5];
			end

			5'b10100 : //ROLI_7/38
			begin
                rs_v = 1'b1;
                rt_v = 1'b0;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = 3'b000;
                r_wr = inst[7:5];
			end

			5'b10101 : //SLLI_8/38
			begin
                rs_v = 1'b1;
                rt_v = 1'b0;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = 3'b000;
                r_wr = inst[7:5];
			end

			5'b10110 : //RORI_9/38
			begin
                rs_v = 1'b1;
                rt_v = 1'b0;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = 3'b000;
                r_wr = inst[7:5];
			end

			5'b10111 : //SRLI_10/38
			begin
                rs_v = 1'b1;
                rt_v = 1'b0;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = 3'b000;
                r_wr = inst[7:5];
			end

			5'b10000 : //ST_11/38
			begin
                rs_v = 1'b1;
                rt_v = 1'b1;
                rd_v = 1'b0;

                r1_reg = inst[10:8];
                r2_reg = inst[7:5];
                r_wr = 3'b000;
			end

			5'b10001 : //LD_12/38
			begin
                rs_v = 1'b1;
                rt_v = 1'b0;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = 3'b000;
                r_wr = inst[7:5];

			end

			5'b10011 : //STU_13/38
			begin	
                rs_v = 1'b1;
                rt_v = 1'b1;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = inst[7:5];
                r_wr = inst[10:8];
			end

			5'b11001 : //BTR_14/38 -TODO
			begin	
                rs_v = 1'b1;
                rt_v = 1'b0;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = 3'b000;
                r_wr = inst[4:2];
			end

			5'b11011 : //ADD,SUB,XOR,ANDN_15-18/38
			begin	
                rs_v = 1'b1;
                rt_v = 1'b1;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = inst[7:5];
                r_wr = inst[4:2];
			end

			5'b11010 : //ROL,SLL,ROR,SRL_19-22/38
			begin	
                rs_v = 1'b1;
                rt_v = 1'b1;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = inst[7:5];
                r_wr = inst[4:2];
			end

			5'b11100 : //SEQ_23/38
			begin	
                rs_v = 1'b1;
                rt_v = 1'b1;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = inst[7:5];
                r_wr = inst[4:2];
			end

			5'b11101 : //SLT_24/38
			begin	
                rs_v = 1'b1;
                rt_v = 1'b1;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = inst[7:5];
                r_wr = inst[4:2];
			end

			5'b11110 : //SLE_25/38
			begin	
                rs_v = 1'b1;
                rt_v = 1'b1;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = inst[7:5];
                r_wr = inst[4:2];
			end

			5'b11111 : //SCO_26/38
			begin	
                rs_v = 1'b1;
                rt_v = 1'b1;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = inst[7:5];
                r_wr = inst[4:2];
			end

			5'b01100 : //BEQZ_27/38
			begin	
                rs_v = 1'b1;
                rt_v = 1'b0;
                rd_v = 1'b0;

                r1_reg = inst[10:8];
                r2_reg = 3'b000;
                r_wr = 3'b000;
			end

			5'b01101 : //BNEZ_28/38
			begin	
                rs_v = 1'b1;
                rt_v = 1'b0;
                rd_v = 1'b0;

                r1_reg = inst[10:8];
                r2_reg = 3'b000;
                r_wr = 3'b000;
			end

			5'b01110 : //BLTZ_29/38
			begin	
                rs_v = 1'b1;
                rt_v = 1'b0;
                rd_v = 1'b0;

                r1_reg = inst[10:8];
                r2_reg = 3'b000;
                r_wr = 3'b000;
			end

			5'b01111 : //BGEZ_30/38
			begin	
                rs_v = 1'b1;
                rt_v = 1'b0;
                rd_v = 1'b0;

                r1_reg = inst[10:8];
                r2_reg = 3'b000;
                r_wr = 3'b000;
			end

			5'b11000 : //LBI_31/38
			begin	
                rs_v = 1'b0;
                rt_v = 1'b0;
                rd_v = 1'b1;

                r1_reg = 3'b000;
                r2_reg = 3'b000;
                r_wr = inst[10:8];
			end

			5'b10010 : //SLBI_32/38
			begin	
                rs_v = 1'b1;
                rt_v = 1'b0;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = 3'b000;
                r_wr = inst[10:8];
			end

			5'b00100 : //J_33/38
			begin	
                rs_v = 1'b0;
                rt_v = 1'b0;
                rd_v = 1'b0;

                r1_reg = 3'b000;
                r2_reg = 3'b000;
                r_wr = 3'b000;
			end

			5'b00101 : //JR_34/38
			begin	
                rs_v = 1'b1;
                rt_v = 1'b0;
                rd_v = 1'b0;

                r1_reg = inst[10:8];
                r2_reg = 3'b000;
                r_wr = 3'b000;
			end

			5'b00110 : //JAL_35/38
			begin	
                rs_v = 1'b0;
                rt_v = 1'b0;
                rd_v = 1'b1;

                r1_reg = 3'b000;
                r2_reg = 3'b000;
                r_wr = 3'b111;
			end

			5'b00111 : //JALR_36/38
			begin	
                rs_v = 1'b1;
                rt_v = 1'b0;
                rd_v = 1'b1;

                r1_reg = inst[10:8];
                r2_reg = 3'b000;
                r_wr = 3'b111;
			end

			5'b00010 : //TODO - siic Rs_37/38
			begin	

			end

			5'b00011 : //TODO - NOP/RTI_38/38
			begin	

			end
		
			default: //TODO
			begin	
                rs_v = 1'b0;
                rt_v = 1'b0;
                rd_v = 1'b0;

                r1_reg = 3'b000;
                r2_reg = 3'b000;
                r_wr = 3'b000;
			end
	
		endcase
	end
	
endmodule
