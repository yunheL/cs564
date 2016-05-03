module reg3(read,write,wr_en,rst,clk);

input [2:0]write;
input wr_en,rst,clk;
output [2:0] read;

wire [2:0]d_in;



assign d_in = (wr_en)? write:read;

dff d0 (.q(read[0]),.d(d_in[0]),.clk(clk),.rst(rst));
dff d1 (.q(read[1]),.d(d_in[1]),.clk(clk),.rst(rst));
dff d2 (.q(read[2]),.d(d_in[2]),.clk(clk),.rst(rst));

endmodule
