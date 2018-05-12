module router(clk, reset, cwsi, cwri, cwdi, ccwsi, ccwri, ccwdi, pesi, peri, pedi, cwso, cwro, cwdo, ccwso, ccwro, ccwdo, peso, pero, pedo, polarity);
input clk, reset, cwsi, ccwsi, pesi, cwro, ccwro, pero;
input [63:0] cwdi, ccwdi, pedi;
output reg cwso, ccwso, peso, cwri, ccwri, peri, polarity;
output reg [63:0] cwdo, ccwdo, pedo;
reg [63:0]cw_even, cw_odd, ccw_even, ccw_odd, pe_even, pe_odd;
reg flag_cw_even, flag_cw_odd, flag_ccw_even, flag_ccw_odd, flag_pe_even, flag_pe_odd, flag_cw, flag_ccw, flag_pe,
 cw_p, ccw_p, pe_p;


 
//handshaking signals
always @(posedge clk, polarity, cwro, ccwro, pero, flag_cw, flag_ccw, flag_pe)
begin
	if(reset)
		begin
			cwri <= 1;
			ccwri <= 1;
			peri <= 1;
			cwso <= 0;
			ccwso <= 0;
			peso <= 0;		
		end
	else
		begin
			cwso <= flag_cw & cwro;
			ccwso <= flag_ccw & ccwro;
			peso <= flag_pe & pero;
			cwri <= polarity ? ~flag_cw_odd : ~flag_cw_even;
			ccwri <= polarity ? ~flag_ccw_odd : ~flag_ccw_even;
			peri <= polarity ? ~flag_pe_odd : ~flag_pe_even;
		end
