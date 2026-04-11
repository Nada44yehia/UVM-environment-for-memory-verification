import pack1::*;
`include "uvm_macros.svh"
import uvm_pkg::*;
class my_sequence_item extends uvm_sequence_item;

 `uvm_object_utils(my_sequence_item) 

  function new(string name = "my_sequence_item");
    super.new(name);
  endfunction

  rand bit [31:0] Data_in;
  randc bit [3:0] Address;
  rand bit        write_enable;
  rand bit        read_enable;
  bit [31:0]      Data_out;
  bit             Valid_out;
  

		
endclass 