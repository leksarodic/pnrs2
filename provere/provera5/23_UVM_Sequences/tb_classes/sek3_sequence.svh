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
class sek3_sequence extends uvm_sequence #(uvm_sequence_item);
   `uvm_object_utils(sek3_sequence);

   protected reset_sequence reset;
   protected sek1_sequence sek1;
   protected sek2_sequence sek2;

   function new(string name = "sek3_sequence");
      super.new(name);
      
      reset = reset_sequence::type_id::create("reset");
      sek1 = sek1_sequence::type_id::create("sek1");
      sek2 = sek2_sequence::type_id::create("sek2");
   endfunction : new

   task body();
      reset.start(m_sequencer);

      fork
	    sek1.start(m_sequencer);
   	 sek2.start(m_sequencer);
      join
   endtask : body
endclass : sek3_sequence

     