module CLA4(A,B,Cin,Cout,P,G,S);

input [3:0]A,B;
input Cin;
output Cout, P,G;
output [3:0]S;

wire p0,p1,p2,p3;
wire g0,g1,g2,g3;
wire c1,c2,c3;

pfa bit0 (.A(A[0]),.B(B[0]),.Cin(Cin),.S(S[0]),.P(p0),.G(g0));
pfa bit1 (.A(A[1]),.B(B[1]),.Cin(c1),.S(S[1]),.P(p1),.G(g1));
pfa bit2 (.A(A[2]),.B(B[2]),.Cin(c2),.S(S[2]),.P(p2),.G(g2));
pfa bit3 (.A(A[3]),.B(B[3]),.Cin(c3),.S(S[3]),.P(p3),.G(g3));

//CLA carry logic
assign P = p0&p1&p2&p3;
assign G = g3|(g2&p3)|(g1&p2&p3)|(g0&p1&p2&p3);

assign c1 = g0|(Cin&p0);
assign c2 = g1|(g0&p1)|(Cin&p0&p1);
assign c3 = g2|(g1&p2)|(g0&p1&p2)|(Cin&p0&p1&p2);
assign Cout = G |(Cin&P);

endmodule

