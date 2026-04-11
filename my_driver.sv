import pack1::*;
`include "uvm_macros.svh"
import uvm_pkg::*;
class my_driver extends uvm_driver #(my_sequence_item);
     // Factory Registeration
    `uvm_component_utils(my_driver) 

    virtual intf  in1;
    my_sequence_item seq_item ;
    // Factory Construction
    function new(string name = "my_driver", uvm_component parent = null);
      super.new(name, parent);
    endfunction

     function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            seq_item = my_sequence_item::type_id::create("seq_item");

       if(!uvm_config_db #(virtual intf)::get(this, "", "my_vif", in1)) begin 
        `uvm_fatal(get_full_name(),"Could not get the virtual interface from the database inside Driver");
            end
        endfunction

    // Connect Phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		$display("DRIVER: Connect Phase...");
	endfunction

         task run_phase (uvm_phase phase);
          super.run_phase(phase);
          $display("DRIVER: Run Phase...");
            forever begin
                seq_item_port.get_next_item(seq_item);
                // driving inputs of interface 
               in1.write_enable = seq_item.write_enable;
	       in1.read_enable = seq_item.read_enable;
               in1.Data_in=  seq_item.Data_in;
               in1.Address=  seq_item.Address;
    $display("T = %0t [Driver] \t Address = %0d \t Wr_En = %0d \t Data_in = %0h \t Rd_En = %0d \t Data_out = %0h",
              $time, seq_item.Address, seq_item.write_enable, seq_item.Data_in, seq_item.read_enable, seq_item.Data_out);
              
    $display(" --------------------------------------------------------- ");
               
                @(posedge in1.clk);
               if( seq_item.read_enable && !seq_item.write_enable)
                  @(posedge in1.clk );
                seq_item_port.item_done();
               
            end
        endtask
  endclass
