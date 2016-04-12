module reg16(read,write,wr_en,rst,clk);

input [15:0]write;
input wr_en,rst,clk;
output [15:0] read;

wire [15:0]d_in;



assign d_in = (wr_en)? write:read;

dff d0 (.q(read[0]),.d(d_in[0]),.clk(clk),.rst(rst));
dff d1 (.q(read[1]),.d(d_in[1]),.clk(clk),.rst(rst));
dff d2 (.q(read[2]),.d(d_in[2]),.clk(clk),.rst(rst));
dff d3 (.q(read[3]),.d(d_in[3]),.clk(clk),.rst(rst));
dff d4 (.q(read[4]),.d(d_in[4]),.clk(clk),.rst(rst));
dff d5 (.q(read[5]),.d(d_in[5]),.clk(clk),.rst(rst));
dff d6 (.q(read[6]),.d(d_in[6]),.clk(clk),.rst(rst));
dff d7 (.q(read[7]),.d(d_in[7]),.clk(clk),.rst(rst));
dff d8 (.q(read[8]),.d(d_in[8]),.clk(clk),.rst(rst));
dff d9 (.q(read[9]),.d(d_in[9]),.clk(clk),.rst(rst));
dff d10 (.q(read[10]),.d(d_in[10]),.clk(clk),.rst(rst));
dff d11 (.q(read[11]),.d(d_in[11]),.clk(clk),.rst(rst));
dff d12 (.q(read[12]),.d(d_in[12]),.clk(clk),.rst(rst));
dff d13 (.q(read[13]),.d(d_in[13]),.clk(clk),.rst(rst));
dff d14 (.q(read[14]),.d(d_in[14]),.clk(clk),.rst(rst));
dff d15 (.q(read[15]),.d(d_in[15]),.clk(clk),.rst(rst));

endmodule