`timescale 1ns/1ns

module tb_clk_1s;

    reg clk_50M;
    reg rst;        
    wire clk_out;

    clk_1s dut(
        .clk_50M(clk_50M),
        .clk_out(clk_out),
        .rst(rst)
    );

    always #10 clk_50M = ~clk_50M; // Cria clock de 50MHz

    initial begin
        clk_50M = 0;
        rst = 1;
        #2;
        rst = 0;
        #100000000;
        $finish;
    end

endmodule