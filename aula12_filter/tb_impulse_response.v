`timescale 100ns/100ns
module tb_impulse_response;

	reg 	reset;
	reg	clk;
	reg 	signed [11:0] x;
	wire 	signed [11:0] y;
	integer f;

		always #5 clk = ~clk;	//clock 1MHz
		
		movavg_filter dut(
			.reset(reset), .clk(clk), .x(x), .y(y) 
		);
		
		always begin
			#10	$monitor("%d, %d", x, y);
			$fwrite(f, "%d, %d\n", x,y);
		end
		
		//stimuli
		initial begin
			f = $fopen("output.csv","w");
			clk = 0;
			reset = 1;
			#10;	//1 clock cycle
			reset = 0;
			x = 12'b100000000000;
			#10;
			x = 12'd0;
			#100;
			$fclose(f);
			$finish;
		end
			
endmodule
