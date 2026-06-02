`default_nettype none
module master(PCLK, PRESETn, transfer, READ_WRITE, apb_write_paddr, apb_write_data, apb_read_paddr,PREADY, PRDATA, apb_read_data_out, PWRITE, PSEL, PENABLE, PADDR, PWDATA, PSLVERR_MUX, PSLVERR);
  // Inputs
	input wire PCLK, PRESETn, transfer, READ_WRITE, PREADY;
	input wire [8:0] apb_write_paddr, apb_read_paddr;
	input wire [7:0] apb_write_data, PRDATA;
	input wire PSLVERR_MUX;

	// Outputs
	output wire PSLVERR;
	output reg [8:0] PADDR;
	output reg [7:0] PWDATA, apb_read_data_out;
	output reg PWRITE, PSEL, PENABLE;
  
	localparam IDLE = 3'b001, SETUP = 3'b010, ACCESS = 3'b100;
  
	// State registers
	reg [2:0] cs, ns;

	assign PSLVERR = PSLVERR_MUX;
	
	always @(posedge PCLK or negedge PRESETn) begin
		if(!PRESETn) begin
				PADDR <= 0;
				PWDATA <= 0;
				apb_read_data_out <= 0;
				PWRITE <= 0;
				cs <= IDLE;
		end

		else begin
			cs <= ns;

			if ((cs == IDLE && transfer) || (cs == ACCESS && PREADY && transfer)) begin
				
				if (!READ_WRITE) begin // Write Operation
					PWRITE   <= ~READ_WRITE;
					PWDATA   <= apb_write_data;
					PADDR    <= apb_write_paddr;					
				end 

				else begin // Read Operation
					PWRITE   <= ~READ_WRITE;
					PADDR    <= apb_read_paddr;				
				end

			end

			if (cs == ACCESS && PREADY && !PWRITE) begin
				apb_read_data_out <= PRDATA;
			end
		end
	end

	always @(*) begin

    case(cs)
      IDLE: begin
        if(transfer)
					ns = SETUP;
				else
					ns = IDLE;
			end

			SETUP: begin
        	ns = ACCESS;
			end

			ACCESS: begin

        if(PREADY && transfer)
          ns = SETUP;

				else if(PREADY && !transfer)
					ns = IDLE;

				else
					ns = ACCESS;

			end

			default: ns = IDLE;

		endcase
	end

	always @(*) begin
		
    case(cs)
      IDLE: begin
        PSEL = 1'b0;
				PENABLE = 1'b0;
			end

			SETUP: begin
        PSEL = 1'b1;
				PENABLE = 1'b0;
			end

			ACCESS: begin
        PSEL = 1'b1;
				PENABLE = 1'b1;
			end

			default: begin
				PSEL = 1'b0;
				PENABLE = 1'b0;
			end

		endcase

	end
endmodule
