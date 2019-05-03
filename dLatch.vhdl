library ieee;
use ieee.std_logic_1164.all;

entity dLatch is
   port(
      E : in std_logic;
      D : in std_logic;
      Q : out std_logic
   );
end entity dLatch;
architecture behavioral of dLatch is
  signal t : std_logic := '0';
begin
   with E select t<=
    D when '1',
    t when others;
   Q<=t;
end architecture behavioral;