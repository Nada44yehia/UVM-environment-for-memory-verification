

`include "uvm_macros.svh"
import uvm_pkg::*;
import pack1::*;

module top ();

bit tb_clk;
bit tb_rst;
parameter CLK_PER=10;

// Clock Generation 
 initial begin
        forever
           #(CLK_PER/2)  tb_clk = ~tb_clk;
  end
// Memory Interface instance
intf in1(tb_clk,tb_rst);


// DUT Instantiation, connect the DUT with the interface 
     memory DUT (in1);	
initial begin
    tb_clk = 1'b0;

        // Reset Assertion
    tb_rst = 1'b1;

      
        uvm_config_db #(virtual intf)::set(null, "uvm_test_top", "my_vif", in1);
	run_test("my_test");
end

initial begin

    // Reset De-Assertion
    #2 tb_rst = 1'b0;
end
// Dump Generation
     initial
        begin
		
	$dumpfile("mem_dump.vcd");
	$dumpvars;
			
      end	
  
	
endmodule