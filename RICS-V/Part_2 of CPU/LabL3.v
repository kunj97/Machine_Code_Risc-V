module LabL;

   reg [31:0] a, b, expect;
   reg c;
   wire [31:0] z;
   integer i, j, k;
   yMux #(.SIZE(32)) mux(z, a, b, c);

   initial
     begin
        repeat (10)
          begin
             a = $random;
             b = $random;
             c = $random % 2;

             expect = c ? b : a;
#1;
             if (z !== expect)
               $display("FAIL: a=%b \n      b=%b \n      c=%b \n      z=%b \n      expect=%b", a, b, c, z, expect);
          end
        $finish;
     end

endmodule
