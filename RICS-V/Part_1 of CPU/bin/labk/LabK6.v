module labK; 

reg a,b,c;
wire nop, li;
wire fao, fai;
wire sao, sai;

not (nop,c);
and (fao, a, li);
and (sao, c, b); 
or (z, fai,sao);
assign li = nop; 
assign fai = fao;
assign sai=sao;

initial 
begin
  a = 1;
  b=0;
  c=0;

    #1; 
    $display("a=%b b=%b c=%b z=%b", a, b, c, z); 



end
endmodule 