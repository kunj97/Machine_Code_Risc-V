main: 

addi x5,x0,-60  
srli x28,x5,2

ecall x28,x5,0

slli x28,x5,1

ecall x28,x5,0

exit: