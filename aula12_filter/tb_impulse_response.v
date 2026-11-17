`timescale 100ns/100ns
module tb_impulse_response;

	reg rst, clk;
	reg [11:0] x;
	wire [11:0] y;

	always #5 clk = ~clk; //Clock 1Mhz pra esse timescale de 100ns/100ns
	
	movavg_filter dut(
		.rst(rst), .clk(clk),
		.x(x), .y(y)
	);
	
	initial begin
		rst = 1;
		#15; //Nao pega subida do clock
		rst = 0;
		x = 12'b100000000000;
		#10
		x = 12'b0;
		#50
		$finish;
	end
	
endmodule 