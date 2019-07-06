module ALU(
input ALUenable,
input[5:0] command, 
input[31:0] data1, 
input[31:0] data2, 
output[31:0] ALUresult, 
output ALUzero
);
    // BEQ and SUB needs SUB, ADD needs ADD, shift left needs SL, and XOR, OR  command={OR,XOR,SL,ADD,SUB} which is from the control unit
    parameter SUB=6'b000001;
    parameter ADD=6'b000010;
    parameter  SL=6'b000100;
    parameter XOR=6'b001000;
    parameter  OR=6'b010000;
	 parameter AND=6'b100000;
    reg[31:0] ALUresult_r;
    assign ALUresult=ALUresult_r;
    assign ALUzero=(ALUresult==32'h00000000)?1'b1:1'b0;
    always @(posedge ALUenable)
       begin
          case(command)
            SUB:
               begin
                  ALUresult_r<=data1-data2;
               end
            ADD:
               begin
                  ALUresult_r<=data1+data2;
               end
             SL:
               begin
                  ALUresult_r<=data1<<data2;
               end 
             XOR:
               begin
                  ALUresult_r<=data1^data2;
               end  
             OR:
               begin
                  ALUresult_r<=data1|data2;
               end
				 AND:
					begin
						ALUresult_r<=data1&data2;
					end	
             default:ALUresult_r<=32'h11111111;
           endcase         
       end
endmodule
//Mar. 2, 2019, Y. Zhao, EECS2021, YorkU
