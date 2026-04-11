import pack1::*;
`include "uvm_macros.svh"
import uvm_pkg::*;
class my_env extends uvm_env;
   // Factory Registeration
    `uvm_component_utils(my_env)
 
  my_agent agent_inst;
  my_subscriber sub_inst;
  my_scoreboard sb_inst;
  virtual intf  in1;

    // Factory Construction
    function new(string name = "my_env", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    // Build phase
     function void build_phase(uvm_phase phase);
      super.build_phase(phase);
        // Factory Creation
        agent_inst  = my_agent::type_id::create("agent_inst",this);
        sub_inst  = my_subscriber::type_id::create("sub_inst",this);
        sb_inst  = my_scoreboard::type_id::create("sb_inst",this);

   if(!uvm_config_db #(virtual intf)::get(this, "", "my_vif", in1)) begin 
        `uvm_fatal(get_full_name(),"Could not get the virtual interface from the database inside Env");
            end
            uvm_config_db #(virtual intf)::set(this, "agent_inst", "my_vif",in1);
     endfunction
                                        


    // Connect Phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		$display("ENVIROMENT: Connect Phase...");
                 agent_inst.analysis_port_ag.connect(sub_inst.analysis_export);
                 agent_inst.analysis_port_ag.connect(sb_inst.analysis_imp_sb);
	endfunction



  endclass
