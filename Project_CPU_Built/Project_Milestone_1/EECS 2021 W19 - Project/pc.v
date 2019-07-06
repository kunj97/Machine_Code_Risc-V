module pc(input rst, input inc_pc, input jump, input branch, input[31:0] jump_addr, input[31:0] branch_addr, output[31:0] pc_addr, output[31:0] pc_addr_plus);
   reg[31:0] pc_addr_r; //reg type of the output wire pc_addr

   assign pc_addr_plus=pc_addr+1'b1; //pc_addr_plus is always  pc_addr+1
   assign pc_addr=pc_addr_r; //connect the register output to wire pc_addr

   always @(posedge inc_pc or posedge rst)
       begin
          if(rst==1) //if reseting , initialize the pc_address to zero
            begin
              pc_addr_r<=32'h00000000;
            end
          else
            begin
              if(jump==1'b1)  //jump instruction, pc_addr_plus=pc_addr+1; and pc_addr=jump_addr;
                begin
                  pc_addr_r<=jump_addr; //update pc_addr with the jump target address
                end                        
              if(branch==1'b1)
                begin
                  pc_addr_r<=branch_addr;      //if a branch instruction is encountered, then update the pc_addr with the target branch_addr
                end
              if ((jump==1'b0)&&(branch==1'b0)) // if it is a normal instruction, e.g. nor jump neither branch
                begin
                  pc_addr_r<=pc_addr_plus;   //update pc_addr with its previouse value +1'b1
                end 
            end
       end
endmodule
//Mar. 3, 2019, Yang Zhao , EECS2021, YorkU