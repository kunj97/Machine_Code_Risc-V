`timescale 10ns/1ns
`include "pc.v"
`include "inst_ROM.v"
`include "inst_decoder.v"
`include "registers.v"
`include "data_RAM.v"
`include "ALU.v"
`include "control.v"
`include "CPU_top.v"
module test_CPU_top();
  reg clk, rst, executing,run; 
  wire clk1;
  reg[2:0] state;
//following instructions in ROM file is used for testing
//lw x2, x0, 0            //load the first value in data_RAM to x2 register, we initialized x0 to 0, x1 to 2,  
//000000000000_00000_010_00010_0000011// and first value in RAM to 1, so x2 will be 1 after this command
//add x3, x1, x2
//0000000_00010_00001_000_00011_0110011 // after this x3 will be 1+2=3
//xor x4, x1, x2 //after this x4 will be 3
//0000000_00010_00001_100_00100_0110011
//or x5, x1, x2 // after this x5 will be 3
//0000000_00010_00001_110_00101_0110011
//sub x6, x1, x2 //after this x6 will be 1
//0100000_00010_00001_000_00110_0110011
//slli x7, x1, 1 // after this x7 will be 4
//000000_000001_00001_001_00111_0010011
//sll x8, x1, x2 // after this x8 will be 4
//0000000_00010_00001_001_01000_0110011
//sw x0, x8, 1 // store the x8 value i.e. 4 to the seconde adress of data_RAM
//0000000_01000_00000_010_00001_0100011
//beq x4, x5, 10 //since x4==x5 so will jump to the 11th instruction 
//0_000000_00101_00100_000_0101_0_1100011
//sw x0, x8, 2 //this is the 10th instruction which will be skipped
//0000000_01000_00000_010_00010_0100011 //check if the third value of data_RAM is 4, if is 4 then beq is incorrect
//jal x9, 12 //jump to the 13th instruction and store 11 to register x9. check x9 if it is 11 and also 
//0_0000000110_0_00000000_01001_1101111 // this is the 11th instruction
//sw x0, x8, 3 //this is the 12th instruction which will be skipped
//0000000_01000_00000_010_00011_0100011 //check if the fourth value of data_RAM is 4, if is 4 then jal is incorrect
//halt      // this is the 13th instruction, break the system
//00000000000100000000000001110011 //wont execute the following instruction
//sw x0, x8, 4 //this is the 14th instruction which will never happen
//0000000_01000_00000_010_00100_0100011 //check if the fifth value of data_RAM is 4, if is 4 then halt is incorrect
  always                 //generate clock with 50MHz
    begin
     #1  clk=~clk;
    end
  CPU_top cpu_top1(.clk(clk1), .rst(rst)); //instantiate an cpu_top

  initial
    begin
      $readmemb("register.txt",cpu_top1.register1.registerfile);
      $display("register file is successfully initialized!\n");
      $readmemb("rom.txt",cpu_top1.rom1.ROM);
      $display("instructins are successfully loaded!\n");
      $readmemb("ram.txt",cpu_top1.ram1.RAM);
      $display("esential data is successfully loaded!\n");
         clk=1'b0;
      #1 rst=1'b1;
      #5 rst=1'b0; //reseting the system
         run_one_instruction; //executing one instruction, here is the first one
      $display("lw has been executed, x2 expected value is: 1, current value is: %d \n", cpu_top1.register1.registerfile[2]);
         run_one_instruction; //executing one instruction, here is the second one
      $display("add has been executed, x3 expected value is: 3, current value is: %d \n", cpu_top1.register1.registerfile[3]);
         run_one_instruction;
      $display("xor has been executed, x4 expected value is: 3, current value is: %d \n", cpu_top1.register1.registerfile[4]);
         run_one_instruction;
      $display("or has been executed, x5 expected value is: 3, current value is: %d \n", cpu_top1.register1.registerfile[5]);
         run_one_instruction;
      $display("sub has been executed, x6 expected value is: 1, current value is: %d \n", cpu_top1.register1.registerfile[6]);
         run_one_instruction;
      $display("slli has been executed, x7 expected value is: 4, current value is: %d \n", cpu_top1.register1.registerfile[7]);
         run_one_instruction;
      $display("sll has been executed, x8 expected value is: 4, current value is: %d \n", cpu_top1.register1.registerfile[8]);
         run_one_instruction;
      $display("sw has been executed, value at the second address of data_RAM should be: 4, current value is: %d \n", cpu_top1.ram1.RAM[1]);
         run_one_instruction;
      $display("beq has been executed, value of pc should be: 10, current value is: %d \n", cpu_top1.pc1.pc_addr);
         run_one_instruction;
      $display("jal should be executed if beq is correct\n"); 
      $display("if beq is correct, value at the third address of data_RAM should be 0, current value is: %d \n", cpu_top1.ram1.RAM[2]);
      $display("if jal was executed, x9 should be: 11, current value is: %d \n", cpu_top1.register1.registerfile[9]);
      $display("value of pc should be: 12, current value is: %d \n", cpu_top1.pc1.pc_addr);
         run_one_instruction;
      $display("if jal is correct, value at the fourth address of data_RAM should be 0, current value is: %d \n", cpu_top1.ram1.RAM[3]);
         run_one_instruction;
      $display("if halt is correct, value at the fifth address of data_RAM should be 0, current value is: %d \n", cpu_top1.ram1.RAM[3]);
      $stop;
    end

  task run_one_instruction;
     begin
        run=1'b0;
    #2  run=1'b1;
    #6  run=1'b0;
    #16 run=1'b0;
     end
  endtask

  assign clk1=clk&executing;

  always @(negedge clk or posedge rst)
    begin
      if(rst==1)
        begin
          state<=3'b000;
          executing<=1'b0;
        end
      else
        begin
          case(state)
            3'b000:
               begin
                 if (run==1)
                   begin
                     executing<=1'b1;
                     state<=3'b001;
                   end
                 else
                   begin
                     state<=3'b000;
                   end
               end
            3'b001:
               begin
                 state<=3'b010;   //first clock finished
               end
            3'b010:
               begin
                 state<=3'b011;  //second clock finished
               end
            3'b011:
               begin
                 state<=3'b100;  //third clock finished
               end
            3'b100:
               begin
                 state<=3'b101;  //fourth clock finished                 
               end
            3'b101:
               begin
                 state<=3'b110;  //fifth clock finished                 
               end
            3'b110:
               begin
                 state<=3'b000;  //sixth clock finished 
                 executing<=1'b0;                
               end
          endcase
        end
    end
endmodule
