module labM;
reg [31:0] PCin;
reg RegDst, RegWrite, clk, ALUSrc;
reg [2:0] op;

wire [31:0] wd, rd1, rd2, imm, ins, PCp4, z;
wire [31:0] jTarget, branch;
wire zero;

yIF myIF(ins, PCp4, PCin, clk);
yID myID(rd1, rd2, imm, jTarget, branch, ins, wd, RegWrite, clk); 
yEX myEx(z, zero, rd1, rd2, imm, op, ALUSrc);
assign wd = z;

initial
begin
	//------------------------------------Entry point
	PCin = 16'h28;
	//------------------------------------Run program
	repeat (11)
	begin
		//---------------------------------Fetch an ins
		clk = 1; #1;
		//---------------------------------Set control signals
		RegDst = 0; RegWrite = 0; ALUSrc = 1; op = 3'b010;
        if (ins[6:0] == 7'h33)
        begin
			RegDst = 1;
            RegWrite = 1;
            ALUSrc = 0;
        end

        // J format (jump)
        else if (ins[6:0] == 7'h6F)
        begin
            RegDst = 0;
            RegWrite = 0;
            ALUSrc = 1;
        end
			
		else //I-types
		begin	
            RegDst = 0;
            RegWrite = 1;
            ALUSrc = 1;
        end

        //---------------------------------Execute the ins
        clk = 0; #1;

        //---------------------------------View results
        $display("%h: rd1=%2d rd2=%2d imm=%h jTarget=%h z=%2d zero=%b", ins, rd1, rd2, imm, jTarget, z, zero);
        //---------------------------------Prepare for the next ins
        PCin = PCp4;
          
	    end
        $finish;
     end
endmodule
