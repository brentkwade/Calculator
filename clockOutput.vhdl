library ieee;
use ieee.std_logic_1164.all;

entity clockOutput is
  port(
    clockIn : in std_logic;
    clockOut : out std_logic;
    S : in std_logic;
    compareout : in std_logic
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

signal Q0 : std_logic := '1';
signal Q1, Q2, Q4, data3, data4 : std_logic := '1';
signal Q3 : std_logic := '1';
begin
  flipFlop0 : flipFlop port map(clockIn, Q3, '1', Q0);
  flipFlop1 : flipFlop port map(clockIn, Q4, Q0, Q1);
  flipFlop2 : flipFlop port map(clockIn, '0', Q1, Q2);
  dLatch0 : dLatch port map(clockIn, data3, Q3);
  dLatch1 : dLatch port map(clockIn, data4, Q4);

  data3 <= set and data4;
  data4 <= trigger and Q2 and Q1 and Q0;
  clockOut <= Q2 and clockIn after 1 ps;
end architecture structural;