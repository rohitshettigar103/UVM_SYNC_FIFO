
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
		forever
		begin
			tr=fifo_transaction::type_id::create("tr");
			sample(tr);
			mon_port.write(tr);
		end
	endtask

	task sample(fifo_transaction t);
			@(vif.MON);
			t.rst =vif.MON.rst;
			t.wr_cs =vif.MON.wr_cs;
			t.rd_cs =vif.MON.rd_cs;
			t.wr_en =vif.MON.rd_en;
			t.data_in =vif.MON.data_in;
			t.rd_en=vif.MON.rd_en;
			t.data_out =vif.MON.data_out;
			t.full =vif.MON.full;
			t.empty =vif.MON.empty;
	endtask
endclass



