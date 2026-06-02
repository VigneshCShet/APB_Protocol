`default_nettype none
module slave(PCLK, PRESETn, PENABLE, PWRITE, PWDATA, PADDR, SLV_PSEL, SLV_PREADY, SLV_PRDATA, PSLVERR);
	input wire PCLK, PRESETn, PENABLE, PWRITE, SLV_PSEL;
	input wire [7:0] PWDATA;
	input wire [8:0] PADDR;
	output wire SLV_PREADY;
	output reg [7:0] SLV_PRDATA;
	output wire PSLVERR;

	reg[7:0] ram [0:255]; // 256 bytes of memory
	integer i;

	assign SLV_PREADY = SLV_PSEL; // Always ready when selected
	assign PSLVERR = 0; // No error

	always @(posedge PCLK or negedge PRESETn) begin
		if(!PRESETn) begin
			for(i = 0; i < 256; i = i + 1) begin
				ram[i] <= 0;
			end
			SLV_PRDATA <= 0;
		end
		else begin
      if(SLV_PSEL && PENABLE) begin
				if(PWRITE) begin
					ram[PADDR[7:0]] <= PWDATA;
				end
				else begin
					SLV_PRDATA <= ram[PADDR[7:0]];
				end
			end
		end
	end
endmodule
