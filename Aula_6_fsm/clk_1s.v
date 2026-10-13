module clk_1s (
    input rst,
    input clk_50M,
    output reg clk_out
);

    reg [25:0] count;

    always @(posedge clk_50M or posedge rst) begin
        if (rst) begin
            count <= 26'd0;
            clk_out <= 1'b0;
        end else begin
            if (count == 26'd24999999) begin // 25M ciclos para alternar dá 1 segundo de período completo
                count <= 26'd0;
                clk_out <= ~clk_out;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule