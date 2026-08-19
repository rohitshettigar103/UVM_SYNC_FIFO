class fifo_subscriber extends uvm_subscriber#(fifo_transaction);
	`uvm_component_utils(fifo_subscriber)

	fifo_transaction tr;

	// Locals to hold sampled values for the covergroup
	bit        rst_v;
	bit        wr_cs_v, wr_en_v;
	bit        rd_cs_v, rd_en_v;
	bit        full_v, empty_v;
	bit [`DW-1:0] data_in_v, data_out_v;

	// ---------------------------------------------------------------
	// Covergroup: sampled explicitly via sample() call, not @(posedge)
	// ---------------------------------------------------------------
	covergroup fifo_cg;
		option.per_instance = 1;

		// Individual control signal coverage
		WR_CS: coverpoint wr_cs_v;
		WR_EN: coverpoint wr_en_v;
		RD_CS: coverpoint rd_cs_v;
		RD_EN: coverpoint rd_en_v;
		FULL:  coverpoint full_v;
		EMPTY: coverpoint empty_v;
		RST:   coverpoint rst_v;

		// Data value coverage - bin into ranges since DW=8 -> 256 values
		DATA_IN: coverpoint data_in_v {
			bins zero    = {0};
			bins max_val = {8'hFF};
			bins low     = {[1:63]};
			bins mid     = {[64:191]};
			bins high    = {[192:254]};
		}

		// --- Crosses that directly target your missing FEC bins ---

		// Targets: FEC Expression ((wr_cs && wr_en) && ~full) needing full=1
		// i.e. attempting a write while FIFO is already full
		WR_WHEN_FULL: cross WR_CS, WR_EN, FULL {
			bins write_attempt_while_full = binsof(WR_CS) intersect {1} &&
			                                 binsof(WR_EN) intersect {1} &&
			                                 binsof(FULL)  intersect {1};
		}

		// Targets: FEC Expression ((rd_cs && rd_en) && ~empty) needing
		// rd_cs=1, rd_en=0 combos, and read attempt while empty
		RD_WHEN_EMPTY: cross RD_CS, RD_EN, EMPTY {
			bins read_attempt_while_empty = binsof(RD_CS) intersect {1} &&
			                                 binsof(RD_EN) intersect {1} &&
			                                 binsof(EMPTY) intersect {1};
			bins rd_cs_asserted_en_low    = binsof(RD_CS) intersect {1} &&
			                                 binsof(RD_EN) intersect {0};
		}

		// Targets: FEC Condition (rd_valid && ~wr_valid) i.e.
		// simultaneous read-only vs write-only vs both vs neither
		RD_WR_INDEPENDENCE: cross RD_CS, WR_CS {
			bins read_only  = binsof(RD_CS) intersect {1} && binsof(WR_CS) intersect {0};
			bins write_only = binsof(RD_CS) intersect {0} && binsof(WR_CS) intersect {1};
			bins both       = binsof(RD_CS) intersect {1} && binsof(WR_CS) intersect {1};
			bins neither    = binsof(RD_CS) intersect {0} && binsof(WR_CS) intersect {0};
		}

		// Back-to-back full/empty transitions (simultaneous write+read at boundary)
		FULL_EMPTY_CROSS: cross FULL, EMPTY {
			bins full_and_not_empty  = binsof(FULL) intersect {1} && binsof(EMPTY) intersect {0};
			bins empty_and_not_full  = binsof(EMPTY) intersect {1} && binsof(FULL) intersect {0};
		}

		// Reset asserted while control signals are active (sanity corner)
		RST_CROSS: cross RST, WR_CS, RD_CS;

	endgroup
	function new(string name="fifo_subscriber", uvm_component parent);
		super.new(name, parent);
		fifo_cg = new();
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	// uvm_subscriber's write() is called automatically by the connected
	// analysis port (mon.mon_port.connect(sub.analysis_export))
	function void write(fifo_transaction t);
		tr = t;
		rst_v      = tr.rst;
		wr_cs_v    = tr.wr_cs;
		wr_en_v    = tr.wr_en;
		rd_cs_v    = tr.rd_cs;
		rd_en_v    = tr.rd_en;
		full_v     = tr.full;
		empty_v    = tr.empty;
		data_in_v  = tr.data_in;
		data_out_v = tr.data_out;

		fifo_cg.sample();
	endfunction

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("SUBSCRIBER",
			$sformatf("Functional Coverage = %0.2f%%", fifo_cg.get_coverage()),
			UVM_LOW)
	endfunction

endclass
