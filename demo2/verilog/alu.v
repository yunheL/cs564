module alu (A, B, Cin, Op, invA, invB, sign, Out, Ofl, Z,N,P, c_out);
   
        input [15:0] A;
        input [15:0] B;
        input Cin;
        input [2:0] Op;
        input invA;
        input invB;
        input sign;
        output reg [15:0] Out;
        output reg Ofl;
        output Z,N,P;
        output c_out;

   /*
	Your code goes here
   */
   
  wire [15:0]notA,twosA ;
  wire [15:0]notB,twosB ;
  wire [15:0]shiftOut;
  wire [15:0]opA,opB;
  wire cout;
  wire [15:0] sumOut;
  
  wire or0,or1,or2,or3;
   
  assign notA = {~A[15],~A[14],~A[13],~A[12],~A[11],~A[10],~A[9],~A[8],~A[7],~A[6],~A[5],~A[4],~A[3],~A[2],~A[1],~A[0]};
//  incrementer16 INA (.A(notA),.Out(twosA)); 
  //assign notA = ~A;
  assign opA = (invA)?notA:A;
   
  assign notB = {~B[15],~B[14],~B[13],~B[12],~B[11],~B[10],~B[9],~B[8],~B[7],~B[6],~B[5],~B[4],~B[3],~B[2],~B[1],~B[0]};
//  incrementer16 INB (.A(notB),.Out(twosB));
  //assign notB = ~B;
  assign opB = (invB)?notB:B;
      
      
  //shifter    
  shifter shift(.In(opA), .Cnt(opB[3:0]), .Op(Op[1:0]), .Out(shiftOut));
  CLA16 adder(.A(opA),.B(opB),.Cin(Cin),.Cout(cout),.S(sumOut));
  always @*
  begin
    //Ofl = 1'b0;
    Ofl = ((opA[15]&opB[15]&(~sumOut[15])))||((~opA[15])&(~opB[15])&(~opB[15])&sumOut[15]);
    case (Op[2])
      1'b0: Out = shiftOut;
      1'b1:begin
        case (Op[1:0])
          2'b00:
          begin
            //case(sign)
              //1'b0:  Ofl = cout;
              //1'b1:  Ofl = ((~(opA[15]^opB[15]))^sumOut[15])? 1'b1:1'b0;

            //endcase
            Out = sumOut;
          end
          2'b01: Out = {opA[15]|opB[15],opA[14]|opB[14],opA[13]|opB[13],opA[12]|opB[12],opA[11]|opB[11],opA[10]|opB[10],opA[9]|opB[9],opA[8]|opB[8],opA[7]|opB[7],opA[6]|opB[6],opA[5]|opB[5],opA[4]|opB[4],opA[3]|opB[3],opA[2]|opB[2],opA[1]|opB[1],opA[0]|opB[0]};
          2'b10: Out = {opA[15]^opB[15],opA[14]^opB[14],opA[13]^opB[13],opA[12]^opB[12],opA[11]^opB[11],opA[10]^opB[10],opA[9]^opB[9],opA[8]^opB[8],opA[7]^opB[7],opA[6]^opB[6],opA[5]^opB[5],opA[4]^opB[4],opA[3]^opB[3],opA[2]^opB[2],opA[1]^opB[1],opA[0]^opB[0]};
          2'b11: Out = {opA[15]&opB[15],opA[14]&opB[14],opA[13]&opB[13],opA[12]&opB[12],opA[11]&opB[11],opA[10]&opB[10],opA[9]&opB[9],opA[8]&opB[8],opA[7]&opB[7],opA[6]&opB[6],opA[5]&opB[5],opA[4]&opB[4],opA[3]&opB[3],opA[2]&opB[2],opA[1]&opB[1],opA[0]&opB[0]};
        endcase
      end
      default:Out = shiftOut;
    endcase
  end
      
  assign or0 = Out[0]|Out[1]|Out[2]|Out[3];
  assign or1 = Out[4]|Out[5]|Out[6]|Out[7];
  assign or2 = Out[8]|Out[9]|Out[10]|Out[11];
  assign or3 = Out[12]|Out[13]|Out[14]|Out[15];
  
  assign Z = ~(or0|or1|or2|or3);
  assign N = Out[15];
  assign P = ~(Z^N);       
  assign c_out = cout; 
endmodule

