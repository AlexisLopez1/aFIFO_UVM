class assert_driver extends uvm_driver #(REPEAT = 25);

    `uvm_component_utils(assert_driver)

    virtual interface fifo_if itf;
    scoreboard sb;

    function new(string name = "assert_driver", uvm_component parent = null );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_itf)::get(this, "", "fifo_if", itf)) begin
            `uvm_error("", "uvm_config_db::get failed")
        end
        sb  = scoreboard::type_id::create("sb",this);
    endfunction

    task run_phase(uvm_phase phase);
         assert property (@ (posedge clk) disable iff(!itf.push) itf.push | -> ( itf.data_in = $random()));
         assert property (@ (posedge clk) disable iff(!itf.push) itf.push | -> ( sb.run(.p(1), .data(itf.data_in))));

         assert property (@ (posedge clk) disable iff(!itf.pop) itf.pop | -> ( sb.run(.p(0))));
    endtask
      
endclass