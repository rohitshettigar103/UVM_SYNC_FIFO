
/*`include "fifo_defines.svh"
import uvm_pkg ::*;
`include "uvm_macros.svh"
`include "fifo_transaction.sv"*/



class fifo_monitor extends uvm_monitor;
	`uvm_component_utils(fifo_monitor);

	function new(string name="fifo_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction

	fifo_transaction tr;
	virtual fifo_inf vif;
	uvm_analysis_port#(fifo_transaction) mon_port;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon_port=new("mon_port",this);
		if(!uvm_config_db#(virtual fifo_inf)::get(this,"","fifo_inf",vif))
			`uvm_fatal("No vif","virtual interface not found")
	endfunction

	task run_phase(uvm_phase phase);
		//@(vif.MON.mon_clk);
		forever
		begin
			tr=fifo_transaction::type_id::create("tr");
			sample(tr);
			`uvm_info("MON", $sformatf("Sampled -> rst:%0b wr_en:%0b rd_en:%0b data_in:0x%0h data_out:0x%0h full:%0b empty:%0b", 
	          	tr.rst, tr.wr_en, tr.rd_en, tr.data_in, tr.data_out, tr.full, tr.empty), UVM_LOW)

			mon_port.write(tr);
		end
	endtask

	task sample(fifo_transaction t);
			@(vif.MON.mon_clk);
			t.rst =vif.MON.mon_clk.rst;
			t.wr_cs =vif.MON.mon_clk.wr_cs;
			t.rd_cs =vif.MON.mon_clk.rd_cs;
			t.wr_en =vif.MON.mon_clk.wr_en;
			t.data_in =vif.MON.mon_clk.data_in;
			t.rd_en=vif.MON.mon_clk.rd_en;
			t.data_out =vif.MON.data_out;
			t.full =vif.MON.mon_clk.full;
			t.empty =vif.MON.mon_clk.empty;
	endtask
endclass



