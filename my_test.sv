import pack1::*;
`include "uvm_macros.svh"
import uvm_pkg::*;
class my_test extends uvm_test;
  // Factory Registeration
    `uvm_component_utils(my_test)
    my_env env_inst;
    my_sequence_write_only seq_inst1;
    my_sequence_read_only seq_inst2;
    my_sequence_write_read seq_inst3;
    virtual intf  in1;

  
    // Factory Construction
    function new(string name = "my_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    // Build phase
     function void build_phase(uvm_phase phase);
      super.build_phase(phase);
        // Factory Creation
        env_inst = my_env::type_id::create("env_inst",this);
        seq_inst1 =my_sequence_write_only::type_id::create("seq_inst1");
        seq_inst2 =my_sequence_read_only::type_id::create("seq_inst2");
        seq_inst3 =my_sequence_write_read::type_id::create("seq_inst3");
 
     if(!uvm_config_db #(virtual intf)::get(this, "", "my_vif", in1)) begin 
         `uvm_fatal(get_full_name(),"Could not get the virtual interface from the database inside Test");
            end
            uvm_config_db #(virtual intf)::set(this, "env_inst", "my_vif",in1);
     endfunction

    // Connect Phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		$display("TEST: Connect Phase...");
	endfunction

    // Run Phase
    task run_phase(uvm_phase phase);
		phase.raise_objection(this);
                seq_inst1.start(env_inst.agent_inst.sequencer_inst);
                seq_inst2.start(env_inst.agent_inst.sequencer_inst);
                seq_inst3.start(env_inst.agent_inst.sequencer_inst);
                phase.drop_objection(this);
    
		$display("TEST: Run Phase...");
	endtask

  endclass
