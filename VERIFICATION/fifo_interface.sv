`include "fifo_defines.svh"
interface fifo_inf(input logic clk);
	logic rst;
	logic wr_cs;
	logic rd_cs;
	logic wr_en;
	logic rd_en;
	logic [`DW-1:0] data_in;
	logic [`DW-1:0] data_out;
	logic full;
	logic empty;

	clocking drv_clk @(posedge clk);
		default input #1ns output #1ns;
		output rst;
		output wr_cs;
		output rd_cs;
		output wr_en;
		output rd_en;
		output data_in;
		//input data_out;
		//input full;
		//input empty;
	endclocking

	clocking mon_clk @(posedge clk);
		default input #1ns output #1ns;
		input rst;
		input wr_cs;
		input rd_cs;
		input wr_en;
		input rd_en;
		input data_in;
		input data_out;
		input full;
		input empty;
	endclocking

	modport DRV(clocking drv_clk);
	modport MON(clocking mon_clk);

endinterface
