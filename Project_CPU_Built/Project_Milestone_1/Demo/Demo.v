//module demo(
	//input clk,
	//input [3:0] SW,
	//output [3:0] LED
//);

//assign LED=SW;

//endmodule 
module demo (
	input a,
	input b,
	input c, 
	input d,
	output i,
	output j, 
	output k

);

assign i = a && b && c;

assign j = a || b || c; 

assign k = a ^ b; 

endmodule 
