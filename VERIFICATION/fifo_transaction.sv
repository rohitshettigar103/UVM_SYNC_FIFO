/*`include "fifo_defines.svh"
import uvm_pkg ::*;
`include "uvm_macros.svh"*/

class fifo_transaction extends uvm_sequence_item;
	
	rand bit rst;
	rand logic wr_cs;
	rand logic rd_cs;
	rand logic wr_en;
	rand logic rd_en;
	rand logic [`DW-1:0] data_in;


	logic [`DW-1:0] data_out;
	logic full;
	logic empty;


	constraint c1{
		soft rst==1'b0;
	}


	constraint c2{
		soft wr_cs dist{ 1:=80,0:=10 };
		soft rd_cs dist{ 1:=80,0:=10};
	}


	`uvm_object_utils_begin(fifo_transaction)
	`uvm_field_int(rst,UVM_ALL_ON)
	`uvm_field_int(wr_cs,UVM_ALL_ON)
	`uvm_field_int(rd_cs,UVM_ALL_ON)
	`uvm_field_int(wr_en,UVM_ALL_ON)
	`uvm_field_int(rd_en,UVM_ALL_ON)
	`uvm_field_int(data_in,UVM_ALL_ON)
	`uvm_field_int(data_out,UVM_ALL_ON)
	`uvm_field_int(full,UVM_ALL_ON)
	`uvm_field_int(empty,UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name ="fifo_transaction");
		super.new(name);
	endfunction
endclass




