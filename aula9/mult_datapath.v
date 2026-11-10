module mult_datapath (
	input 	clk,
	//
	input		[3:0] a,
	input		[3:0] b,
	output	[7:0] m,
	//Sinais de controle
	input 	load,
	input 	clear,
	//Sinais de estado
	output 	zero
);

	reg [7:0] acc;
	reg [7:0] reg_a;
	reg [3:0] reg_b;
	
	wire [7:0] s_out;
	wire acc_enable;
	
	assign acc_enable = reg_b[0];
	assign zero = ((reg_a==7'd0) || (reg_b==4'd0));
	assign m = acc;
	
	ripple_carry_adder #(.BITS(8)) adder (
		.a(reg_a),
		.b(acc),
		.s(s_out)
	);

	//Registrador de shift, operando a
	always @(posedge clk) begin
		if(load) begin
			reg_a <= {4'b0000, a};
		end else begin
			reg_a <= {reg_a[6:0], 1'b0};
		end
	end

	//Registrador de shift, operando b
	always @(posedge clk) begin
		if(load) begin
			reg_b <= b;
		end else begin
			reg_b <= {1'b0, reg_b[3:1]};
		end
	end
	
	//Lógica do acumulador
	always @(posedge clk) begin
		if (clear) begin
			acc <= 0;
		end else begin
			if (acc_enable) begin
				acc <= s_out;
			end
		end
	end

endmodule
