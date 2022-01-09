class printer extends uvm_monitor;

    `uvm_component_utils(printer)

    virtual interface fifo_if itf;

    function new(string name = "printer", uvm_component parent = null );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_itf)::get(this, "", "fifo_if", itf)) begin
            `uvm_error("", "uvm_config_db::get failed")
        end
    endfunction

   task run_phase(uvm_phase phase);
      super.run_phase(phase);

   endtask

    task message_handling(int msg_code);
        case (msg_code)
            0: `uvm_info("", $sformatf(" SUCCESS: Expected = %h, Obtained = %h", expected_value, itf.data_out), UVM_LOW);
            1: `uvm_info("", $sformatf(" SUCCESS: Last value: %h, Empty: %b", itf.data_out, itf.empty), UVM_LOW);            
            2: `uvm_info("", $sformatf(" ERROR: Expected = %h, Obtained = %h", expected_value, itf.data_out), UVM_LOW);
            3: `uvm_info("", $sformatf(" ERROR: OVERFLOW - FULL flag is down. Expected = xx, Obtained = %b", itf.data_out), UVM_LOW);
            4: `uvm_info("", $sformatf(" ERROR: OVERFLOW - Expected = xx, Obtained = %b", itf.data_out), UVM_LOW);
            5: `uvm_info("", $sformatf(" ERROR: UNDERFLOW - EMPTY flag is down and DATA_OUT is different than the expected value. Expected = %h, Obtained = %h", last_value, itf.data_out), UVM_LOW);
            6: `uvm_info("", $sformatf(" ERROR: UNDERFLOW - DATA_OUT is different than the expected value. Expected = %h, Obtained = %h", last_value, itf.data_out), UVM_LOW);
            7: `uvm_info("", $sformatf(" ERROR: UNDERFLOW - EMPTY flag is down. Expected = %h, Obtained = %h", last_value, itf.data_out), UVM_LOW);
        endcase
    endtask

endclass