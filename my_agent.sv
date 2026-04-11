import pack1::*;
`include "uvm_macros.svh"
import uvm_pkg::*;
class my_agent extends uvm_agent;
   // Factory Registeration
    `uvm_component_utils(my_agent) 
    my_sequencer sequencer_inst;
    my_driver driver_inst;
    my_monitor monitor_inst;
    uvm_analysis_port #(my_sequence_item) analysis_port_ag;
    virtual intf  in1;
    // Factory Construction
    function new(string name = "my_agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    // Build phase
     function void build_phase(uvm_phase phase);
        super.build_phase(phase);
       
        sequencer_inst = my_sequencer::type_id::create("sequencer_inst",this);
        driver_inst= my_driver::type_id::create("driver_inst",this);
        monitor_inst= my_monitor::type_id::create("monitor_inst",this);
        analysis_port_ag=new("analysis_port_ag", this);
       if(!uvm_config_db #(virtual intf)::get(this, "", "my_vif", in1)) begin 
        `uvm_fatal(get_full_name(),"Could not get the virtual interface from the database inside agent");
            end
          uvm_config_db #(virtual intf)::set(this, "monitor_inst", "my_vif",in1);
          uvm_config_db #(virtual intf)::set(this, "driver_inst", "my_vif",in1);
     endfunction

    // Connect Phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		$display("AGENT: Connect Phase...");
                driver_inst.seq_item_port.connect(sequencer_inst.seq_item_export);
                monitor_inst.analysis_port_mon.connect(analysis_port_ag);
	endfunction


  endclass
