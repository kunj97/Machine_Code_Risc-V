module inst_ROM(input[31:0] inst_addr, input load_inst, output[31:0] inst);
    reg[31:0] ROM[127:0]; //declear the size of the instructin memory which is ready-only so it is a ROM
    assign inst=(load_inst==1'b1)?ROM[inst_addr]:32'hZZZZZZZZ; //if recieved the load instruction command, get the instructon indexed by the address from pc
endmodule
//Mar. 2. 2019, Y. Zhao, EECS2021, YorkU
