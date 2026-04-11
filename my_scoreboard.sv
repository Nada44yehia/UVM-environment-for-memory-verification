import pack1::*;
`include "uvm_macros.svh"
import uvm_pkg::*;

class my_scoreboard extends uvm_scoreboard;

  // Factory Registration
  `uvm_component_utils(my_scoreboard)

  // Analysis implementation port (receives transactions from monitor)
  uvm_analysis_imp #(my_sequence_item, my_scoreboard) analysis_imp_sb;

  // Reference model: memory storage 
  my_sequence_item transq[16];

  // Constructor
  function new(string name = "my_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
       $display("SCOREBOARD: Build Phase...");

    // Create analysis port
    analysis_imp_sb = new("analysis_imp_sb", this);
  endfunction

  // Connect Phase (optional here)
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
       $display("SCOREBOARD: Connect Phase...");
  endfunction

  // ============================================
  // WRITE FUNCTION (called automatically)
  // ============================================
 

function void write(my_sequence_item seq_item_inst);

  string op;

  // Determine operation type
  if (seq_item_inst.write_enable && seq_item_inst.read_enable)
    op = "WRITE_READ";
  else if (seq_item_inst.write_enable)
    op = "WRITE";
  else if (seq_item_inst.read_enable)
    op = "READ";
  else
    op = "IDLE";

  // =========================
  // WRITE OPERATION
  // =========================
  if (seq_item_inst.write_enable) begin

    if (transq[seq_item_inst.Address] == null)
      transq[seq_item_inst.Address] = my_sequence_item::type_id::create("ref_item");

    
   transq[seq_item_inst.Address]= seq_item_inst;
  

    $display("T=%0t [SCOREBOARD][%s] STORE: addr=0x%0h data=0x%0h",
             $time, op,
             seq_item_inst.Address,
             seq_item_inst.Data_in);
  end


  // =========================
  // READ OPERATION
  // =========================
  if (!seq_item_inst.write_enable && seq_item_inst.read_enable) begin

    if (transq[seq_item_inst.Address] == null) begin

      if (seq_item_inst.Data_out != 0)
        $display("T=%0t [SCOREBOARD][%s] ERROR addr=0x%0h exp=0 act=0x%0h",
                 $time, op,
                 seq_item_inst.Address,
                 seq_item_inst.Data_out);
      else
        $display("T=%0t [SCOREBOARD][%s] PASS addr=0x%0h exp=0 act=0x%0h",
                 $time, op,
                 seq_item_inst.Address,
                 seq_item_inst.Data_out);

    end
    else begin

      if (seq_item_inst.Data_out != transq[seq_item_inst.Address].Data_in)
        $display("T=%0t [SCOREBOARD][%s] ERROR addr=0x%0h exp=0x%0h act=0x%0h",
                 $time, op,
                 seq_item_inst.Address,
                 transq[seq_item_inst.Address].Data_in,
                 seq_item_inst.Data_out);
      else
        $display("T=%0t [SCOREBOARD][%s] PASS addr=0x%0h exp=0x%0h act=0x%0h",
                 $time, op,
                 seq_item_inst.Address,
                 transq[seq_item_inst.Address].Data_in,
                 seq_item_inst.Data_out);
    end
  end


  // ============================================
  // WRITE + READ TOGETHER CHECK  
  // ============================================
  if (seq_item_inst.write_enable && seq_item_inst.read_enable) begin

    if (seq_item_inst.Data_out != 0 || seq_item_inst.Valid_out != 0)begin
      $display("T=%0t [SCOREBOARD][%s] ERROR addr=0x%0h exp_data=0 exp_valid=0 act_data=0x%0h act_valid=%0b",
               $time, op,
               seq_item_inst.Address,
               seq_item_inst.Data_out,
               seq_item_inst.Valid_out);
    end else begin
      $display("T=%0t [SCOREBOARD][%s] PASS addr=0x%0h exp_data=0 exp_valid=0 act_data=0x%0h act_valid=%0b",
               $time, op,
               seq_item_inst.Address,
               seq_item_inst.Data_out,
               seq_item_inst.Valid_out);
   end
end

endfunction
endclass