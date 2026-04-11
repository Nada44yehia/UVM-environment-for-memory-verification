import pack1::*;
`include "uvm_macros.svh"
import uvm_pkg::*;
class my_subscriber extends uvm_subscriber #(my_sequence_item);
    // Factory Registeration
    `uvm_component_utils(my_subscriber)
    my_sequence_item seq_item;

 covergroup cvr_gp;
    // WRITE address coverage
    cp_addr_write : coverpoint seq_item.Address iff (seq_item.write_enable) {
        bins addr_bins[] = {[0:15]};
    }

    // READ address coverage
   cp_addr_read : coverpoint seq_item.Address iff (seq_item.read_enable) {
    bins addr_bins_r[] = {[0:15]};
}

    // Read enable
    cp_read : coverpoint seq_item.read_enable {
        bins read_on  = {1};
        bins read_off = {0};
    }

    // Write enable
    cp_write : coverpoint seq_item.write_enable {
        bins write_on  = {1};
        bins write_off = {0};
    }

    // Valid output
    cp_valid : coverpoint seq_item.Valid_out {
        bins valid = {1};
    }

    // =========================
    // Read/Write combination
    // =========================
    cross_rw : cross cp_read, cp_write {
        bins read_only  = binsof(cp_read)  intersect {1} &&
                          binsof(cp_write) intersect {0};

        bins write_only = binsof(cp_read)  intersect {0} &&
                          binsof(cp_write) intersect {1};

        bins read_write = binsof(cp_read)  intersect {1} &&
                          binsof(cp_write) intersect {1};
    }

  


endgroup
    // Factory Construction
    function new(string name = "my_subscriber", uvm_component parent = null);
      super.new(name, parent);
        cvr_gp = new();
    endfunction
    
   
       function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            seq_item =  my_sequence_item::type_id::create("seq_item");
        endfunction

   
     function void write(my_sequence_item t);
         seq_item=t;   
         cvr_gp.sample();
       $display("Subscriber received: Data_in: %0h, Address: %b", 
                     seq_item.Data_in, seq_item.Address);

       $display("Subscriber received: Data_out: %0h, Valid_out: %b", 
                     seq_item.Data_out, seq_item.Valid_out);
      endfunction
  endclass