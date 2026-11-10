module seq_mult (
	input rst,
	input clk,
	//Dados
	input		[3:0] a,
	input		[3:0] b,
	output 	[7:0] m,
	//Entradas do usuário
	input		start,
	//Saídas para o usuário
	output	done
);

	wire load, clear, zero;

	mult_fsm fsm (
		.rst(rst),
		.clk(clk),
		//Sinais de estado (datapath)
		.zero(zero),
		//Sinais de entrada (do usuário)
		.start(start),
		//Sinais de controle (datapath)
		.load(load),
		.clear(clear),
		//Sinais de saída (para o usuário)
		.done(done)

	);
	
	mult_datapath dp (
		.clk(clk),
		//Dados
		.a(a),
		.b(b),
		.m(m),
		//Sinais de controle
		.load(load),
		.clear(clear),
		//Sinais de estado
		.zero(zero)
	);

endmodule
