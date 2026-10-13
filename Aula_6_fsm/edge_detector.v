`define STATE_UP      2'b00
`define UP            2'b00
`define PRESS         2'b01
`define DOWN          2'b10
`define RELEASE       2'b11

module edge_detector(
    input clk,
    input rst,
    input button,
    output but_press,
    output but_release
);
	reg [1:0] state;
	reg [1:0] nextState;
	
	always @(posedge clk) begin
		if(rst)
			state <= `STATE_UP;
		else
			state <= nextState;
	end
	
	always @(*) begin
		case(state)
			`UP: 			nextState = button ? `PRESS : `UP;
			`PRESS: 		nextState = `DOWN;
			`DOWN: 		nextState = button ? `DOWN : `RELEASE;
			`RELEASE: 	nextState = `UP;
		endcase
	end

	assign but_press = (state == `PRESS);
	assign but_release = (state == `RELEASE);

endmodule 