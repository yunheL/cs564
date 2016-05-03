/* Author: Yunhe Liu & Wenxuan Mao
 * Team: MacroHard
 * Date: 3/13/2016
 * This is the instruction decoder for our processor.
 */
module WB_control(
	//outputs
	MemtoReg,
	RegWrite,
	ld_imm,
	compareS,
	btr,
	writeR7,
        RegDst,
	
	//input
	opcode
);

        output reg MemtoReg;
	output reg RegWrite;
	output reg ld_imm;
	output reg compareS;
	output reg btr;
        output reg writeR7;
        output reg RegDst;

	input [4:0] opcode;
	
	always @ *
	begin
		MemtoReg = 1'b0;	//WB
		RegWrite = 1'b0;	//WB
	        ld_imm = 1'b0;		//WB
		compareS = 1'b0;	//WB
		btr = 1'b0;		//WB
		writeR7 = 1'b0;		//WB
                RegDst = 1'b0;          //WB

		case(opcode)
			5'b00000 : //TODO - HALT_1/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b0;
				RegDst = 1'b0;
			end

			5'b00001 : //TODO - NOP_2/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b0;
				RegDst = 1'b0;
			end
		
			5'b01000 : //ADDI_3/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				RegDst = 1'b1;
			end

			5'b01001 : //SUBI_4/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				RegDst = 1'b1;
			end
			
			5'b01010 : //XOR1_5/38
			begin	
				MemtoReg = 1'b0;
	
				RegWrite = 1'b1;
				RegDst = 1'b1;
			end

			5'b01011 : //ANDNI_6/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				RegDst = 1'b1;
			end

			5'b10100 : //ROLI_7/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				RegDst = 1'b1;
			end

			5'b10101 : //SLLI_8/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				RegDst = 1'b1;
			end

			5'b10110 : //RORI_9/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				RegDst = 1'b1;
			end

			5'b10111 : //SRLI_10/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				RegDst = 1'b1;
			end

			5'b10000 : //ST_11/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b0;
				
				RegDst = 1'b0;
			end

			5'b10001 : //LD_12/38
			begin	
				MemtoReg = 1'b1;
				RegWrite = 1'b1;
				RegDst = 1'b1;
				
			end

			5'b10011 : //STU_13/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				
				RegDst = 1'b0;
			end

			5'b11001 : //BTR_14/38 -TODO
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				btr = 1'b1;
				RegDst = 1'b1;	
			end

			5'b11011 : //ADD,SUB,XOR,ANDN_15-18/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				RegDst = 1'b1;
			end

			5'b11010 : //ROL,SLL,ROR,SRL_19-22/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				RegDst = 1'b1;
			end

			5'b11100 : //SEQ_23/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				compareS = 1'b1;
				RegDst = 1'b1;
			end

			5'b11101 : //SLT_24/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				compareS = 1'b1;
				RegDst = 1'b1;
			end

			5'b11110 : //SLE_25/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				compareS = 1'b1;
				RegDst = 1'b1;
			end

			5'b11111 : //SCO_26/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				compareS = 1'b1;
				RegDst = 1'b1;
			end

			5'b01100 : //BEQZ_27/38
			begin	
				MemtoReg = 1'b0;
				
				RegWrite = 1'b0;
				RegDst = 1'b0;
			end

			5'b01101 : //BNEZ_28/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b0;
				RegDst = 1'b0;
			end

			5'b01110 : //BLTZ_29/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b0;
				RegDst = 1'b0;
			end

			5'b01111 : //BGEZ_30/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b0;
				RegDst = 1'b0;
			end

			5'b11000 : //LBI_31/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				ld_imm = 1'b1;
				RegDst = 1'b0;
			end

			5'b10010 : //SLBI_32/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				RegDst = 1'b0;
			end

			5'b00100 : //J_33/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b0;
				RegDst = 1'b0;
			end

			5'b00101 : //JR_34/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b0;
				RegDst = 1'b0;
			end

			5'b00110 : //JAL_35/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				writeR7 = 1'b1;
				RegDst = 1'b1;
			end

			5'b00111 : //JALR_36/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b1;
				writeR7 = 1'b1;
				RegDst = 1'b1;
			end

			5'b00010 : //TODO - siic Rs_37/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b0;
				RegDst = 1'b0;
			end

			5'b00011 : //TODO - NOP/RTI_38/38
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b0;
				RegDst = 1'b0;
			end
		
			default: //TODO
			begin	
				MemtoReg = 1'b0;
				RegWrite = 1'b0;
				RegDst = 1'b0;
			end
	
		endcase
	end
	
endmodule
