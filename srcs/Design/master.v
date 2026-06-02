`default_nettype none
module master#(parameter addr_width = 9, data_width = 8)(PCLK, PRESETn, transfer, READ_WRITE, apb_write_paddr, apb_write_data, apb_read_paddr,PREADY, PRDATA, apb_read_data_out, PWRITE, PSEL, PENABLE, PADDR, PWDATA, PSLVERR_MUX, PSLVERR);
  // Inputs
	input wire PCLK, PRESETn, transfer, READ_WRITE, PREADY;
	input wire [addr_width-1:0] apb_write_paddr, apb_read_paddr;
	input wire [data_width-1:0] apb_write_data, PRDATA;
	input wire PSLVERR_MUX;

	// Outputs
	output wire PSLVERR;
	output reg [addr_width-1:0] PADDR;
	output reg [data_width-1:0] PWDATA;
	output reg PWRITE, PSEL, PENABLE;
  output reg [data_width-1:0] apb_read_data_out;
	localparam IDLE = 3'b001, SETUP = 3'b010, ACCESS = 3'b100;
  
	// State registers
	reg [2:0] cs, ns;

	assign PSLVERR = PSLVERR_MUX;
	
	// State transition and output logic
	always @(posedge PCLK or negedge PRESETn) begin
		if(!PRESETn) begin
				PADDR <= 0;
				PWDATA <= 0;
				PWRITE <= 0;
				cs <= IDLE;
		end

		else begin
			cs <= ns;

			if (((cs == IDLE)  && transfer ) || ((cs == ACCESS) && PREADY  && transfer)) begin
				
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
		end
	end

	// Next state logic and output control
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
  
  // Output control logic based on state
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
	always @(*) begin
		if (!PSLVERR_MUX) begin
			apb_read_data_out = PRDATA;
		end
	end

endmodule
