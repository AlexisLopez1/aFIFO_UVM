class random_driver extends uvm_driver #(REPEAT = 25);

    `uvm_component_utils(random_driver)

    virtual interface fifo_if itf;
    scoreboard sb;

    function new(string name = "random_driver", uvm_component parent = null );
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
        repeat (REPEAT)	@(posedge wr_clk) push_generate();
	    repeat (REPEAT)	@(posedge rd_clk) pop_generate();
    endtask

    task push_generate();
        itf.push = $random_range(0,1);
        itf.data_in = $random();

        if (itf.push == PUSH && itf.full != 1)
            sb.run(.p(1), .data(itf.data_in));
    endtask
    
    task pop_generate();
        itf.pop = $random_range(0,1);
        
        if (itf.pop == POP && itf.empty != 1)
           sb.run(.p(0));
    endtask

endclass