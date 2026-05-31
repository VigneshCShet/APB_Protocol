`default_nettype none
module apb4_mux(PADDR, MST_PSEL, SLV_PREADY1, SLV_PRDATA1, SLV_PREADY2, SLV_PRDATA2, MST_PREADY, MST_PRDATA, SLV_PSEL1, SLV_PSEL2, MST_PSLVERR, SLV_PSLVERR1, SLV_PSLVERR2);
  input wire  MST_PSEL, SLV_PREADY1, SLV_PREADY2;
  input wire [8:0] PADDR;
  input wire [7:0] SLV_PRDATA1, SLV_PRDATA2;
  input wire SLV_PSLVERR1, SLV_PSLVERR2; 
  output reg MST_PREADY, SLV_PSEL1, SLV_PSEL2;
  output reg [7:0] MST_PRDATA;
  output wire MST_PSLVERR;

  assign MST_PSLVERR = PADDR[8] ? SLV_PSLVERR2 : SLV_PSLVERR1;
  always @(*) begin
    if(MST_PSEL) begin
			if(PADDR[8]) begin
				SLV_PSEL1 = 0;
				SLV_PSEL2 = 1;
				MST_PREADY = SLV_PREADY2;
				MST_PRDATA = SLV_PRDATA2;
			end
			else begin
				SLV_PSEL1 = 1;
				SLV_PSEL2 = 0;
				MST_PREADY = SLV_PREADY1;
				MST_PRDATA = SLV_PRDATA1;
			end
		end
		else begin
			SLV_PSEL1 = 0;
			SLV_PSEL2 = 0;
			MST_PREADY = 0;
			MST_PRDATA = 0;
		end
  end
endmodule
