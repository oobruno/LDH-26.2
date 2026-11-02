module clk_dividers (
    input rst,
    input clk_50M,
    output reg clk_1s,
    output reg clk_1ms
);
    reg [25:0] count_1s;
    reg [15:0] count_1ms;

    always @(posedge clk_50M or posedge rst) begin
        if (rst) begin
            count_1s <= 26'd0;
            clk_1s <= 1'b0;
            count_1ms <= 16'd0;
            clk_1ms <= 1'b0;
        end else begin

            if (count_1s == 26'd24999999) begin 
                count_1s <= 26'd0;
                clk_1s <= ~clk_1s;
            end else begin
                count_1s <= count_1s + 1;
            end
         
            if (count_1ms == 16'd24999) begin
                count_1ms <= 16'd0;
                clk_1ms <= ~clk_1ms;
            end else begin
                count_1ms <= count_1ms + 1;
            end
        end
    end
endmodule 