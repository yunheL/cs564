/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf (
           // Outputs
           read1data, read2data, err,
           // Inputs
           clk, rst, read1regsel, read2regsel, writeregsel, writedata, write
           );
   input clk, rst;
   input [2:0] read1regsel;
   input [2:0] read2regsel;
   input [2:0] writeregsel;
   input [15:0] writedata;
   input        write;

   output [15:0] read1data;
   output [15:0] read2data;
   output        err;

   reg [7:0] writedecode;
   wire [15:0] readoutR0;
   wire [15:0] readoutR1;
   wire [15:0] readoutR2;
   wire [15:0] readoutR3;
   wire [15:0] readoutR4;
   wire [15:0] readoutR5;
   wire [15:0] readoutR6;
   wire [15:0] readoutR7;

   always @*
   begin
     case (writeregsel)
	   4'h0: writedecode = write?8'h01:8'h00;
	   4'h1: writedecode = write?8'h02:8'h00;
	   4'h2: writedecode = write?8'h04:8'h00;
	   4'h3: writedecode = write?8'h08:8'h00;
	   4'h4: writedecode = write?8'h10:8'h00;
	   4'h5: writedecode = write?8'h20:8'h00;
	   4'h6: writedecode = write?8'h40:8'h00;
	   4'h7: writedecode = write?8'h80:8'h00;
	   default: writedecode = 8'h00;
	 endcase
   end
	 /*
	 case(read1regsel)
	   4'h0: read1decode = 8'h01;
	   4'h1: read1decode = 8'h02;
	   4'h2: read1decode = 8'h04;
	   4'h3: read1decode = 8'h08;
	   4'h4: read1decode = 8'h10;
	   4'h5: read1decode = 8'h20;
	   4'h6: read1decode = 8'h40;
	   4'h7: read1decode = 8'h80;
	   default: read1decode = 8'h00;
	 endcase
	 
	 case(read2regsel)
	   4'h0: read2decode = 8'h01;
	   4'h1: read2decode = 8'h02;
	   4'h2: read2decode = 8'h04;
	   4'h3: read2decode = 8'h08;
	   4'h4: read2decode = 8'h10;
	   4'h5: read2decode = 8'h20;
	   4'h6: read2decode = 8'h40;
	   4'h7: read2decode = 8'h80;
	   default: read2decode = 8'h00;
	 endcase
   end
	   
*/	   
   
  
   reg16 r0(.read(readoutR0),.write(writedata),.wr_en(writedecode[0]),.rst(rst),.clk(clk));
   reg16 r1(.read(readoutR1),.write(writedata),.wr_en(writedecode[1]),.rst(rst),.clk(clk));
   reg16 r2(.read(readoutR2),.write(writedata),.wr_en(writedecode[2]),.rst(rst),.clk(clk));
   reg16 r3(.read(readoutR3),.write(writedata),.wr_en(writedecode[3]),.rst(rst),.clk(clk));
   reg16 r4(.read(readoutR4),.write(writedata),.wr_en(writedecode[4]),.rst(rst),.clk(clk));
   reg16 r5(.read(readoutR5),.write(writedata),.wr_en(writedecode[5]),.rst(rst),.clk(clk));
   reg16 r6(.read(readoutR6),.write(writedata),.wr_en(writedecode[6]),.rst(rst),.clk(clk));
   reg16 r7(.read(readoutR7),.write(writedata),.wr_en(writedecode[7]),.rst(rst),.clk(clk));
   
   
   assign read1data = (read1regsel==0)? readoutR0:
                      (read1regsel==1)? readoutR1:
					  (read1regsel==2)? readoutR2:
					  (read1regsel==3)? readoutR3:
					  (read1regsel==4)? readoutR4:
					  (read1regsel==5)? readoutR5:
					  (read1regsel==6)? readoutR6:
					  (read1regsel==7)? readoutR7:16'h0000;
					  
	assign read2data = (read2regsel==0)? readoutR0:
                      (read2regsel==1)? readoutR1:
					  (read2regsel==2)? readoutR2:
					  (read2regsel==3)? readoutR3:
					  (read2regsel==4)? readoutR4:
					  (read2regsel==5)? readoutR5:
					  (read2regsel==6)? readoutR6:
					  (read2regsel==7)? readoutR7:16'h0000;
   
   

endmodule
// DUMMY LINE FOR REV CONTROL :1:
