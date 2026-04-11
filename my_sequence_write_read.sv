
`include "uvm_macros.svh"
import uvm_pkg::*;
import pack1::*;
class my_sequence_write_read extends uvm_sequence #(my_sequence_item);
        `uvm_object_utils(my_sequence_write_read);

        my_sequence_item seq_item;

        function new(string name = "my_sequence_write_read");
            super.new(name);
        endfunction

       task pre_body;
           seq_item = my_sequence_item::type_id::create("seq_item");
       endtask

        task body;
            repeat(16) begin                
               start_item(seq_item);
                if (!seq_item.randomize() with {
                write_enable dist {1 := 30, 0 := 70};
                read_enable  dist {1 := 70, 0 := 30};
            }) $fatal("Mixed Randomization failed");

               finish_item(seq_item);
            end
        endtask
    endclass 
