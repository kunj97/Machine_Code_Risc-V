module labK; 

reg a,b,c,expect, flag;
wire nop, li;
wire fao, fai;
wire sao, sai;
integer i,j,k; 

not (nop,c);
and (fao, a, li);
and (sao, c, b); 
or (z, fai,sao);
assign li = nop; 
assign fai = fao;
assign sai=sao;

initial 
begin
        for ( i = 0 ;i < 2 ;i = i+1 ) 
                begin
            for (j = 0; j < 2;j = j+1)
                begin
            for (k = 0 ; k < 2 ; k = k +1 ) 
                begin
              a=i;
              b=j;
              c=k;

    expect = c ? b : a; 


    #1;
    if (z === expect)
    $display("PASS: a=%b b=%b c=%b z=%b",a , b, c ,z);
    else
    $display("PASS: a=%b b=%b c=%b z=%b",a , b, c ,z);

    end
    end
    end
    
    $finish; 

end
endmodule 