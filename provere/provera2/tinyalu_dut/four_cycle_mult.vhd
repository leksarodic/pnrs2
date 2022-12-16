--   Copyright 2013 Ray Salemi
--
--   Licensed under the Apache License, Version 2.0 (the "License");
--   you may not use this file except in compliance with the License.
--   You may obtain a copy of the License at
--
--       http://www.apache.org/licenses/LICENSE-2.0
--
--   Unless required by applicable law or agreed to in writing, software
--   distributed under the License is distributed on an "AS IS" BASIS,
--   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--   See the License for the specific language governing permissions and
--   limitations under the License.
--
-- VHDL Architecture tinyalu_lib.four_cycle.mult
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY four_cycle IS
   PORT( 
      A           : IN     unsigned ( 7 DOWNTO 0 );
      B           : IN     unsigned ( 7 DOWNTO 0 );
      clk         : IN     std_logic;
      reset_n     : IN     std_logic;
      start       : IN     std_logic;
      done_four   : OUT    std_logic;
      result_four : OUT    unsigned (15 DOWNTO 0)
   );

-- Declarations

END four_cycle ;

--
architecture four of four_cycle is
  signal a_int,b_int : unsigned (7 downto 0);  -- start pipeline
  signal mult1,mult2,add1 : unsigned (15 downto 0);  -- pipeline registers
  signal done4,done3,done2,done1,done_four_int : std_logic;       -- pipeline the done signal
begin
  -- purpose: Three stage pipelined multiplier
  -- type   : sequential
  -- inputs : clk, reset_n, a,b
  -- outputs: result_mult
  four_op: process (clk, reset_n)
  begin  -- process multiplier
    if reset_n = '0' then               -- asynchronous reset (active low)
      done_four_int <= '0';
      done4 <= '0';
      done3 <= '0';
      done2 <= '0';
      done1 <= '0';
      
	  a_int <= "00000000";
	  b_int <= "00000000";
      mult1 <= "0000000000000000";
      mult2 <= "0000000000000000";
      add1 <= "0000000000000000";
      result_four <= "0000000000000000";
    elsif clk'event and clk = '1' then  -- rising clock edge
      a_int <= a;
      b_int <= b;
      mult1 <= conv_unsigned(2,8) * a_int;  -- 2*A
      mult2 <= conv_unsigned(3,8) * b_int;  -- 3*B
      add1 <= mult1 + mult2;  -- (2*A) + (3*B)
      result_four <= add1;
      done4 <= start and (not done_four_int);
      done3 <= done4 and (not done_four_int);
      done2 <= done3 and (not done_four_int);
      done1 <= done2 and (not done_four_int);
      done_four_int <= done1 and (not done_four_int);
    end if;
  end process four_op;
  done_four <= done_four_int;
end architecture four;

