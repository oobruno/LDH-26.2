`timescale 1us/1us
module full_adder(
	input a,
	input b,		
	input ci,
	output s,
	output co
);

// Modelagem dataflow
	//assign s = (a & b & ci) | (~a & b & ~ci) | (~a & ~b & ci) | (a & b & ~ci);
	//assign co = (a & b) | (ci & b) | (ci & a);

	// Modelagem estrututal
// Saída só pode ligar em wire

// Saída querry out
	wire w1, w2, w3;
	and #2 u1 (w1, a, b);
	and #2 u2 (w2, ci, a);
	and #2 u3 (w3, ci, b);
	or #3 u4 (co, w1, w2, w3);
// Saída de soma
	wire na, nb, nci;
	not #1 u5 (na, a);
	not #1 u6 (nb, b);
	not #1 u7 (nci, ci);
	
	wire w4, w5, w6, w7;
	and #3 u8 (w4, a, b, ci);
	and #3 u9 (w5, na, b, nci);
	and #3 u10 (w6, na, nb, ci);
	and #3 u11 (w7, a, b, nci);
	or #4 u12 (s, w4, w5, w6, w7);
	
endmodule 