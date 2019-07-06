module yAdder1 (z, cout, a, b, cin) ;
	output z, cout;
	input  a, b, cin;

	xor left_xor(tmp, a, b);
	xor right_xor(z, cin, tmp);
	and left_and(outL, a, b);
	and right_and(outR, tmp, cin);
	or my_or(cout, outR, outL);
endmodule // yAdder1

module yAdder (z, cout, a, b, cin) ;
	output [31:0] z;
	output        cout;
	input  [31:0] a, b;
	input         cin;
	wire   [31:0] in, out;

	yAdder1 mine [31:0] (z, out, a, b, in);

	assign in[0] = cin;

	genvar        i;
	generate
		for (i = 1; i < 32; i = i + 1) begin : asg
			assign in[i] = out[i-1];
		end
	endgenerate

	assign cout = out[31];
endmodule // yAdder

module yArith (z, cout, a, b, ctrl) ;
	// add if ctrl=0, subtract if ctrl=1
	output [31:0] z;
	output cout;
	input  [31:0] a, b;
	input  ctrl;
	wire   [31:0] notB, tmp;
	wire   cin;

	// instantiate the components and connect them
	assign cin = ctrl;
	not my_not [31:0] (notB, b);
   yMux #(32) mux(tmp, b, notB, cin);
	yAdder adder(z, cout, a, tmp, cin);
