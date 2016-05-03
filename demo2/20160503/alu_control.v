module alu_control(
  //output
  alu_op,
  inv_a,
  inv_b,
  cin,
  shamt,
  flip_1,
  flip_2,
  shift,
  SLBI,

  //input
  opcode,
  func,
  immd
);

  output reg[2:0] alu_op;
  output reg inv_a;
  output reg inv_b;
  output reg cin;
  output reg [3:0] shamt;
  output reg flip_1;
  output reg flip_2; 
  output reg shift; 
  output reg SLBI;

  input [4:0] opcode;
  input [1:0] func;
  input [3:0] immd;

  always @ *
  begin
    inv_a = 1'b0;	
    alu_op = 3'b000;
    inv_b = 1'b0;
    cin = 1'b0; 
    shamt = 4'b0000;
    flip_1 = 1'b0;
    flip_2 = 1'b0;
    shift = 1'b0;
    SLBI = 1'b0;

    case(opcode)
			5'b01000 : //ADDI
			begin
				alu_op = 3'b100;
				inv_b = 0;
        cin = 0;
    		shamt = 4'b0000;
	    	flip_1 = 1'b0;
      	flip_2 = 1'b0;
		    shift = 1'b0;
		end      

	    5'b01001 : //SUBI
		  begin
				alu_op = 3'b100;
				inv_a = 1'b1;
        cin = 1'b1;
        shamt = 4'b0000;
	    	flip_1 = 1'b0;
      	flip_2 = 1'b0;
		    shift = 1'b0;
		end      

      5'b01010 : //XORI
			begin
				alu_op = 3'b110; 
				inv_b = 1'b0;
				cin = 1'b0;		
        shamt = 4'b0000;
	    	flip_1 = 1'b0;
      	flip_2 = 1'b0;
		    shift = 1'b0;
		end

			5'b01011 : //ANDNI
			begin
				alu_op = 3'b111;
				inv_b = 1'b1;
				cin = 1'b0;
        shamt = 4'b0000;
	    	flip_1 = 1'b0;
      	flip_2 = 1'b0;
		    shift = 1'b0;
		end

      5'b10100 : //ROLI
			begin
				alu_op = 3'b000;
				inv_b = 1'b0;
				cin = 1'b0;
				shamt = immd;
  	    flip_1 = 1'b0;
      	flip_2 = 1'b0;
 		    shift = 1'b1;
	   	end

      5'b10101 : //SLLI
			begin
				alu_op = 3'b001; 
				inv_b = 1'b0;
        cin = 1'b0;
				shamt = immd;
	    	flip_1 = 1'b0;
				flip_2 = 1'b0;
 		    shift = 1'b1;
			end

      5'b10110 : //RORI
			begin
				alu_op = 3'b010; 
				inv_b = 1'b0;
        cin = 1'b0;
				shamt = immd;
	    	flip_1 = 1'b1;
      	flip_2 = 1'b1;
 		    shift = 1'b1;
			end

      5'b10111 : //SRLI
			begin
				alu_op = 3'b011; 
				inv_b = 1'b0;
        cin = 1'b0;
				shamt = immd;
	    	flip_1 = 1'b0;
      	flip_2 = 1'b0;
 		    shift = 1'b1;
			end

      5'b10000 : //ST
			begin
				alu_op = 3'b100; 
				inv_b = 1'b0;
        cin = 1'b0;
				shamt = 4'b0000;
	    	flip_1 = 1'b0;
      	flip_2 = 1'b0;
 		    shift = 1'b0;
			end

      5'b10001 : //LD
			begin
				alu_op = 3'b100; 
				inv_b = 1'b0;
        cin = 1'b0;
				shamt = 4'b0000;
	    	flip_1 = 1'b0;
      	flip_2 = 1'b0;
 		    shift = 1'b0;
			end

      5'b10011 : //STU
			begin
				alu_op = 3'b100; 
				inv_b = 1'b0;
        cin = 1'b0;
				shamt = 4'b0000;
	    	flip_1 = 1'b0;
      	flip_2 = 1'b0;
 		    shift = 1'b0;
			end
			
			
      5'b11001 : //BTR
			begin
				alu_op = 3'b100; 
				inv_b = 1'b0;
        cin = 1'b0;
				shamt = 4'b0000;
	    	flip_1 = 1'b0;
      	flip_2 = 1'b0;
 		    shift = 1'b0;
			end

			5'b11011 : //ADD, SUB, XOR, ANDN
			begin

				case(func)
					2'b00 : //ADD
						begin
							alu_op = 3'b100;
							inv_b = 1'b0;
							cin = 1'b0;
							shamt = 4'b0000;
							flip_1 = 1'b0;
							flip_2 = 1'b0;
 		    			shift = 1'b0;
						end

					2'b01 : //SUB
						begin
							alu_op = 3'b100;
							inv_a = 1'b1;
							cin = 1'b1;
							shamt = 4'b0000;
							flip_1 = 1'b0;
							flip_2 = 1'b0;
 		    			shift = 1'b0;
						end

					2'b10 : //XOR
						begin
							alu_op = 3'b110;
							inv_b = 1'b0;
							cin = 1'b0;
							shamt = 4'b0000;
							flip_1 = 1'b0;
							flip_2 = 1'b0;
 		    			shift = 1'b0;
						end

					2'b11 : //ANDN
						begin
							alu_op = 3'b111;
							inv_b = 1'b1;
							cin = 1'b0;
							shamt = 4'b0000;
							flip_1 = 1'b0;
							flip_2 = 1'b0;
 		    			shift = 1'b0;
						end
					endcase
			end

			5'b11010 : //ROL, SLL, ROR,SRL
			begin

				case(func)
					2'b00 : //ROL
						begin
							alu_op = 3'b000;
							inv_b = 1'b0;
							cin = 1'b0;
							shamt = immd;
							flip_1 = 1'b0;
							flip_2 = 1'b0;
 		    			shift = 1'b1;
						end

					2'b01 : //SLL
						begin
							alu_op = 3'b001;
							inv_b = 1'b0;
							cin = 1'b0;
							shamt = immd;
							flip_1 = 1'b0;
							flip_2 = 1'b0;
 		    			shift = 1'b1;
						end

					2'b10 : //ROR
						begin
							alu_op = 3'b010;
							inv_b = 1'b0;
							cin = 1'b0;
							shamt = immd;
							flip_1 = 1'b1;
							flip_2 = 1'b1;
 		    			shift = 1'b1;
						end

					2'b11 : //SRL
						begin
							alu_op = 3'b011;
							inv_b = 1'b0;
							cin = 1'b0;
							shamt = immd;
							flip_1 = 1'b0;
							flip_2 = 1'b0;
 		    			shift = 1'b1;
						end
					endcase
			end

			5'b11100 : //SEQ
			begin
				alu_op = 3'b100;
				inv_a = 1;
        cin = 1;
    		shamt = 4'b0000;
	    	flip_1 = 1'b0;
      	flip_2 = 1'b0;
 		    shift = 1'b0;
			end      

	    5'b11101 : //SLT
		  begin
				alu_op = 3'b100;
				inv_a = 1'b1; //rt - rs
        cin = 1'b1;
        shamt = 4'b0000;
	    	flip_1 = 1'b0;
      	flip_2 = 1'b0;
 		    shift = 1'b0;
			end      

      5'b11110 : //SLE
			begin
				alu_op = 3'b100; 
				inv_a = 1'b1;
				cin = 1'b1;		
        shamt = 4'b0000;
	    	flip_1 = 1'b0;
      	flip_2 = 1'b0;
 		    shift = 1'b0;
			end

			5'b11111 : //SCO	
			begin
				alu_op = 3'b100;
				inv_b = 1'b0;
				cin = 1'b0;
        shamt = 4'b0000;
	    	flip_1 = 1'b0;
      	flip_2 = 1'b0;
 		    shift = 1'b0;
			end
			
			5'b10010 : //SLBI	
			begin
				alu_op = 3'b001;
				inv_b = 1'b0;
				cin = 1'b0;
        shamt = 4'b1000;
	    	flip_1 = 1'b0;
      	flip_2 = 1'b0;
 		    shift = 1'b1;
 		    SLBI = 1'b1;
			end

			default : 
			begin
		inv_a = 1'b0;
    		alu_op = 3'b000;
    		inv_b = 1'b0;
    		cin = 1'b0; 
    		shamt = 4'b0000;
    		flip_1 = 1'b0;
    		flip_2 = 1'b0;
 		    shift = 1'b0;
			end

    endcase
  end
endmodule
