class assert_environment extends uvm_env;

    `uvm_component_utils(assert_environment)    

    assert_driver dvr;
    scoreboard sb;
    printer prnt;

    function new(string name = "assert_environment", uvm_component parent = null );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        dvr = assert_driver::type_id::create("dvr",this);
        sb  = scoreboard::type_id::create("sb",this);
        prnt = printer::type_id::create("prnt",this);
    endfunction
endclass