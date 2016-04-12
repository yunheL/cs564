/* Author: Yunhe Liu & Wenxuan Mao
 * Team: MacroHard
 * Date: 4/06/2016
 * Control for ID Stage.
 */
module ID_control(
	//outputs
	Rt_Rd,
	Halt,
	
	//input
	opcode
);

	output reg Rt_Rd;
        output reg Halt;

	input [4:0] opcode;
	
	always @ *
	begin
	        Rt_Rd = 1'b0;		//ID
	        Halt = 1'b0;		//ID

		case(opcode)
			5'b00000 : //TODO - HALT_1/38
			begin	
				Halt = 1'b1;
			end

			5'b10000 : //ST_11/38
			begin	
				Rt_Rd = 1'b1;
			end

			5'b10011 : //STU_13/38
			begin	
				Rt_Rd = 1'b1;
			end

			default: //TODO
			begin	
				Halt = 1'b0;
			end
	
		endcase
	end
	
endmodule
