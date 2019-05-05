library ieee;
use ieee.std_logic_1164.all;

entity dLatch is
   port(
      enable : in std_logic;
      data : in std_logic;
      Q : out std_logic
   );
end entity dLatch;
architecture behavioral of dLatch is
  signal t : std_logic := '0';
begin
   with enable select t<=
    data when '1',
    t when others;
   Q <= t;
end architecture behavioral;