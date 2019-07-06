/* Name: Kunj Patel ID: 214192017*/
module labK; 

reg a,b,c, flag;
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
        flag = $value$plusargs("a=%b", a);
         if (flag === 0) 
            $display("Input A is missing");
        
        flag = $value$plusargs("b=%b", b);
        if (flag === 0)
            $display("Input B is missing");

        flag =$value$plusargs("c=%b", c); 
        if (flag === 0)
            $display("Input C is missing"); 

    #1; 
    $display("a=%b b=%b c=%b z=%b", a, b, c, z); 
    $finish; 

end
endmodule 