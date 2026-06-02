`default_nettype none
module apb_protocol#(parameter addr_width = 9, data_width = 8, depth1 = 256, depth2 = 200)(PCLK, PRESETn, transfer, READ_WRITE, apb_write_paddr, apb_write_data, apb_read_paddr, apb_read_data_out, PSLVERR);
  //inputs
  input wire PCLK, PRESETn, transfer, READ_WRITE;
  input wire [addr_width-1:0] apb_write_paddr, apb_read_paddr;
  input wire [data_width-1:0] apb_write_data;
  
  //outputs
  output wire [data_width-1:0] apb_read_data_out;
  output wire PSLVERR;

  // Internal wires
	wire [addr_width-1:0] PADDR;
	wire [data_width-1:0] PWDATA, PRDATA;
	wire PWRITE, PENABLE, PREADY, PSEL;
	wire SLV_PSEL1, SLV_PSEL2, SLV_PREADY1, SLV_PREADY2;
	wire [data_width-1:0] SLV_PRDATA1, SLV_PRDATA2;
	wire PSLVERR1, PSLVERR2;
	wire MST_PSLVERR;
  
  // Instantiations
  master    #(addr_width , data_width) ms (.PCLK(PCLK), .PRESETn(PRESETn), .transfer(transfer), .READ_WRITE(READ_WRITE), .apb_write_paddr(apb_write_paddr), .apb_write_data(apb_write_data), .apb_read_paddr(apb_read_paddr), .PREADY(PREADY), .PRDATA(PRDATA), .apb_read_data_out(apb_read_data_out), .PWRITE(PWRITE), .PSEL(PSEL), .PENABLE(PENABLE), .PADDR(PADDR), .PWDATA(PWDATA), .PSLVERR(PSLVERR), .PSLVERR_MUX(MST_PSLVERR));
  apb4_mux  #(addr_width , data_width) mux (.PADDR(PADDR), .MST_PSEL(PSEL), .SLV_PREADY1(SLV_PREADY1), .SLV_PRDATA1(SLV_PRDATA1), .SLV_PREADY2(SLV_PREADY2), .SLV_PRDATA2(SLV_PRDATA2), .MST_PREADY(PREADY), .MST_PRDATA(PRDATA), .SLV_PSEL1(SLV_PSEL1), .SLV_PSEL2(SLV_PSEL2), .MST_PSLVERR(MST_PSLVERR), .SLV_PSLVERR1(PSLVERR1), .SLV_PSLVERR2(PSLVERR2));
	slave     #(addr_width - 1, data_width, depth1) slave1 (.PCLK(PCLK), .PRESETn(PRESETn), .PENABLE(PENABLE), .PWRITE(PWRITE), .PWDATA(PWDATA), .PADDR(PADDR[addr_width-2:0]), .SLV_PSEL(SLV_PSEL1), .SLV_PREADY(SLV_PREADY1), .SLV_PRDATA(SLV_PRDATA1), .PSLVERR(PSLVERR1));
	slave_2_w #(addr_width - 1, data_width, depth2) slave2 (.PCLK(PCLK), .PRESETn(PRESETn), .PENABLE(PENABLE), .PWRITE(PWRITE), .PWDATA(PWDATA), .PADDR(PADDR[addr_width-2:0]), .SLV_PSEL(SLV_PSEL2), .SLV_PREADY(SLV_PREADY2), .SLV_PRDATA(SLV_PRDATA2), .PSLVERR(PSLVERR2));

endmodule
