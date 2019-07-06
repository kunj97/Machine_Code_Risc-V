module registers(input[4:0] rr1, input[4:0] rr2, input[4:0] wr, input[31:0] wd, input regwrite, output[31:0] rd1, output[31:0] rd2);

       reg[31:0] registerfile[31:0]; //declear the size of your register file. [4:0] defines how many registers, [31:0] defines each register length
       //as the registers are internal variables so you need to use reg for declearation
       assign rd1=registerfile[rr1];  //whenever rd1r changes rd1 automatically follows rd1r, as rd1 is the wires of rd1r
       assign rd2=registerfile[rr2]; //connect the register to the corresponding wires for interfacing with other modules

       always @(posedge regwrite) 
              begin
                      registerfile[wr]<=wd;
              end           // rising edge of regwrite trigers the write or read operations but always read is faster than write in register we can think, so there is no conflickts 
endmodule
//Created on Mar. 1. 2019 by Y. Zhao for Course EECS2021, Lassonde Schoole of Engineering, YorkU