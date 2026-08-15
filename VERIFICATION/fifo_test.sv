class fifo_test extends uvm_test;
	`uvm_component_utils(fifo_test)
	fifo_env env;

	function new(string name="fifo_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env=fifo_env::type_id::create("env",this);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		`uvm_info("TOPOLOGY", "Displaying UVM Testbench Topology:", UVM_LOW)
		uvm_top.print_topology();
	endfunction
endclass


class test1 extends fifo_test;
	`uvm_component_utils(test1)

	function new(string name="test1",uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		fifo_rst seq1;
		phase.raise_objection(this);
		`uvm_info("TEST", "Starting FIFO Reset Test", UVM_LOW)
		seq1=fifo_rst::type_id::create("seq1");
		seq1.start(env.agnt.sqr);
		phase.drop_objection(this);
	endtask
endclass

class test2 extends fifo_test;
	`uvm_component_utils(test2)

	function new(string name="test2",uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		fifo_write seq2;
		fifo_rst seq1;
		phase.raise_objection(this);
		`uvm_info("TEST2", "Starting FIFO write Test", UVM_LOW)

		seq1=fifo_rst::type_id::create("seq1");
		seq1.start(env.agnt.sqr);

		seq2=fifo_write::type_id::create("seq2");
		seq2.start(env.agnt.sqr);

		#50;
		phase.drop_objection(this);
	endtask
endclass


class test3 extends fifo_test;
	`uvm_component_utils(test3)

	function new(string name="test3",uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		fifo_read seq3;
		fifo_rst seq1;
		fifo_write seq2;
		phase.raise_objection(this);
		`uvm_info("TEST3", "Starting FIFO read test", UVM_LOW)
		seq1=fifo_rst::type_id::create("seq1");
		seq1.start(env.agnt.sqr);
		
		seq2=fifo_write::type_id::create("seq2");
		seq2.start(env.agnt.sqr);

		seq3=fifo_read::type_id::create("seq3");
		seq3.start(env.agnt.sqr);
		#50;
		phase.drop_objection(this);
	endtask
endclass



































