module data_RAM(input[31:0] address, input[31:0] wdata, input mem_wr, input mem_rd, output[31:0] rd_data);
    reg[31:0] RAM[127:0];
    assign rd_data=(mem_rd==1'b1)?RAM[address]:32'hZZZZZZZZ; //execute the write and read operation
    always @(posedge mem_wr)
         begin
           RAM[address]<=wdata;
         end
endmodule
//Mar. 2, 2019, Y. Zhao, EECS2021, YorkU
 
