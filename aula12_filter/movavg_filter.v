module movavg_filter (
	input rst,
	input clk,
	input 	[11:0] x,
	output 	[11:0] y
	
);
	
	reg 	[11:0] x1,x2,x3;
	wire 	[13:0] sum;	
	//Linha de Atraso 
	always @(posedge clk) begin
		if(rst) begin
			x1 <= 0;
			x2 <= 0;
			x3 <= 0;
		end else begin
			x1 <= x;
			x2 <= x1;
			x3 <= x2;
		end
	end
	
	assign sum = (x + x1 + x2 + x3);
	//Saida combinacional
	assign y = sum[13:2]; // Divide por 4 por shift
	
endmodule 