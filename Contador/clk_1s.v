module clk_1s(
	input clk_50M,
	input rst,
	output reg clk_out
);
	reg [24:0] count; //33554431 > 25M
	
always @(posedge clk_50M) begin
    if (rst) begin
        count <= 0;          // Reset
        clk_out <= 0;
    end else begin
        count <= count + 1;  // Incremento
        if (count == 25'd24999999) begin
            count <= 0;
            clk_out <= ~clk_out;
        end
    end
end
endmodule 