end
always @(posedge clk)
begin
	if(reset)
		begin
			polarity <= 0;
			flag_cw_even <= 0;
			flag_cw_odd <= 0;
			flag_ccw_even <= 0;
			flag_ccw_odd <= 0;
			flag_pe_even <= 0;
			flag_pe_odd <= 0;
			flag_cw <= 0;
			flag_ccw <= 0;
			flag_pe <= 0;
			cw_p <= 0;
			ccw_p <= 0;
			pe_p <= 0;
			cwdo <= 64'bx;
			ccwdo<= 64'bx;
			pedo <= 64'bx;
		end
	else
		begin
			polarity <= ~polarity;
			if(polarity)
				begin
					if(cwsi)
						begin
							if(~flag_cw_odd)
								begin
									cw_odd <= {cwdi[63:56],1'b0,cwdi[55:49],cwdi[47:0]};
									flag_cw_odd <= 1;
								end
						end
					if(ccwsi)
						begin
							if(~flag_ccw_odd)
								begin
									ccw_odd <= {ccwdi[63:56],1'b0,ccwdi[55:49],ccwdi[47:0]};
									flag_ccw_odd <= 1;
								end
						end
					if(pesi)
						begin
							if(~flag_pe_odd)
								begin
									pe_odd <= {pedi[63:56],1'b0,pedi[55:49],pedi[47:0]};
									flag_pe_odd <= 1;
								end
						end
					if(cwro | ((~cwro) & (~flag_cw)))
						begin
							if(cw_p & flag_pe_even & ~pe_even[62]) // cw_p 0 for cw, 1 for pe;
								begin
									cwdo <= pe_even;	
									cw_p <= ~cw_p;
									flag_pe_even <= 0;
									flag_cw <= 1;
								end
							else if(((~flag_cw_even) | (flag_cw_even & (~cw_even[48]))) & (~cw_p) & flag_pe_even & (~pe_even[62]))
								begin
									cwdo <= pe_even;
									flag_pe_even <= 0;									
									flag_cw <= 1;
								end
							else if(flag_cw_even & cw_even[48])
								begin
									cwdo <= cw_even;
									flag_cw_even <= 0;
									flag_cw <= 1;
									if(~cw_p)
										cw_p <= ~cw_p;
								end
							else
								flag_cw <= 0;
						end
					if(ccwro | ((~ccwro) & (~flag_ccw)))
						begin
							if(ccw_p & flag_pe_even & pe_even[62]) // cw_p 0 for ccw, 1 for pe;
								begin
									ccwdo <= pe_even;	
									flag_pe_even <= 0;
									ccw_p <= ~ccw_p;
									flag_ccw <= 1;
								end
							else if(((~flag_ccw_even) | (flag_ccw_even & (~ccw_even[48]))) & (~ccw_p) & flag_pe_even & pe_even[62])
								begin
									ccwdo <= pe_even;
									flag_pe_even <= 0;									
									flag_ccw <= 1;
								end
							else if(flag_ccw_even & ccw_even[48])
								begin
									ccwdo <= ccw_even;
									flag_ccw_even <= 0;
									flag_ccw <= 1;
									if(~ccw_p)
										ccw_p <= ~ccw_p;
								end
							else
								flag_ccw <= 0;
						end
					if(pero | ((~pero) & (~flag_pe)))
						begin
							if(pe_p & flag_ccw_even & (~ccw_even[48]))
								begin
									pedo <= ccw_even;
									flag_ccw_even <= 0;									
									pe_p <= ~pe_p;
									flag_pe <= 1;
								end
							else if ((~pe_p) & flag_ccw_even & (~ccw_even[48]) & ((flag_cw_even & cw_even[48]) | (~flag_cw_even)))
								begin
									pedo <= ccw_even;
									flag_ccw_even <= 0;
									flag_pe <= 1;
								end
							else if (flag_cw_even & (~cw_even[48]))
								begin
									pedo <= cw_even;
									flag_cw_even <= 0;
									flag_pe <= 1;
									if(~pe_p)
										pe_p <= ~pe_p;
								end
							else
								flag_pe <= 0;
						end
				end
			else
				begin
					if(cwsi & (~flag_cw_even))
						begin
							cw_even <= {cwdi[63:56],1'b0,cwdi[55:49],cwdi[47:0]};
							flag_cw_even <= 1;
						end
					if(ccwsi & (~flag_ccw_even))
						begin
							ccw_even <= {ccwdi[63:56],1'b0,ccwdi[55:49],ccwdi[47:0]};
							flag_ccw_even <= 1;
						end
					if(pesi & (~flag_pe_even))
						begin
							pe_even <= {pedi[63:56],1'b0,pedi[55:49],pedi[47:0]};
							flag_pe_even <= 1;
						end
					if(cwro | ((~cwro) & (~flag_cw)))
						begin
							if(cw_p & flag_pe_odd & (~pe_odd[62])) // cw_p 0 for cw, 1 for pe;
								begin
									cwdo <= pe_odd;	
									flag_pe_odd <= 0;
									cw_p <= ~cw_p;
									flag_cw <= 1;
								end
							else if(((~flag_cw_odd) | (flag_cw_odd & (~cw_odd[48]))) & (~cw_p) & flag_pe_odd & (~pe_odd[62]))
								begin
									cwdo <= pe_odd;	
									flag_pe_odd <= 0;
									flag_cw <= 1;
								end
							else if(flag_cw_odd & cw_odd[48])
								begin
									cwdo <= cw_odd;
									flag_cw_odd <= 0;
									flag_cw <= 1;
									if(~cw_p)
										cw_p <= ~cw_p;
								end
							else
								flag_cw <= 0;
						end
					if(ccwro | ((~ccwro) & (~flag_ccw)))
						begin
							if(ccw_p & flag_pe_odd & pe_odd[62]) // cw_p 0 for ccw, 1 for pe;
								begin
									ccwdo <= pe_odd;
									flag_pe_odd <= 0;									
									ccw_p <= ~ccw_p;
									flag_ccw <= 1;
								end
							else if(((~flag_ccw_odd) | (flag_ccw_odd & (~ccw_odd[48]))) & (~ccw_p) & flag_pe_odd & pe_odd[62])
								begin
									ccwdo <= pe_odd;
									flag_pe_odd <= 0;									
									flag_ccw <= 1;
								end
							else if(flag_ccw_odd & ccw_odd[48])
								begin
									ccwdo <= ccw_odd;
									flag_ccw_odd <= 0;
									flag_ccw <= 1;
									if(~ccw_p)
										ccw_p <= ~ccw_p;
								end
							else
								flag_ccw <= 0;
						end
					if(pero | ((~pero) & (~flag_pe)))
						begin
							if(pe_p & flag_ccw_odd & (~ccw_odd[48]))
								begin
									pedo <= ccw_odd;
									flag_ccw_odd <= 0;									
									pe_p <= ~pe_p;
									flag_pe <= 1;
								end
							else if ((~pe_p) & flag_ccw_odd & (~ccw_odd[48]) & ((flag_cw_odd & cw_odd[48]) | (~flag_cw_odd)))
								begin
									pedo <= ccw_odd;
									flag_ccw_odd <= 0;									
									flag_pe <= 1;
								end
							else if (flag_cw_odd & (~cw_odd[48]))
								begin
									pedo <= cw_odd;
									flag_cw_odd <= 0;
									flag_pe <= 1;
									if(~pe_p)
										pe_p <= ~pe_p;
								end
							else
								flag_pe <= 0;
						end
				end
				
		end
end
endmodule
