class scoreboard extends uvm_scoreboard;
    import fifo_pkg::*;
   `uvm_component_utils(scoreboard)    

    virtual interface fifo_if itf;
    printer prnt;
    data_t Q[$];
    data_t expected_value;

    function new(string name = "scoreboard", uvm_component parent = null );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_itf)::get(this, "", "fifo_if", itf)) begin
            `uvm_error("", "uvm_config_db::get failed")
        end
        prnt = printer::type_id::create("prnt",this);
    endfunction

    task run(bit p, data_t data = 0);
        if (p) begin
            Q.push_front(data);
        end
        else begin
            expected_value = Q.pop_back();
            golden_model();
        end

    endtask

    task golden_model();
    	if (Q.size >= 1) expected_push_pop();
    	
    	if (Q.size() >= DEPTH) begin
		overflow();
    	end
    	else if (Q.size() <= 1) begin
    		if (Q.size() == 1) begin last_value = itf.data_out;
    		end
               underflow();
        end
    endtask

    task expected_push_pop();
        msg_code =  (expected_value !== itf.data_out) ? 2 : 0;
        prnt.message_handling(msg_code);
    endtask
    
    task overflow();
	    msg_code = (itf.full != 1) ? 3 : 4;
    endtask
	
    task underflow();
    	#0.1
    	if (Q.size() === 0) begin
            msg_code =  (itf.data_out !== last_value && itf.empty != 1)	? 5 :
            		 (itf.data_out !== last_value)			? 6 : 
                        (itf.empty != 1)					? 7 : 1;
        end
        prnt.message_handling(msg_code);
    endtask

endclass