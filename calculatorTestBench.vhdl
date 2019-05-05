library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

entity calculatorTestBench is --test bench has no interface
end entity calculatorTestBench;

architecture structural of calculatorTestBench is

component calculator is
  port(
    I : in std_logic_vector(7 downto 0); 
    clock : in std_logic
  );
end component calculator;

signal I : std_logic_vector(7 downto 0);
signal clock : std_logic;

begin
    calculator_0 : calculator port map(I, clock);

    process
      file testFile : text is in "calculatorTest.txt"; 
      variable testLine : line;
      variable testVector : bit_vector(7 downto 0);
    begin
      wait for 999 ps; 
      while (not(endfile(testFile))) loop 
        clock <= '0';

        readline(testFile, testLine); 
        read(testLine, testVector); 
        I <= to_stdlogicvector(testVector); 

        wait for 1 ns;
        clock <= '1';
        wait for 1 ns;

      end loop;
      wait;
    end process;
end architecture structural;