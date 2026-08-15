class fifo_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(fifo_scoreboard)

	uvm_tlm_analysis_fifo#(fifo_transaction)in_fifo;

	bit [7:0] fifo_store[$];
	bit [7:0] expected_out;
	bit read_en;
	bit exp_full;
	bit exp_empty;
	int pass;
	int fail;
	int pass_flag;
	int fail_flag;

	function new(string name="fifo_scoreboard",uvm_component parent);
		super.new(name,parent);
		in_fifo =new("in_fifo",this);
	endfunction

	task run_phase(uvm_phase phase);
		fifo_transaction tr_in;
		fifo_transaction tr;
		forever
		begin

//		fifo_transaction tr;
		in_fifo.get(tr_in);

		if(!$cast(tr,tr_in.clone()))
		begin
			`uvm_fatal("SCB","clone failed")
		end

		if(tr.rst)
		begin
			fifo_store.delete();
			read_en=0;
			pass=0;
			fail=0;
			pass_flag=0;
			fail_flag=0;

			if(tr.empty==1'b1 && tr.full==1'b0)
			begin
				pass_flag++;
//				`uvm_info("scoreboard_reset",$sformatf("RESET MATCH:::::::Exp_out:empty=1,full=0 | Act_out: empty:%b,full:%b ",tr.empty,tr.full),UVM_LOW)
			end
			else
			begin
				fail_flag++;
//				`uvm_info("scoreboard_reset","RESET MISMATCH",UVM_LOW)
			end




		end

		else
		begin
/*			if(fifo_store.size()===0)
				exp_empty=1'b1;
			if(fifo_store.size()==`DEPTH)
				exp_full=1'b1;*/

			exp_empty=(fifo_store.size()==0);
			exp_full=(fifo_store.size()==`DEPTH);

			if(tr.empty==exp_empty)
			begin
				pass_flag++;
				//`uvm_info("scoreboard_empty_flag","EMPTY FLAG MATCH",UVM_LOW)
//				`uvm_info("scoreboard_reset",$sformatf("EMPTY_FLAG MATCH:::::::Exp_out:empty=%b | Act_out: empty:%b ",
//					exp_empty,tr.empty),UVM_LOW)
			end
			else
			begin
				fail_flag++;
				//`uvm_info("scoreboard_EMPTY_flag","EMPTY FLAG MISSMATCH",UVM_LOW)
				//`uvm_info("scoreboard_reset",$sformatf("EMPTY_FLAG MATCH:::::::Exp_out:empty=1,full=0 | Act_out: empty:%b,full:%b ",tr.empty,tr.full),UVM_LOW)
//				`uvm_info("scoreboard_empty_flag",$sformatf("EMPTY_FLAG MISSMATCH:::::::Exp_out:empty=%b | Act_out: empty:%b",exp_empty,tr.empty),UVM_LOW)
			end

			
			if(tr.full==exp_full)
			begin
				pass_flag++;
				//`uvm_info("scoreboard_full_flag","FULL FLAG MATCH",UVM_LOW)
				//`uvm_info("scoreboard_reset",$sformatf("FULL_FLAG MATCH:::::::Exp_out:empty=1,full=0 | Act_out: empty:%b,full:%b ",tr.empty,tr.full),UVM_LOW)
//				`uvm_info("scoreboard_full_flag",$sformatf("FULL_FLAG MATCH:::::::Exp_out:full=%b | Act_out:full:%b ",
//					exp_full,tr.full),UVM_LOW)
			end
			else
			begin
				fail_flag++;
			//	`uvm_info("scoreboard_full_flag","FULL FLAG MISSMATCH",UVM_LOW)
				//`uvm_info("scoreboard_reset",$sformatf("FULL_FLAG MATCH:::::::Exp_out:empty=1,full=0 | Act_out: empty:%b,full:%b ",tr.empty,tr.full),UVM_LOW)
//				`uvm_info("scoreboard_full_flag",$sformatf("FULL_FLAG MISSMATCH:::::::Exp_out:full=%b | Act_out:full:%b ",
//					exp_full,tr.full),UVM_LOW)
			end

		
		read_en=(tr.rd_cs&&tr.rd_en&&(!tr.empty));

		if(read_en)
		begin
			if(fifo_store.size()!=0)
			begin
				expected_out=fifo_store.pop_front();
				if(tr.data_out==expected_out)
				begin
					`uvm_info("Scoreboard",$sformatf("MATCH :::::::::: Exp_out:%h | Data_out:%h :::::::::: ",expected_out,
						tr.data_out),UVM_LOW)
					pass++;
				end
				else
				begin
					`uvm_info("Scoreboard",$sformatf("MISSMATCH :::::::::: Exp_out:%h | Data_out:%h :::::::::: ",
						expected_out,tr.data_out),UVM_LOW)
					fail++;
				end
			end
		end
		


		if(tr.wr_cs&&tr.wr_en&&(!tr.full))
		begin
			fifo_store.push_back(tr.data_in);
		end

		//read_en=(tr.rd_cs&&tr.rd_en&&(!tr.empty));

		end
		end
	endtask


	function void report_phase(uvm_phase phase);
    		super.report_phase(phase);
    		`uvm_info("Scoreboard", $sformatf("\n=========================================\n  FINAL SCOREBOARD SUMMARY\n  TOTAL PASSED : %0d\n  TOTAL FAILED : %0d\n TOTAL PASS_FLAG :%0d \n TOTAL FAIL_FLAG :%0d \n=========================================", pass, fail,pass_flag,fail_flag), UVM_LOW)
 	 endfunction

endclass

				




