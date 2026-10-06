`define STATE_CLOSED 	2'b00
`define STATE_CLOSING 	2'b01
`define STATE_OPEN 		2'b10
`define STATE_OPENING 	2'b11

module fsm_gate_ctrl(
	input rst,
	input clk,
	//Sinais de controle
	input user_button,
	input end_stop,
	input start_stop,
	//Saidas
	output reg motor_power,
	output reg motor_direction
);
	
	reg [1:0] state;
	reg [1:0] next_state;
	
	//motor de estados
	always @(posedge clk) begin
		if(rst) begin //reset sincrono, só acontece na borda de subida do clck
			state <= `STATE_CLOSED;
		end else begin
			state <= next_state;
		end
	end
	
	//logica de transição
	always @(*) begin
		case(state)
			`STATE_CLOSED: begin
				if(user_button == 1'b0) begin
					next_state = `STATE_CLOSED;
				end else begin
					next_state = `STATE_OPENING;
				end
			end
			`STATE_OPEN: begin
				if(user_button == 1'b0) begin
					next_state = `STATE_OPEN;
				end else begin
					next_state = `STATE_CLOSING;
				end
			end
			`STATE_OPENING: begin
				if(end_stop == 1'b0) begin
					next_state = `STATE_OPENING;
				end else begin
					next_state = `STATE_OPEN;
				end
			end
			`STATE_CLOSING: begin
				if(start_stop == 1'b0) begin
					next_state = `STATE_CLOSING;
				end else begin
					next_state = `STATE_CLOSED;
				end
			end
		endcase
	end
	
	//logica de saida
	always @(*) begin
		if(state == `STATE_CLOSING || state == `STATE_OPENING)
			motor_power = 1;
		else
			motor_power = 0;
			
		if(state == `STATE_OPENING)
			motor_direction = 1;
		else
			motor_direction = 0;
	end

endmodule 