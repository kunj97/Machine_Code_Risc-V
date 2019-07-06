module CPU_top(input clk, input rst);
   wire ALUenable, ALUzero, inc_pc, jump, branch, load_inst, dec_en, regwrite, mem_wr, mem_rd;
   wire[31:0] inst, ALU_data2, rd1, rd2, wd, rd_data, ALUresult,  data2;
   wire[31:0] jump_addr, branch_addr, pc_addr, pc_addr_plus;
   wire[10:0] execution;
   wire[4:0] rr1, rr2, wr, ALUcommand;

   ALU alu1(.ALUenable(ALUenable),.command(ALUcommand), .data1(rd1), 
     .data2(data2), .ALUresult(ALUresult), .ALUzero(ALUzero)); //

   pc  pc1(.rst(rst), .inc_pc(inc_pc), .jump(jump), .branch(branch), .jump_addr(jump_addr), 
     .branch_addr(branch_addr), .pc_addr(pc_addr), .pc_addr_plus(pc_addr_plus));

   inst_ROM rom1(.inst_addr(pc_addr), .load_inst(load_inst), .inst(inst));

   inst_decoder decoder1(.inst(inst), .dec_en(dec_en), .rr1(rr1), .rr2(rr2), 
     .wr(wr), .ALU_data2(ALU_data2), .branch_address(branch_addr),
     .jump_address(jump_addr), .execution(execution));

   registers register1(.rr1(rr1), .rr2(rr2), .wr(wr), .wd(wd), 
     .regwrite(regwrite), .rd1(rd1), .rd2(rd2));

   data_RAM ram1(.address(ALUresult), .wdata(rd2), .mem_wr(mem_wr), 
     .mem_rd(mem_rd), .rd_data(rd_data));

   control control1(.execution(execution), .clk(clk), .rst(rst), .ALU_data2(ALU_data2), .rd2(rd2), 
     .ALUzero(ALUzero),.pc_addr_plus(pc_addr_plus), .ALUresult(ALUresult), .rd_data(rd_data),
     .inc_pc(inc_pc), .load_inst(load_inst), .dec_en(dec_en), .mem_rd(mem_rd), .regwrite(regwrite), .wd(wd),
     .ALUenable(ALUenable), .mem_wr(mem_wr), .jump(jump), .branch(branch), .data2(data2), .ALUcommand(ALUcommand));
endmodule
//Mar. 4, 2019, Y. Zhao, EECS2021, YorkU.
