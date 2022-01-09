class random_test extends uvm_test;

    `uvm_component_utils(random_test)    
    random_env t_env;

    function new(string name = "random_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        env = random_environment::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        begin
            random_environment env;
            env = random_environment::type_id::create("env",this);
            `uvm_info("",$sformatf("inside test"),UVM_LOW);
            env.start(dvr);//**
        end
        phase.drop_objection(this);
    endtask
   
endclass