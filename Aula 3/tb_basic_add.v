`timescale 1us/1us
module tb_basic_add;

	//Sinais
	reg [3:0] a;
	reg [3:0] b;
	wire [4:0] s;
	//Instancia do DUT
	adder_4bits dut (
		.a(a), .b(b), .s(s)
	);
	
	//Estimulos
	initial begin//Executa uma unica vez
		a = 0; b = 0;
		#1
		$monitor("a=%b b=%b s=%b",a ,b ,s);
		#1
		if(s==5'd0)begin
			$monitor("TESTE1: PASS");
		end else begin
			$monitor("TESTE1: FAIL");
		end
		#8
		
		a = 1; b = 1;
		#1
		$monitor("a=%b b=%b s=%b",a ,b ,s);
		#1
		if(s==5'd2)begin
			$monitor("TESTE2: PASS");
		end else begin
			$monitor("TESTE2: FAIL");
		end
		#8
		
		a = 3; b = 5;
		#1
		$monitor("a=%b b=%b s=%b",a ,b ,s);
		#1
		if(s==5'd8)begin
			$monitor("TESTE3: PASS");
		end else begin
			$monitor("TESTE3: FAIL");
		end
		#8
		
		a = 7; b = 9;
		#1
		$monitor("a=%b b=%b s=%b",a ,b ,s);
		#1
		if(s==5'd16)begin
			$monitor("TESTE4: PASS");
		end else begin
			$monitor("TESTE4: FAIL");
		end
		#8
		
		$finish;
	end
	
endmodule 