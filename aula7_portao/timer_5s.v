module timer_5s (
    input clk_1s,
    input rst,
    input enable,
    output reg time_up
);
    reg [2:0] count;

    always @(posedge clk_1s or posedge rst) begin
        if (rst) begin
            count <= 3'd0;
            time_up <= 1'b0;
        end else if (enable) begin
            if (count == 3'd5) begin
                time_up <= 1'b1;
            end else begin
                count <= count + 1'b1;
                time_up <= 1'b0;
            end
        end else begin
            count <= 3'd0; 
            time_up <= 1'b0;
        end
    end
endmodule 