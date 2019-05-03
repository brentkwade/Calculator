library ieee;
use ieee.std_logic_1164.all;

entity flipFlop is
   port(
      clk : in std_logic;
      R : in std_logic;
      D : in std_logic;
      Q : out std_logic
   );
end entity flipFlop;
architecture behavioral of flipFlop is
  signal qt : std_logic :='1';
begin
   process (clk,R) is
   begin
      if (R = '1') then
        qt <= '0';
      elsif clk'event and clk = '1' then
          qt <= D;
      end if;
   end process;
   Q<=qt;
end architecture behavioral;
