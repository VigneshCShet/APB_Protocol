`default_nettype none
module slave#(parameter addr_width = 8, data_width = 8, depth = 256)(PCLK, PRESETn, PENABLE, PWRITE, PWDATA, PADDR, SLV_PSEL, SLV_PREADY, SLV_PRDATA, PSLVERR);
	// Inputs
	input wire PCLK, PRESETn, PENABLE, PWRITE, SLV_PSEL;
	input wire [data_width-1:0] PWDATA;
	input wire [addr_width-1:0] PADDR;
	output wire SLV_PREADY;
	output reg [data_width-1:0] SLV_PRDATA;
	output wire PSLVERR;

	// Memory array
	reg[data_width-1:0] ram [0:depth-1]; 

	integer i;

	assign SLV_PREADY = SLV_PSEL; // Always ready when selected
	assign PSLVERR = (PADDR[addr_width - 1 : 0] >= depth) ? 1'b1 : 1'b0; // Error if address is out of bounds

	// Sequential logic for read/write operations
	always @(posedge PCLK or negedge PRESETn) begin
		if(!PRESETn) begin
			for(i = 0; i < depth; i = i + 1) begin
				ram[i] <= 0;
			end
				SLV_PRDATA <= 0;
		end
		else begin
			if(SLV_PSEL && PENABLE) begin
				if(PWRITE) begin
					ram[PADDR[addr_width-1:0]] <= PWDATA;
				end
				else begin
					SLV_PRDATA <= ram[PADDR[addr_width-1:0]];
				end
			end
		end
	end

endmodule
