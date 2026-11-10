module basic_ram 
#(
	parameter ADDR_LEN = 10,
	parameter SIZE = 1 << ADDR_LEN
)
(
	input			clk, //Memória síncrona
	//Porta de escrita
	input					wr_enable,
	input			[7:0] wr_data,
	input			[ADDR_LEN-1:0]	wr_addr,
	
	//Porta de leitura
	output reg	[7:0] rd_data,
	input			[ADDR_LEN-1:0] rd_addr
);

	//Vetor de memória
	reg [7:0] buffer [SIZE-1:0];
	
	initial begin
		buffer[0] = 8'd10;
		buffer[0] = 8'd20;
		buffer[0] = 8'd40;
		buffer[0] = 8'b10100110;
	end
	
	always @(posedge clk) begin
		if(wr_enable) begin
			buffer[wr_addr] <= wr_data;	//Escrita síncrona
		end
		rd_data <= buffer[rd_addr];	//Leitura síncrona
	end

endmodule
