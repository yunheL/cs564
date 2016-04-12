module pfa(A,B,Cin,S,P,G);

input A,B,Cin;
output S,P,G;


assign P = A^B;
assign S = P^Cin;
assign G = A&B;


endmodule
