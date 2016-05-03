module CLA16(A,B,Cin,Cout,S);

input [15:0]A,B;
input Cin;
output Cout;
output[15:0]S;

wire c30,c74,c118,c1512;
wire p30,p74,p118,p1512;
wire g30,g74,g118,g1512;

wire g70,p70,g158,p158;
wire p150,g150;

CLA4 A3_0 (.A(A[3:0]),.B(B[3:0]),.Cin(Cin),.Cout(),.P(p30),.G(g30),.S(S[3:0]));
CLA4 A7_4 (.A(A[7:4]),.B(B[7:4]),.Cin(c30),.Cout(),.P(p74),.G(g74),.S(S[7:4]));
CLA4 A11_8 (.A(A[11:8]),.B(B[11:8]),.Cin(c74),.Cout(),.P(p118),.G(g118),.S(S[11:8]));
CLA4 A15_12 (.A(A[15:12]),.B(B[15:12]),.Cin(c118),.Cout(),.P(p1512),.G(g1512),.S(S[15:12]));


assign g70 = g74|(p74&g30);
assign p70 = p30&p74;

assign g158 = g1512|(p1512&g118);
assign p158 = p118&p1512;

assign g150 = g158|(p158&g70);
assign p150 = p70&p158;

assign c30 = g30|(Cin&p30);
assign c74 = g70|(Cin&p70);
assign c118 = g118|(g74&p118)|(g30&p74&p118)|(Cin&p70&p118);
assign Cout = g1512|(g118&p1512)|(g74&p158)|(g30&p74&p158)|(Cin&p150);

endmodule
