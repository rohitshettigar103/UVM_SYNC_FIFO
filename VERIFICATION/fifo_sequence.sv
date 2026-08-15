class fifo_sequence extends uvm_sequence#(fifo_transaction);
	`uvm_object_utils(fifo_sequence);

	function new(string name ="fifo_sequence");
		super.new(name);
	endfunction

endclass


class fifo_rst extends fifo_sequence;
	`uvm_object_utils(fifo_rst)

	function new(string name="fifo_rst");
		super.new(name);
	endfunction


	task body();
		//`uvm_info(
		//start of reset sequence
		for(int i=0;i<1/*$urandom_range(5,10)*/;i++)begin
			req=fifo_transaction::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				rst== 1'b1;
				wr_cs==1'b0;
				rd_cs==1'b0;
				wr_en==1'b0;
				rd_en==1'b0;
				data_in == 'b0;
			})
			else 
				`uvm_fatal("fifo_rst","rst assertion failed")
			finish_item(req);
		end


		req=fifo_transaction::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {
			rst==1'b0;
			wr_en==1'b0;
			rd_en==1'b0;
			wr_cs==1'b0;
			rd_cs==1'b0;
			data_in == 'b0;
		})
		else 
			`uvm_fatal("fifo_rst","rst deassertion failed")
		finish_item(req);
	endtask
endclass

class fifo_write extends fifo_sequence;
	`uvm_object_utils(fifo_write)
	function new(string name="fifo_write");
		super.new(name);
	endfunction

	task body();
		for(int i=0;i<(`DEPTH+1000);i++)
		begin
			req=fifo_transaction::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				rst==1'b0;
				wr_cs==1'b1;
				wr_en==1'b1;
				rd_cs==1'b1;
				rd_en==1'b1;
			})
			else 
				`uvm_fatal("fifo_write","write randomization failed")
			finish_item(req);
		end
	endtask
endclass


class fifo_read extends fifo_sequence;
	`uvm_object_utils(fifo_read)
	function new(string name="fifo_read");
		super.new(name);
	endfunction

	task body();
		for(int i=0;i<(`DEPTH+1000);i++)
		begin
			req=fifo_transaction::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {
				rst==1'b0;
				wr_cs==1'b0;
				wr_en==1'b0;
				rd_cs==1'b1;
				rd_en==1'b1;
				data_in=='b0;
			})
			else 
				`uvm_fatal("fifo_read","read randomization failed")
			finish_item(req);
		end
	endtask
endclass















