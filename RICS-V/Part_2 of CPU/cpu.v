//yMux
module yMux(z, a, b, c);
parameter SIZE = 2;
output [SIZE-1:0] z;
input  [SIZE-1:0] a, b;
input  c;
yMux1 mine[SIZE-1:0](z, a, b, c);

endmodule

//yMux1
module yMux1(z, a, b, c);
output z;
input a, b, c;
wire notC, upper, lower;

not my_not(notC, c);
and upperAnd(upper, a, notC);
and lowerAnd(lower,c ,b);
or my_or(z, upper, lower);

endmodule

//yMux2
module yMux2(z, a, b, c);
output [1:0] z;
input [1:0] a, b;
input c;

yMux1 upper(z[0], a[0], b[0], c);
yMux1 lower(z[1], a[1], b[1], c);

endmodule

//yMux4to1
module yMux4to1(z, a0, a1, a2, a3, c);
parameter SIZE = 2;
output [SIZE-1:0] z;
input  [SIZE-1:0] a0, a1, a2, a3;
input  [1:0] c;
wire   [SIZE-1:0] zLo, zHi;

yMux #(SIZE) lo(zLo, a0, a1, c[0]);
yMux #(SIZE) hi(zHi, a2, a3, c[0]);
yMux #(SIZE) final(z, zLo, zHi, c[1]);

endmodule

//yAdder1
module yAdder1(z, cout, a, b, cin);
output z, cout;
input a, b, cin;

xor left_xor(tmp, a, b);
xor right_xor(z, cin, tmp);
and left_and(outL, a, b);
and right_and(outR, tmp, cin);
or my_or(cout, outR, outL);

endmodule

//yAdder
module yAdder (z, cout, a, b, cin) ;

output [31:0] z;
output cout;
input [31:0] a, b;
input cin;
wire [31:0] in, out;
yAdder1 mine [31:0] (z, out, a, b, in);
assign in[0] = cin;

genvar i;
generate
	for (i = 1; i < 32; i = i + 1)
	begin : asg
		assign in[i] = out[i-1];
    end
endgenerate

assign cout = out[31];

endmodule

//yArith
module yArith (z, cout, a, b, ctrl) ;

output [31:0] z;
output cout;
input  [31:0] a, b;
input  ctrl;
wire   [31:0] notB, tmp;
wire   cin;


assign cin = ctrl;
not my_not [31:0] (notB, b);
yMux #(32) mux(tmp, b, notB, cin);
yAdder adder(z, cout, a, tmp, cin);

endmodule

//yAlu
module yAlu (z, ex, a, b, op) ;

   input [31:0] a, b;
   input [2:0]  op;
   output [31:0] z;
   output        ex;
   wire          cout;
   wire [31:0]   alu_and, alu_or, alu_arith, slt, tmp;

   wire [15:0]   z16;
   wire [7:0]    z8;
   wire [3:0]    z4;
   wire [1:0]    z2;
   wire          z1, z0;

   assign slt[31:1] = 0;

   or or16[15:0] (z16, z[15: 0], z[31:16]);
   or or8[7:0] (z8, z16[7: 0], z16[15:8]);
   or or4[3:0] (z4, z8[3: 0], z8[7:4]);
   or or2[1:0] (z2, z4[1:0], z4[3:2]);
   or or1[15:0] (z1, z2[1], z2[0]);
   not m_not (z0, z1);
   assign ex = z0;

   xor (condition, a[31], b[31]);
   yArith slt_arith (tmp, cout, a, b, op[2]);
   yMux #(.SIZE(1)) slt_mux(slt[0], tmp[31], a[31], condition);

   and m_and [31:0] (alu_and, a, b);
   or m_or [31:0] (alu_or, a, b);
   yArith m_arith (alu_arith, cout, a, b, op[2]);
   yMux4to1 #(.SIZE(32)) mux(z, alu_and, alu_or, alu_arith, slt, op[1:0]);

endmodule
