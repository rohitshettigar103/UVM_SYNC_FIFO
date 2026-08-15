
/*`include "fifo_defines.svh"
import uvm_pkg ::*;
`include "uvm_macros.svh"
`include "fifo_transaction.sv"*/

class fifo_driver extends uvm_driver#(fifo_transaction);
	`uvm_component_utils(fifo_driver)

	function new(string name="fifo_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual fifo_inf vif;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual fifo_inf)::get(this,"","fifo_inf",vif))
			`uvm_fatal("No vif","virtual vif not found")
	endfunction

	task run_phase(uvm_phase phase);
		forever begin
			seq_item_port.get_next_item(req);
			/*`uvm_info("DRV", $sformatf("DRIVING ->rst:%0b wr_cs:%0b wr_en:%0b rd_cs:%0b rd_en:%0b data_in:0x%0h/n",req.rst, req.wr_cs, req.wr_en, req.rd_cs, req.rd_en, req.data_in),UVM_LOW)
		*/	drive(req);
			seq_item_port.item_done();
		end
	endtask

	task drive(fifo_transaction tr);
		@(vif.DRV.drv_clk);
		vif.DRV.drv_clk.rst<=tr.rst;
		vif.DRV.drv_clk.wr_cs<=tr.wr_cs;
		vif.DRV.drv_clk.rd_cs<=tr.rd_cs;
		vif.DRV.drv_clk.wr_en<=tr.wr_en;
		vif.DRV.drv_clk.rd_en<=tr.rd_en;
		vif.DRV.drv_clk.data_in<=tr.data_in;
	endtask
endclass


