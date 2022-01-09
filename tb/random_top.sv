module random_top;
    import uvm_pkg::*;
    `include "scoreboard.svh"
    `include "printer.svh"
    `include "random_drivert.svh"
    `include "random_environment.svh"
    `include "random_test.svh"

    bit wr_clk = 1'b0;
    bit rd_clk = 1'b0;
    bit wr_rst = 1'b1;
    bit rd_rst = 1'b1;
    
    fifo_if itf;

    fifo_top DUT (
        .wr_clk (wr_clk),
        .wr_rst (wr_rst),
        .rd_clk (rd_clk),
        .rd_rst (rd_rst),
        .itf	(itf.fifo)
    );

    initial begin
        fork
            forever #1 wr_clk = ~wr_clk;
            forever #1 rd_clk = ~rd_clk;
        join
    end

    initial begin
        #1 wr_rst = 1'b1;
        #2 rd_rst = 1'b1;	
        #1 wr_rst = 1'b0;
        #2 rd_rst = 1'b0;	
        #1 wr_rst = 1'b1;	
        #2 rd_rst = 1'b1;
    end
   
    initial begin
        uvm_config_db#(virtual fifo_if)::set(null,"*","v_itf",itf);
        run_test("random_test");
    end

    // Dump waves
    initial begin
    $dumpfile("wave.do");
    $dumpvars(0, top);
  end

endmodule