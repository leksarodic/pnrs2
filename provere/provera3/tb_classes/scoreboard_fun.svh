/*
   Copyright 2013 Ray Salemi

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
class scoreboard_fun extends scoreboard;
   `uvm_component_utils(scoreboard_fun);

   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      scoreboard::type_id::set_type_override(scoreboard_fun::get_type());
   endfunction : build_phase

   task run_phase(uvm_phase phase);
      shortint predicted_result;
      ;
      forever begin : self_checker
         @(posedge bfm.done)
	   #1;
           case (bfm.op_set)
             fun_op: predicted_result = bfm.A + (4 * bfm.B);
           endcase // case (op_set)
         
         if ((bfm.op_set != no_op) && (bfm.op_set != rst_op))
           if (predicted_result != bfm.result)
             $error ("FAILED: A: %0h  B: %0h  op: %s result: %0h",
                     bfm.A, bfm.B, bfm.op_set.name(), bfm.result);

      end : self_checker
   endtask : run_phase

endclass : scoreboard_fun
