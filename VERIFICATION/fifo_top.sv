
`timescale 1ns/1ps

`include "uvm_macros.svh"
`include "fifo_defines.svh"
`include "fifo_interface.sv"
`include "fifo_design.sv"
`include "ram_fifo.sv"

// Import UVM and custom TB packages
import uvm_pkg::*;

import fifo_tst_pkg::*; // Imports test definitions and UVM component classes

module tb_top;

  bit clk;
  always #5 clk = ~clk;

  fifo_inf vif(clk);

  // Instantiated DUT module (compiled outside package)
 syn_fifo #(
    .DATA_WIDTH(`DW),
    .ADDR_WIDTH(`AW)
  ) dut (
    .clk      (vif.clk),
    .rst      (vif.rst),
    .wr_cs    (vif.wr_cs),
    .rd_cs    (vif.rd_cs),
    .wr_en    (vif.wr_en),
    .rd_en    (vif.rd_en),
    .data_in  (vif.data_in),
    .data_out (vif.data_out),
    .full     (vif.full),
    .empty    (vif.empty)
  );

  initial begin
    uvm_config_db#(virtual fifo_inf)::set(null, "*", "fifo_inf", vif);
    run_test("test1");
 end

endmodule
