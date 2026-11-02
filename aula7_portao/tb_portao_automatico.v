`timescale 1ms/1ms

module tb_portao_automatico;

    reg rst;
    reg clk_1ms;
    reg clk_1s;
    reg user_button;
    reg start_stop;
    reg end_stop;

    wire motor_power;
    wire motor_direction;
    wire is_open;
    wire time_up;

    timer_5s u_timer (
        .clk_1s(clk_1s),
        .rst(rst),
        .enable(is_open),
        .time_up(time_up)
    );

    fsm_gate_ctrl u_fsm (
        .rst(rst),
        .clk(clk_1ms),
        .user_button(user_button),
        .start_stop(start_stop),
        .end_stop(end_stop),
        .time_up(time_up),
        .motor_power(motor_power),
        .motor_direction(motor_direction),
        .is_open(is_open)
    );

    always #1 clk_1ms = ~clk_1ms;
    always #10 clk_1s = ~clk_1s;

    initial begin
        // (Portão fechado)
        clk_1ms = 0;
        clk_1s = 0;
        rst = 1;
        user_button = 0;
        start_stop = 1;
        end_stop = 0;

        // Desativar o reset e começar
        #5 rst = 0;
        
        // Simular o pressionar do botão para o portão começar a ABRIR
        #9 user_button = 1;
        #2  user_button = 0;
        start_stop = 0;
        
        // (estado ABERTO)
        #20 end_stop = 1;
        
        #120; 
        
        // O portão começa a descer
        end_stop = 0;
        
        #30 start_stop = 1; 
        

        #20 $finish;
    end

endmodule