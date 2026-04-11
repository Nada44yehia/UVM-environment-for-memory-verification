import pack1::*;
`include "uvm_macros.svh"
import uvm_pkg::*;
class my_monitor extends uvm_monitor;
   // Factory Registeration
    `uvm_component_utils(my_monitor) 
   virtual intf  in1;
    my_sequence_item seq_item ;
  
    uvm_analysis_port #(my_sequence_item) analysis_port_mon;
     // Factory Construction
        function new(string name = "my_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
           
            analysis_port_mon= new("analysis_port_mon", this);

            if(!uvm_config_db #(virtual intf)::get(this, "", "my_vif", in1)) begin 
        `uvm_fatal(get_full_name(),"Could not get the virtual interface from the database inside Monitor");
            end
        endfunction

     // Connect Phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		$display("MONITOR: Connect Phase...");
	endfunction

        task run_phase (uvm_phase phase);
           super.run_phase(phase);
		$display("MONITOR: Run Phase...");
            forever begin
                @(posedge in1.clk);
                seq_item = my_sequence_item::type_id::create("seq_item");
                seq_item.write_enable = in1.write_enable;
                seq_item.read_enable = in1.read_enable;
                seq_item.Data_in  = in1.Data_in;
                seq_item.Address = in1.Address;
                if (in1.read_enable && !in1.write_enable) begin
                @(posedge in1.clk);
                seq_item.Data_out   = in1.Data_out;
                seq_item.Valid_out  = in1.Valid_out;
                end
       $display("T = %0t [Monitor] \t Address = %0d \t Wr_En = %0d \t Data_in = %0h \t Rd_En = %0d \t Data_out = %0h \t valid_out = %0h",
              $time, seq_item.Address, seq_item.write_enable, seq_item.Data_in, seq_item.read_enable, seq_item.Data_out,seq_item.Valid_out);
              
    $display(" --------------------------------------------------------- ");
                analysis_port_mon.write(seq_item);

            end
        endtask 
  

  endclass
