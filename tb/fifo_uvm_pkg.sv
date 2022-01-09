`include "uvm_macros.svh"
package fifo_uvm_pkg;
    import uvm_pkg::*;
    virtual interface fifo_if itf;
    
    `include "random_driver.svh"
    `include "assert_driver.svh" 
    `include "scoreboard.svh" 
    `include "printer.svh" 
    `include "random_environment.svh"
    `include "assert_environment.svh"

endpackage