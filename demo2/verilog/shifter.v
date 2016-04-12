/*
 * Author: Yunhe Liu <liu348@wisc.edu>
 * 	   Wenxuan Mao <wmao7@wisc.edu>
 * Partner cs login: yunhe & wenxuan
 * Date: 02/14/2016
 * Brief Description:
 * This is a 16-bit barrel bidirectional barrel shifter.
 * Opcode 00 -> rotate left
 *        01 -> shift left
 *        10 -> shift right arithmetic
 *        11 -> shift right logical
 */
module shifter (In, Cnt, Op, Out);
   
   input [15:0] In;
   input [3:0]  Cnt;
   input [1:0]  Op;
   output [15:0] Out;

   /*
   Your code goes here
   */

   //using reg for combinatinal logic
   reg [15:0] c;
   reg [15:0] d;
   reg [15:0] e;

   reg [15:0] inreg;
   reg [15:0] outreg;
   reg [1:0]  opreg;
   reg [3:0]  cntreg;


   always @ *
   begin
     //assign input to the regs
     inreg = In;
     opreg = Op;
     cntreg = Cnt;

    case (Op)

 	  //rotate left: drop out from left append to the right
  	  2'b00	:	
		begin
	             	e = cntreg[0] ? {inreg[14:0],inreg[15]}	:	inreg;
             		d = cntreg[1] ? {e[13:0], e[15:14]}	: 	e;
             		c = cntreg[2] ? {d[11:0],d[15:12]} 	: 	d;
             		outreg = cntreg[3] ? {c[7:0], c[15:8]} : 	c;          
		end

	  //shift left: bits "drop off" on the left, extend 0 on the right
	  2'b01	:
		begin
	             	e = cntreg[0] ? {inreg[14:0],1'b0}	:	inreg;
             		d = cntreg[1] ? {e[13:0], {2{1'b0}}}	: 	e;
             		c = cntreg[2] ? {d[11:0],{4{1'b0}}} 	: 	d;
             		outreg = cntreg[3] ? {c[7:0], {8{1'b0}}}: 	c;          
		end



          //shift right arthimatic: discard "drop out" on the right and extend 
          //sign bit on the left
//          2'b10 :
//		begin
//             		e = cntreg[0] ? {inreg[15],inreg[15:1]}	:	inreg;
//             		d = cntreg[1] ? {{2{e[15]}},e[15:2]}	: 	e;
//             		c = cntreg[2] ? {{4{d[15]}},d[15:4]} 	: 	d;
//             		outreg = cntreg[3] ? {{8{c[15]}},c[15:8]} : 	c;          
//	        end
	  //rotate right: drop out from right append to the left
  	  2'b10	:	
		begin
	             	e = cntreg[0] ? {inreg[0],inreg[15:1]}	:	inreg;
             		d = cntreg[1] ? {e[1:0], e[15:2]}	: 	e;
             		c = cntreg[2] ? {d[3:0],d[15:4]} 	: 	d;
             		outreg = cntreg[3] ? {c[7:0], c[15:8]} : 	c;          
		end



          //shift righ logic: discard drop out on the right; extend 0 on left
	  2'b11	:
		begin
	             	e = cntreg[0] ? {1'b0,inreg[15:1]}	:	inreg;
             		d = cntreg[1] ? {{2{1'b0}}, e[15:2]}	: 	e;
             		c = cntreg[2] ? {{4{1'b0}},d[15:4]} 	: 	d;
             		outreg = cntreg[3] ? {{8{1'b0}}, c[15:8]}: 	c;          
		end

	  //default case, no rotation is done
	  default:	outreg = inreg;
      endcase
    end

    //assign reg to output value
    assign Out = outreg;
endmodule

