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
class sek2_sequence extends uvm_sequence #(sequence_item);
   `uvm_object_utils(sek2_sequence);

   function new(string name = "fibonacci");
      super.new(name);
   endfunction : new
   

   task body();
      byte unsigned temp_A = 11;
      byte unsigned temp_B = 200;

      sequence_item command;
      
      command = sequence_item::type_id::create("command");
         
      start_item(command);
      command.op = rst_op;
      finish_item(command);

      for(int ff = 0; ff<10; ff++) begin 
       start_item(command);
       command.A = temp_A;
       command.B = temp_B;
       if (ff % 2 == 0)
         command.op = add_op;
       else
         command.op = mul_op;
       finish_item(command);

       temp_A = temp_A + 3;
       temp_B = temp_B - 7;

       `uvm_info("Sekvenca2", $sformatf("%s", command.convert2string), UVM_MEDIUM)

      end 
   endtask : body
endclass : sek2_sequence



