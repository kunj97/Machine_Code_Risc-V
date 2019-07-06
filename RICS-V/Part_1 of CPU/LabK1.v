module labK;
reg [31:0] x; // a 32-bit register
reg[0:0] one;
reg[1:0] two;
reg[2:0] three; 


initial
begin
  $display($time, " ", x);
  x = 0;
  $display($time, " ", x);
  x = x + 2;
  $display($time, " ", x);
  $display ($time, " %d", x);

$display ("time = %5d, x= 32'hffff0000", $time , x);
 
  one = &x; 
  two = x[1:0];
  three = {one, two}; 
$display("one = %b, two = %b, three = %b", one, two, three); 
  $finish;

end
endmodule
