`include "router.v"
module gold_ring(reset, clk, node0_pesi, node0_peri, node0_pedi, node0_peso, node0_pero, node0_pedo, 
							   node1_pesi, node1_peri, node1_pedi, node1_peso, node1_pero, node1_pedo,
							   node2_pesi, node2_peri, node2_pedi, node2_peso, node2_pero, node2_pedo,
							   node3_pesi, node3_peri, node3_pedi, node3_peso, node3_pero, node3_pedo,
							   node0_polarity, node1_polarity, node2_polarity, node3_polarity
							   );
input reset, clk, node0_pesi, node0_pero, node1_pesi, node1_pero, node2_pesi, node2_pero, node3_pesi, node3_pero;
input [63:0] node0_pedi, node1_pedi, node2_pedi, node3_pedi;
output node0_peri, node0_peso, node0_polarity, node1_peri, node1_peso, node1_polarity, node2_peri, node2_peso, node2_polarity, node3_peri, node3_peso, node3_polarity;
output [63:0] node0_pedo, node1_pedo, node2_pedo, node3_pedo;

wire node30_cws, node03_cwr, node10_ccws, node01_ccwr, node01_cws, node10_cwr, node03_ccws, node30_ccwr,
	 node12_cws, node21_cwr, node21_ccws, node12_ccwr, node23_cws, node32_cwr, node32_ccws, node23_ccwr;
wire [63:0] node30_cwd, node10_ccwd, node01_cwd, node03_ccwd, node21_ccwd, node12_cwd, node32_ccwd, node23_cwd;

router U0(clk, reset, node30_cws, node03_cwr, node30_cwd, node10_ccws, node01_ccwr, node10_ccwd, node0_pesi, node0_peri, node0_pedi, 
		  node01_cws, node10_cwr, node01_cwd, node03_ccws, node30_ccwr, node03_ccwd, node0_peso, node0_pero, node0_pedo, node0_polarity);
router U1(clk, reset, node01_cws, node10_cwr, node01_cwd, node21_ccws, node12_ccwr, node21_ccwd, node1_pesi, node1_peri, node1_pedi, 
		  node12_cws, node21_cwr, node12_cwd, node10_ccws, node01_ccwr, node10_ccwd, node1_peso, node1_pero, node1_pedo, node1_polarity);
router U2(clk, reset, node12_cws, node21_cwr, node12_cwd, node32_ccws, node23_ccwr, node32_ccwd, node2_pesi, node2_peri, node2_pedi, 
		  node23_cws, node32_cwr, node23_cwd, node21_ccws, node12_ccwr, node21_ccwd, node2_peso, node2_pero, node2_pedo, node2_polarity);
router U3(clk, reset, node23_cws, node32_cwr, node23_cwd, node03_ccws, node30_ccwr, node03_ccwd, node3_pesi, node3_peri, node3_pedi, 
		  node30_cws, node03_cwr, node30_cwd, node32_ccws, node23_ccwr, node32_ccwd, node3_peso, node3_pero, node3_pedo, node3_polarity);
endmodule
