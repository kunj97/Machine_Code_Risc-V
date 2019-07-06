module labN;
reg [31:0] entryPoint, zero;
reg RegDst, RegWrite, clk, ALUSrc, MemRead, MemWrite, Mem2Reg, INT, branch, jump;
reg [2:0] op;
wire [31:0] wd, rd1, rd2, imm, ins, PCp4, z, PCin;
wire [25:0] jTarget;
assign zero = 0; 

yChip myChip(ins, rd2, wb, entryPoint, INT, clk);

repeat (43)
		begin
                clk = 1; #1; INT = 0; 
	 
				op = 3'b010;
	 
				clk = 0; #1;

				$display("%h: rd1=%2d rd2=%2d z=%3d zero=%b wb=%2d", ins, rd1, rd2, z, zero, wb);
				
         end
			$finish; 
end
endmodule
