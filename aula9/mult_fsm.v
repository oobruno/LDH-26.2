`define STATE_IDLE	2'b00
`define STATE_OP 		2'b01
`define STATE_DONE	2'b10

module mult_fsm (
	input rst,
	input clk,
	//Sinais de estado (vindo do datapath)
	input zero,
	//Sinais de entrada (do usuário)
	input start,
	//Sinais de controle (indo para o datapath)
	output load,
	output clear,
	//Sinais de saída (para o usuário)
	output done
);

	reg [1:0] state;
	reg [1:0] nextState;

	//Motor de estados
	always @(posedge clk) begin
		if(rst)
			state <= `STATE_IDLE;
		else
			state <= nextState;
	end
	
	//Lógica do próximo estado
	always @(*) begin
		case(state)
			`STATE_IDLE: begin
				if (start)
					nextState = `STATE_OP;
				else
					nextState = `STATE_IDLE;
			end
			`STATE_OP: begin
				if (zero)
					nextState = `STATE_DONE;
				else
					nextState = `STATE_OP;
			end
			`STATE_DONE: begin
				nextState = `STATE_DONE;
			end
			default: begin
				nextState = `STATE_IDLE;
			end
		endcase
	end
	
	assign load  = state == `STATE_IDLE;
	assign clear = load;
	assign done	 = state == `STATE_DONE;
	
endmodule
