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
class sek1_sequence extends uvm_sequence #(sequence_item);
   `uvm_object_utils(sek1_sequence);

   function new(string name = "sek1");
      super.new(name);
   endfunction : new
   
   task body();
      sequence_item command;
      
      command = sequence_item::type_id::create("command");
         
      start_item(command);
      command.op = rst_op;
      finish_item(command);

      repeat (25) begin
         start_item(command);
         assert(command.randomize());
         finish_item(command);

         `uvm_info("Sekvenca1", $sformatf("%s", command.convert2string), UVM_MEDIUM)
      end 
   endtask : body
endclass : sek1_sequence



