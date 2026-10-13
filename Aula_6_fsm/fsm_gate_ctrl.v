`define STATE_CLOSED       3'b000

`define STATE_OPENING      3'b001

`define STATE_HALF_OPEN    3'b010

`define STATE_OPEN         3'b011

`define STATE_CLOSING      3'b100

`define STATE_HALF_CLOSED  3'b101



module fsm_gate_ctrl(

    input rst,

    input clk,

    // Sinais de controle

    input user_button,

    input start_stop,

    input end_stop,

    // Saídas

    output reg motor_power,

    output reg motor_direction

);



    reg [2:0] state;

    reg [2:0] nextState;



    // Motor de estados (Síncrono)

    always @(posedge clk) begin

        if(rst) begin

            state <= `STATE_CLOSED;

        end else begin

            state <= nextState;

        end

    end

    

    // Lógica de transição (Combinacional com if-else)

    always @(*) begin

        // Valor por defeito para evitar latches indesejados

        nextState = state;



        case(state)

            `STATE_CLOSED: begin

                if (user_button == 1'b0)

                    nextState = `STATE_CLOSED;

                else

                    nextState = `STATE_OPENING;

            end

            

            `STATE_OPENING: begin

                if (end_stop == 1'b0) begin

                    if (user_button == 1'b1)

                        nextState = `STATE_HALF_OPEN; // Pausa se carregar no botão a meio

                    else

                        nextState = `STATE_OPENING;

                end else begin

                    nextState = `STATE_OPEN;

                end

            end



            `STATE_HALF_OPEN: begin

                if (user_button == 1'b1)

                    nextState = `STATE_CLOSING; // Se carregar de novo, começa a fechar

                else

                    nextState = `STATE_HALF_OPEN;

            end

            

            `STATE_OPEN: begin

                if (user_button == 1'b0)

                    nextState = `STATE_OPEN;

                else

                    nextState = `STATE_CLOSING;

            end

            

            `STATE_CLOSING: begin

                if (start_stop == 1'b0) begin

                    if (user_button == 1'b1)

                        nextState = `STATE_HALF_CLOSED; // Pausa a fechar se carregar no botão

                    else

                        nextState = `STATE_CLOSING;

                end else begin

                    nextState = `STATE_CLOSED;

                end

            end



            `STATE_HALF_CLOSED: begin

                if (user_button == 1'b1)

                    nextState = `STATE_OPENING; // Se carregar de novo, volta a abrir

                else

                    nextState = `STATE_HALF_CLOSED;

            end

            

            default: begin

                nextState = `STATE_CLOSED;

            end

        endcase

    end

    

    // Lógica de saída (Combinacional)

    always @(*) begin

        case(state)

            `STATE_OPENING: begin

                motor_power = 1;    

                motor_direction = 1; // A abrir

            end

            `STATE_CLOSING: begin

                motor_power = 1;    

                motor_direction = 0; // A fechar

            end

            default: begin

                motor_power = 0;

                motor_direction = 0; // Parado (Closed, Open, Half-open, Half-closed)

            end

        endcase

    end

    

endmodule 