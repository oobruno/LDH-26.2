`define STATE_CLOSED       3'b000
`define STATE_OPENING      3'b001
`define STATE_HALF_OPEN    3'b010
`define STATE_OPEN         3'b011
`define STATE_CLOSING      3'b100
`define STATE_HALF_CLOSED  3'b101

module fsm_gate_ctrl(
    input rst,
    input clk,
    input user_button,
    input start_stop,
    input end_stop,
    input time_up,          
    output reg motor_power,
    output reg motor_direction,
    output reg is_open      
);

    reg [2:0] state;
    reg [2:0] nextState;

    always @(posedge clk) begin
        if(rst)
            state <= `STATE_CLOSED;
        else
            state <= nextState;
    end
    
    always @(*) begin
        nextState = state;
        case(state)
            `STATE_CLOSED: begin
                if (user_button == 1'b0) nextState = `STATE_CLOSED;
                else nextState = `STATE_OPENING;
            end
            `STATE_OPENING: begin
                if (end_stop == 1'b0) begin
                    if (user_button == 1'b1) nextState = `STATE_HALF_OPEN;
                    else nextState = `STATE_OPENING;
                end else nextState = `STATE_OPEN;
            end
            `STATE_HALF_OPEN: begin
                if (user_button == 1'b1) nextState = `STATE_CLOSING;
                else nextState = `STATE_HALF_OPEN;
            end
            `STATE_OPEN: begin
                if (user_button == 1'b1 || time_up == 1'b1) nextState = `STATE_CLOSING;
                else nextState = `STATE_OPEN;
            end
            `STATE_CLOSING: begin
                if (start_stop == 1'b0) begin
                    if (user_button == 1'b1) nextState = `STATE_HALF_CLOSED;
                    else nextState = `STATE_CLOSING;
                end else nextState = `STATE_CLOSED;
            end
            `STATE_HALF_CLOSED: begin
                if (user_button == 1'b1) nextState = `STATE_OPENING;
                else nextState = `STATE_HALF_CLOSED;
            end
            default: nextState = `STATE_CLOSED;
        endcase
    end
    
    always @(*) begin
        motor_power = 0;
        motor_direction = 0;
        is_open = 0;
        
        case(state)
            `STATE_OPENING: begin
                motor_power = 1;    
                motor_direction = 1;
            end
            `STATE_CLOSING: begin
                motor_power = 1;    
                motor_direction = 0;
            end
            `STATE_OPEN: begin
                is_open = 1; 
            end
        endcase
    end
endmodule 