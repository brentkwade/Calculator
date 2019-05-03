
library ieee;
use ieee.std_logic_1164.all;



entity clk_filter is
  port(
    clk_in : in std_logic;
    clk_out : out std_logic;
    S: in std_logic;
    trigger: in std_logic
  );
end entity clk_filter;

architecture structural of clk_filter is
  component dff is
     port(
      clk : in std_logic;
      R : in std_logic;
      D : in std_logic;
      Q : out std_logic
     );
  end component dff;
  component dl is
     port(
      E : in std_logic;
      D : in std_logic;
      Q : out std_logic
     );
  end component dl;

signal Q0 : std_logic := '1';
signal Q1, Q2, Q4, D3, D4 : std_logic := '1';
signal Q3 : std_logic := '1';
begin
  dff0 : dff port map(clk_in, Q3, '1', Q0);
  dff1 : dff port map(clk_in, Q4, Q0, Q1);
  dff2 : dff port map(clk_in, '0', Q1, Q2);
  dl0 : dl port map(clk_in, D3, Q3);
  dl1 : dl port map(clk_in, D4, Q4);

  D3 <= S and D4;
  D4 <= trigger and Q2 and Q1 and Q0;
  clk_out <= Q2 and clk_in after 1 ps;
end architecture structural;



library ieee;
use ieee.std_logic_1164.all;

entity dff is
   port(
      clk : in std_logic;
      R : in std_logic;
      D : in std_logic;
      Q : out std_logic
   );
end entity dff;
architecture behavioral of dff is
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



library ieee;
use ieee.std_logic_1164.all;

entity dl is
   port(
      E : in std_logic;
      D : in std_logic;
      Q : out std_logic
   );
end entity dl;
architecture behavioral of dl is
  signal t : std_logic := '0';
begin
   with E select t<=
    D when '1',
    t when others;
   Q<=t;
end architecture behavioral;