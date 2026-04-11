
`include "uvm_macros.svh"
import uvm_pkg::*;
import pack1::*;
class my_sequence_read_only extends uvm_sequence #(my_sequence_item);
        `uvm_object_utils(my_sequence_read_only);

        my_sequence_item seq_item;

        function new(string name = "my_sequence_read_only");
            super.new(name);
        endfunction

       task pre_body;
           seq_item = my_sequence_item::type_id::create("seq_item");
       endtask

        task body;
            repeat(16) begin                
               start_item(seq_item);
                if (!seq_item.randomize() with {
                write_enable == 0;
                read_enable  == 1;
 
            }) $fatal("Read Randomization failed");
           
               finish_item(seq_item);
            end
        endtask
    endclass 
