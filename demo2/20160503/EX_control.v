/* Author: Yunhe Liu & Wenxuan Mao
 * Team: MacroHard
 * Date: 4/6/2016
 * This is control for EX stage.
 */
module EX_control(
	//outputs
	ALUOp,
	ALUSrc,
        wr_r7,
        compareS_EX,
	
	//input
	opcode
);

	output reg[4:0] ALUOp;
	output reg ALUSrc;
        output reg wr_r7;
	output reg compareS_EX;

	input [4:0] opcode;
	
	always @ *
	begin
		ALUOp = 5'b00000;	//EX
		ALUSrc = 1'b0;		//EX
		wr_r7 = 1'b0;
		compareS_EX = 1'b1;

		case(opcode)
			5'b00000 : //TODO - HALT_1/38
			begin
				ALUOp = 5'b00000;
				ALUSrc = 1'b0;
			end

			5'b00001 : //TODO - NOP_2/38
			begin	
				ALUOp = 5'b00000;
				ALUSrc = 1'b0;
			end
		
			5'b01000 : //ADDI_3/38
			begin	
				ALUOp = 5'b01000;
				ALUSrc = 1'b0;
			end

			5'b01001 : //SUBI_4/38
			begin	
				ALUOp = 5'b01001;
				ALUSrc = 1'b0;
			end
			
			5'b01010 : //XOR1_5/38
			begin	
				ALUOp = 5'b01010;
				ALUSrc = 1'b0;
			end

			5'b01011 : //ANDNI_6/38
			begin	
				ALUOp = 5'b01011;
				ALUSrc = 1'b0;
			end

			5'b10100 : //ROLI_7/38
			begin	
				ALUOp = 5'b10100;
				ALUSrc = 1'b0;
			end

			5'b10101 : //SLLI_8/38
			begin	
				ALUOp = 5'b10101;
				ALUSrc = 1'b0;
			end

			5'b10110 : //RORI_9/38
			begin	
				ALUOp = 5'b10110;
				ALUSrc = 1'b0;
			end

			5'b10111 : //SRLI_10/38
			begin	
				ALUOp = 5'b10111;
				ALUSrc = 1'b0;
			end

			5'b10000 : //ST_11/38
			begin	
				ALUOp = 5'b10000;
				ALUSrc = 1'b0;
			end

			5'b10001 : //LD_12/38
			begin	
				ALUOp = 5'b10001;
				ALUSrc = 1'b0;
				
			end

			5'b10011 : //STU_13/38
			begin	
				ALUOp = 5'b10011;
				ALUSrc = 1'b0;
			end

			5'b11001 : //BTR_14/38 -TODO
			begin	
				ALUOp = 5'b11001;
				ALUSrc = 1'b0;	
			end

			5'b11011 : //ADD,SUB,XOR,ANDN_15-18/38
			begin	
				ALUOp = 5'b11011;
				ALUSrc = 1'b1;
			end

			5'b11010 : //ROL,SLL,ROR,SRL_19-22/38
			begin	
				ALUOp = 5'b11010;
				ALUSrc = 1'b1;
			end

			5'b11100 : //SEQ_23/38
			begin	
				ALUOp = 5'b11100;
				ALUSrc = 1'b1;
			end

			5'b11101 : //SLT_24/38
			begin	
				ALUOp = 5'b11101;
				ALUSrc = 1'b1;
			end

			5'b11110 : //SLE_25/38
			begin	
				ALUOp = 5'b11110;
				ALUSrc = 1'b1;
			end

			5'b11111 : //SCO_26/38
			begin	
				ALUOp = 5'b11111;
				ALUSrc = 1'b1;
				compareS_EX = 1'b1;
			end

			5'b01100 : //BEQZ_27/38
			begin	
				ALUOp = 5'b01100;
				ALUSrc = 1'b0;
			end

			5'b01101 : //BNEZ_28/38
			begin	
				ALUOp = 5'b01101;
				ALUSrc = 1'b0;
			end

			5'b01110 : //BLTZ_29/38
			begin	
				ALUOp = 5'b01110;
				ALUSrc = 1'b0;
			end

			5'b01111 : //BGEZ_30/38
			begin	
				ALUOp = 5'b01111;
				ALUSrc = 1'b0;
			end

			5'b11000 : //LBI_31/38
			begin	
				ALUOp = 5'b11000;
				ALUSrc = 1'b0;
			end

			5'b10010 : //SLBI_32/38
			begin	
				ALUOp = 5'b10010;
				ALUSrc = 1'b0;
			end

			5'b00100 : //J_33/38
			begin	
				ALUOp = 5'b00100;
				ALUSrc = 1'b0;
			end

			5'b00101 : //JR_34/38
			begin	
				ALUOp = 5'b00101;
				ALUSrc = 1'b0;
			end

			5'b00110 : //JAL_35/38
			begin	
				ALUOp = 5'b00110;
				ALUSrc = 1'b0;
				wr_r7 = 1'b1;
			end

			5'b00111 : //JALR_36/38
			begin	
				ALUOp = 5'b00111;
				ALUSrc = 1'b0;
				wr_r7 = 1'b1;
			end

			5'b00010 : //TODO - siic Rs_37/38
			begin	
				ALUOp = 5'b00000;
				ALUSrc = 1'b0;
			end

			5'b00011 : //TODO - NOP/RTI_38/38
			begin	
				ALUOp = 5'b00000;
				ALUSrc = 1'b0;
			end
		
			default: //TODO
			begin	
				ALUOp = 5'b00000;
				ALUSrc = 1'b0;
				wr_r7 = 1'b0;
				compareS_EX = 1'b1;
			end
	
		endcase
	end
	
endmodule
