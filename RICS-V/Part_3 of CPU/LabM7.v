module labM; 
reg [31:0]Pcin;
reg clk;
wire [31:0]ins, PCp4;

yIF myIF (ins, PCp4, PCin, clk);

initial 

begin
  Pcin = 128;
end

repeat (11)
begin
clk = 1;
#1;
clk = 0;
#1;

$display("instruction = %h", ins);
PCin = PCp4;
end
$finish;
end
endmodule 