endmodule // yArith

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

	// upper bits are always zero
	assign slt[31:1] = 0;

	// ex ('or' all bits of z, then 'not' the result)
	or or16[15:0] (z16, z[15: 0], z[31:16]);
	or or8[7:0] (z8, z16[7: 0], z16[15:8]);
	or or4[3:0] (z4, z8[3: 0], z8[7:4]);
	or or2[1:0] (z2, z4[1:0], z4[3:2]);
	or or1[15:0] (z1, z2[1], z2[0]);
	not m_not (z0, z1);
	assign ex = z0;

	// set slt[0]
	xor (condition, a[31], b[31]);
	yArith slt_arith (tmp, cout, a, b, 1'b1);
	yMux #(.SIZE(1)) slt_mux(slt[0], tmp[31], a[31], condition);

	// instantiate the components and connect them
	and m_and [31:0] (alu_and, a, b);
	or m_or [31:0] (alu_or, a, b);
	yArith m_arith (alu_arith, cout, a, b, op[2]);
	yMux4to1 #(.SIZE(32)) mux(z, alu_and, alu_or, alu_arith, slt, op[1:0]);
endmodule // yAlu

module yMux(z, a, b, c);
	parameter SIZE = 32;
	output [SIZE-1:0] z;
	input [SIZE-1:0] a, b;
	input c;
	yMux1 mine[SIZE-1:0](z, a, b, c);
endmodule

module yMux1(z, a, b, c);
	output z;
	input a, b, c;
	wire notC, upper, lower;
	not my_not(notC, c);
	and upperAnd(upper, a, notC);
	and lowerAnd(lower, c, b);
	or my_or(z, upper, lower);
endmodule

module yMux2(z, a, b, c);
	output [1:0] z;
	input [1:0] a, b;
	input c;
	yMux1 upper(z[0], a[0], b[0], c);
	yMux1 lower(z[1], a[1], b[1], c);
endmodule

module yMux4to1(z, a0,a1,a2,a3, c);
	parameter SIZE = 2;
	output [SIZE-1:0] z;
	input [SIZE-1:0] a0, a1, a2, a3;
	input [1:0] c;
	wire [SIZE-1:0] zLo, zHi;
	yMux #(SIZE) lo(zLo, a0, a1, c[0]);
	yMux #(SIZE) hi(zHi, a2, a3, c[0]);
	yMux #(SIZE) final(z, zLo, zHi, c[1]);
endmodule
//----------------------------------------------------------------
module yIF(ins, PCp4, PCin, clk);
	output [31:0] ins, PCp4;
	input [31:0] PCin;
	input clk,enable,read,write;
	wire ex;
	input [31:0] a, memIn;
	input [2:0] op;
	wire [31:0] regout;

	assign write = 0;
	assign op = 2;
	assign enable = 1;
	assign read = 1;
	assign a = 4;
	register #(32) lol(regout, PCin, clk, enable);
	mem my_instr(ins, regout, memIn, clk, read, write);
	yAlu my_Alu(PCp4, ex, a, regout, op);

endmodule//yIF

module yID(rd1, rd2, immOut, jTarget, branch, ins, wd, RegWrite, clk);
	output [31:0] rd1, rd2, immOut;
	output [31:0] jTarget;
	output [31:0] branch;

	input [31:0] ins, wd;
	input RegWrite, clk;

	wire [19:0] zeros, ones; // For I-Type and SB-Type
	wire [11:0] zerosj, onesj; // For UJ-Type
	wire [31:0] imm, saveImm; // For S-Type

	rf myRF(rd1, rd2, ins[19:15], ins[24:20], ins[11:7], wd, clk, RegWrite);

	assign imm[11:0] = ins[31:20];
	assign zeros = 20'h00000;
	assign ones = 20'hFFFFF;
	yMux #(20) se(imm[31:12], zeros, ones, ins[31]);

	assign saveImm[11:5] = ins[31:25];
	assign saveImm[4:0] = ins[11:7];
	yMux #(20) saveImmSe(saveImm[31:12], zeros, ones, ins[31]);

	yMux #(32) immSelection(immOut, imm, saveImm, ins[5]);

	assign branch[11] = ins[31];
	assign branch[10] = ins[7];
	assign branch[9:4] = ins[30:25];
	assign branch[3:0] = ins[11:8];
	yMux #(20) bra(branch[31:12], zeros, ones, ins[31]);

	assign zerosj = 12'h000;
	assign onesj = 12'hFFF;
	assign jTarget[19] = ins[31];
	assign jTarget[18:11] = ins[19:12];
	assign jTarget[10] = ins[20];
	assign jTarget[9:0] = ins[30:21];
	yMux #(12) jum(jTarget[31:20], zerosj, onesj, jTarget[19]);

endmodule

module yEX (z, zero, rd1, rd2, imm, op, ALUSrc) ;
	output [31:0] z;
	output        zero;
	input  [31:0]  rd1, rd2, imm;
	input  [2:0] op;
	input  ALUSrc;
	wire   [31:0] b;

	yMux #(32) mux(b, rd2, imm, ALUSrc);
	yAlu alu(z, zero, rd1, b, op);
endmodule // yEX

module yDM(memOut, exeOut, rd2, clk, MemRead, MemWrite) ;
	output [31:0] memOut;
	input [31:0]  exeOut, rd2;
	input         clk, MemRead, MemWrite;

	mem memory(memOut, exeOut, rd2, clk, MemRead, MemWrite);
endmodule // yDM

module yPC(PCin, PCp4, INT, entryPoint, imm, jTarget, zero, branch, jump);
	output [31:0] PCin;
	input [31:0] PCp4, entryPoint, imm;
	input [25:0] jTarget;
	input INT, zero, branch, jump;
	wire [31:0] immX4, bTarget, choiceA, choiceB, target;
	wire doBranch, zf;
	assign immX4[31:2] = imm[29:0];
	assign immX4[1:0] = 2'b00;
	assign target[27:2] = jTarget[25:0];
	assign target[31:28] = PCp4[31:28];
	assign target[1:0] = 2'b00;

	yAlu myALU(bTarget, zf, PCp4, immX4, 3'b010);
	and (doBranch, branch, zero);
	yMux #(32) mux1(choiceA, PCp4, bTarget, doBranch);
	yMux #(32) mux2(choiceB, choiceA, target, jump);
	yMux #(32) mux3(PCin, choiceB, entryPoint, INT);

endmodule

module yWB(wb, exeOut, memOut, Mem2Reg) ;
	output [31:0] wb;
	input [31:0]  exeOut, memOut;
	input         Mem2Reg;

	yMux #(32) mux(wb, exeOut, memOut, Mem2Reg);
endmodule // yWB
