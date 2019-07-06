main: 

beq x5,x6,XX 	
sub x5,x6,0
ecall x7,x0,0

XX: 
addi x5,x6,0

addi x5,x0,60
jal x1, YY
#addi x6,x0,7
#add x10,x6,x5 

ecall x5,x0,5 
