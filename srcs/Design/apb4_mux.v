`default_nettype none
module apb4_mux #(parameter addr_width = 9, data_width = 8)(PADDR, MST_PSEL, SLV_PREADY1, SLV_PRDATA1, SLV_PREADY2, SLV_PRDATA2, MST_PREADY, MST_PRDATA, SLV_PSEL1, SLV_PSEL2, MST_PSLVERR, SLV_PSLVERR1, SLV_PSLVERR2);
  // Inputs
  input wire  MST_PSEL, SLV_PREADY1, SLV_PREADY2;
  input wire [addr_width-1:0] PADDR;
  input wire [data_width-1:0] SLV_PRDATA1, SLV_PRDATA2;
  input wire SLV_PSLVERR1, SLV_PSLVERR2; 
  // Outputs
  output reg MST_PREADY, SLV_PSEL1, SLV_PSEL2;
  output reg [data_width-1:0] MST_PRDATA;
  output wire MST_PSLVERR;

  // Address decoding and multiplexing logic
  assign MST_PSLVERR = PADDR[addr_width-1] ? SLV_PSLVERR2 : SLV_PSLVERR1;

  // Multiplexing logic for slave selection and data routing
  always @(*) begin
    if(MST_PSEL) begin
			if(PADDR[addr_width-1]) begin
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
