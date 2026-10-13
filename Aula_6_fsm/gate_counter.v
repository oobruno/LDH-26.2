module gate_counter (
	input rst,
	input clk, //clock 1s
	input enable,
	input dir,
	output [9:0] led_bar,
	output end_stop,
	output start_stop
); //
	// Divisor de clock interno para gerar o pulso de 1 segundo
    reg [25:0] div_count;
    reg clk_1s;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            div_count <= 26'd0;
            clk_1s <= 1'b0;
        end else begin
            if (div_count == 26'd49999999) begin
                div_count <= 26'd0;
                clk_1s <= ~clk_1s;
            end else begin
                div_count <= div_count + 1;
            end
        end
    end

    // Detetor de borda do clock de 1s para avançar 1 passo por segundo
    reg clk_1s_prev;
    wire tick_1s;
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            clk_1s_prev <= 1'b0;
        else
            clk_1s_prev <= clk_1s;
    end
    
    assign tick_1s = (clk_1s && !clk_1s_prev);

    // Sinais do contador de posição da barra (de 0 a 10)
    reg [3:0] count, nextCount;

    // //Motor de estados (Registador síncrono com o clock de 1s e enable)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'd0; // Começa fechado (0 LEDs acesos)
        end else if (tick_1s && enable) begin
            count <= nextCount;
        end
    end
    
    // //Motor do próximo estado (Lógica combinacional)
    always @(*) begin
        nextCount = count; // Mantém por defeito
        
        if (count == 4'd10) begin
            if (dir == 1'b0) // Se estiver a mandar fechar
                nextCount = count - 1;
        end 
        else if (count == 4'd0) begin
            if (dir == 1'b1) // Se estiver a mandar abrir
                nextCount = count + 1;
        end 
        else begin
            if (dir == 1'b1)
                nextCount = count + 1;
            else
                nextCount = count - 1;
        end
    end
    
    // //Motor de saída (Decodificador de posição para os LEDs e sensores)
    // Converte o valor numérico (0 a 10) em barras de LEDs e ativa os fins de curso
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : led_gen
            assign led_bar[i] = (i < count);
        end
    endgenerate

    assign end_stop   = (count == 4'd10); // Atingiu o topo (portão aberto)
    assign start_stop = (count == 4'd0);  // Atingiu a base (portão fechado)

endmodule