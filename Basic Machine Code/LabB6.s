main: 

add x6,x0,x0

loop:

slti x7,x6,5
beq x7,x0,exit 
ecall x0,x6,0
addi x6,x6,1
jal x1, loop 

exit: 
