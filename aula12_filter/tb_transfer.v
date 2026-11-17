`timescale 100ns/100ns

module tb_transfer;

	localparam cycles = 10;
	integer f;
	integer i;
	reg 						rst, clk;
	reg 	signed [11:0]	x;
	wire 	signed [11:0]	y;
	
	always #5 clk = ~clk; //Clock 1MHz

	bw2_filter dut (
		.rst(rst), .clk(clk),
		.x(x), .y(y)
	);

	always begin
		#10
		$monitor("%d, %d", x, y);
		$fwrite(f,"%d, %d\n",x,y);
	end
	
	initial begin
		f = $fopen("output.csv","w");
		clk = 0;
		rst = 1;
		x = 12'sd0;
		#10; //1 clock cycle
		rst = 0;
		for(i=0; i<cycles; i=i+1) begin
			#10 x = 12'sd0;
			#10 x = 12'sd1203;
			#10 x = 12'sd1947;
			#10 x = 12'sd1947;
			#10 x = 12'sd1203;
			#10 x = 12'sd0;
			#10 x = -12'sd1204;
			#10 x = -12'sd1948;
			#10 x = -12'sd1948;
			#10 x = -12'sd1204;
		end
		#10
		$fclose(f);
		$finish;
	end
	
endmodule