library ieee;
use ieee.std_logic_1164.all;

entity clockOutput is
  port(
    clockIn : in std_logic;
    clockOut : out std_logic;
    S : in std_logic;
    compare_filter : in std_logic
  );
end entity clockOutput;

architecture structural of clockOutput is
  component flipFlop is
     port(
      clock : in std_logic;
      reset : in std_logic;
      D : in std_logic;
      Q : out std_logic
     );
  end component flipFlop;
  component dLatch is
     port(
      E : in std_logic;
      D : in std_logic;
      Q : out std_logic
     );
  end component dLatch;

signal not_sum : std_logic;
signal Q1, Q2 : std_logic := '1';

begin
  dLatch : dLatch port map(clockIn, not_carry, Q1);
  flipFlop : flipFlop port map(clockIn, not_sum, Q1, Q2);
  
  not_sum <=  not(S xor compare_filter);
  not_carry <= not(S and (S xor compare_filter));
  

  clockOut <= Q2 and Q1 after 1 ps;

end architecture structural;